from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
import pandas as pd
import numpy as np
import psycopg2
import joblib
import logging
import xgboost as xgb
from datetime import datetime

import os

port = int(os.environ.get("PORT", 8000))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("fastapi_app:app", host="0.0.0.0", port=port, reload=True)


# === FastAPI Setup ===
app = FastAPI(
    title="Fraud Detection API",
    description="Detects fraud in transactions using XGBoost"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["GET", "POST"],
    allow_headers=["*"],
)

# === Logging ===
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("fastapi_app")

# === Load Model and Preprocessing Artifacts ===
try:
    model = xgb.XGBClassifier()
    model.load_model("xgboost_fraud_model.json")
    scaler = joblib.load("scaler.pkl")
    pca = joblib.load("pca.pkl")
    encoded_columns = joblib.load("encoded_columns.pkl")
    logger.info("✅ Model, scaler, PCA, and columns loaded successfully")
except Exception as e:
    logger.error(f"❌ Failed to load model or preprocessors: {e}")
    raise

# === Database Connection ===
def get_db_connection():
    try:
        return psycopg2.connect(
            dbname="Fraudsense_DB",
            user="postgres",
            password="256Tiwaj?",
            host="localhost"
        )
    except Exception as e:
        logger.error(f"Database connection failed: {e}")
        raise HTTPException(status_code=500, detail="Database connection failed")

# === Schemas ===
class Transaction(BaseModel):
    step: int
    transaction_id: str
    transaction_type: str
    channel: str
    device_type: str
    network_provider: str
    time_of_day: str
    day_of_week: str
    amount: float
    customer_id: str
    customer_type: str
    customer_region: str
    old_balance: float
    new_balance: float
    recipient_id: str
    recipient_type: str
    recipient_region: str
    recipient_old_balance: float
    recipient_new_balance: float
    isFlaggedFraud: int

class PredictionResponse(BaseModel):
    fraud_probability: float
    is_fraud: bool
    status: str
    error: Optional[str] = None

# === /predict Endpoint ===
@app.post("/predict", response_model=PredictionResponse)
async def predict(transaction: Transaction):
    try:
        logger.info(f"Processing transaction: {transaction.dict()}")

        txn_dict = transaction.dict()
        df = pd.DataFrame([txn_dict])

        # One-hot encode object columns
        cat_cols = df.select_dtypes(include='object').columns
        df_categoricals = pd.get_dummies(df[cat_cols], drop_first=True)
        df_encoded = pd.concat([df.drop(columns=cat_cols), df_categoricals], axis=1)

        # Align features
        df_encoded = df_encoded.reindex(columns=encoded_columns, fill_value=0)

        # Scale and apply PCA
        X_scaled = scaler.transform(df_encoded)
        X_pca = pca.transform(X_scaled)

        # Predict
        fraud_prob = float(model.predict_proba(X_pca)[:, 1])
        is_fraud = fraud_prob > 0.5

        # Save alert if fraud/suspicious detected
        if fraud_prob > 0.7:
            conn = get_db_connection()
            cursor = conn.cursor()
            insert_query = """
            INSERT INTO alerts (transaction_id, amount, alert_type, severity, description, created_at, status)
            VALUES (%s, %s, %s, %s, %s, NOW(), %s)
            """
            alert_type = 'Fraud Detected' if fraud_prob > 0.85 else 'Suspicious Activity'
            severity = 'High' if fraud_prob > 0.85 else 'Medium'
            description = f"Fraud probability: {fraud_prob:.4f}"
            cursor.execute(insert_query, (
                transaction.transaction_id,
                transaction.amount,
                alert_type,
                severity,
                description,
                'Unresolved'
            ))
            conn.commit()
            cursor.close()
            conn.close()

        return {
            "fraud_probability": round(fraud_prob, 4),
            "is_fraud": is_fraud,
            "status": "success"
        }

    except Exception as e:
        logger.error(f"Prediction failed: {e}", exc_info=True)
        return {
            "fraud_probability": 0.0,
            "is_fraud": False,
            "status": "error",
            "error": str(e)
        }

# === /alerts Endpoint ===
@app.get("/alerts")
def get_alerts():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT 
                a.id,
                a.transaction_id,
                a.amount,
                a.alert_type,
                a.severity,
                a.description,
                a.created_at,
                a.resolved_at,
                a.status
            FROM alerts a
            ORDER BY a.created_at DESC;
        """)
        rows = cursor.fetchall()
        columns = [desc[0] for desc in cursor.description]

        result = []
        for row in rows:
            alert = dict(zip(columns, row))
            desc = alert.get("description", "")
            try:
                if "Fraud probability" in desc:
                    prob_str = desc.split(":")[-1].strip()
                    alert["fraud_prob"] = float(prob_str)
                else:
                    alert["fraud_prob"] = 0.0
            except:
                alert["fraud_prob"] = 0.0

            alert["timestamp"] = alert.get("created_at")
            alert["resolved"] = alert.get("status", "").lower() == "resolved"
            result.append({
                "transactionId": alert.get("transaction_id"),
                "amount": alert.get("amount", 0.0),
                "fraud_prob": alert.get("fraud_prob", 0.0),
                "timestamp": alert.get("timestamp"),
                "resolved": alert.get("resolved")
            })

        cursor.close()
        conn.close()
        return result

    except Exception as e:
        logger.error(f"[ERROR] /alerts failed: {e}")
        raise HTTPException(status_code=500, detail="Failed to retrieve alerts")


@app.get("/api/alerts/recent")
def get_recent_alerts():
    conn = psycopg2.connect(
        dbname="Fraudsense_DB",
        user="postgres",
        password="256Tiwaj?",
        host="localhost",
        port="5432"
    )
    cursor = conn.cursor()
    cursor.execute("""
        SELECT created_at, status, description, probability 
        FROM alerts 
        ORDER BY created_at DESC 
        LIMIT 10
    """)
    results = cursor.fetchall()
    conn.close()
    return [
        {
            "timestamp": row[0],
            "status": row[1],
            "description": row[2],
            "confidence": row[3]
        }
        for row in results
    ]

# === Health Check ===
@app.get("/health")
async def health_check():
    return {"status": "healthy", "model_loaded": bool(model)}
