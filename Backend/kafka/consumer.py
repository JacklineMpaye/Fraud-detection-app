from kafka import KafkaConsumer
import requests
import json
from datetime import datetime
import psycopg2

# === PostgreSQL Setup ===
conn_postgres = psycopg2.connect(
    dbname="fraudsense_db",
    user="fraud_admin",
    password="yourpassword",
    host="localhost"
    port="5432"
    
)
cursor = conn_postgres.cursor()

# === Kafka Consumer Setup ===
consumer = KafkaConsumer(
    'test',
    bootstrap_servers='localhost:9092',
    value_deserializer=lambda x: json.loads(x.decode('utf-8'))
)

print("Kafka consumer started. Waiting for transactions...")

# === Log alert to alerts table ===
def log_alert_to_postgres(transaction_db_id, transaction_info, fraud_prob):
    try:
        cursor.execute("""
            INSERT INTO alerts (
                transaction_id,
                amount,
                alert_type,
                severity,
                description,
                created_at,
                status
            ) VALUES (%s, %s, %s, %s, %s, NOW(), %s)
        """, (
            transaction_info.get("transaction_id"),
            transaction_info.get("amount", 0.0),
            'Fraud Detected' if fraud_prob > 0.85 else 'Suspicious Activity',
            'High' if fraud_prob > 0.85 else 'Medium',
            f"Fraud probability: {fraud_prob:.4f}",
            'Unresolved'
        ))
        conn_postgres.commit()
        print(f"[ALERT] Logged alert for DB transaction_id: {transaction_info['transaction_id']}")
    except Exception as e:
        conn_postgres.rollback()
        print(f"[ERROR] Failed to insert alert: {e}")

# === Main Loop ===
for message in consumer:
    tx = message.value

    # Generate fallback transaction ID
    if 'transaction_id' not in tx or not tx['transaction_id']:
        tx['transaction_id'] = f"auto_txn_{int(datetime.utcnow().timestamp())}"

    print(f"[RECEIVED] Transaction ID: {tx['transaction_id']}")

    # Rename and align field names to match FastAPI schema
    tx["old_balance"] = tx.pop("oldbalanceOrg", 0.0)
    tx["new_balance"] = tx.pop("newbalanceOrig", 0.0)
    tx["recipient_old_balance"] = tx.pop("oldbalanceDest", 0.0)
    tx["recipient_new_balance"] = tx.pop("newbalanceDest", 0.0)
    tx["transaction_type"] = tx.pop("type", "TRANSFER")

    # Fill in missing fields
    defaults = {
        "channel": "App",
        "device_type": "Android",
        "network_provider": "MTN",
        "time_of_day": "Afternoon",
        "day_of_week": "Monday",
        "customer_id": tx.get("nameOrig", "C00000"),
        "customer_type": "Individual",
        "customer_region": "Greater Accra",
        "recipient_id": tx.get("nameDest", "R00000"),
        "recipient_type": "Merchant",
        "recipient_region": "Ashanti",
        "isFlaggedFraud": tx.get("isFlaggedFraud", 0)
    }

    for key, value in defaults.items():
        tx.setdefault(key, value)

    # === STEP 1: Predict via FastAPI ===
    try:
        response = requests.post('http://localhost:8000/predict', json=tx, timeout=5)
        response.raise_for_status()
        result = response.json()
        fraud_prob = result.get("fraud_probability", 0.0)
        print(f"[PREDICT] Fraud probability: {fraud_prob * 100:.2f}%")
    except Exception as e:
        print(f"[ERROR] During prediction or logging: {e}")
        continue

    # === STEP 2: Log transaction to DB ===
    try:
        cursor.execute("""
            INSERT INTO transactions (transaction_id, amount, merchant, timestamp, currency)
            VALUES (%s, %s, %s, %s, %s)
            RETURNING id
        """, (
            tx.get("transaction_id"),
            tx.get("amount", 0.0),
            tx.get("transaction_type", "TRANSFER"),
            datetime.now(),
            tx.get("currency", "GHS")
        ))
        transaction_db_id = cursor.fetchone()[0]
        conn_postgres.commit()
        print(f"[INFO] Transaction logged with DB ID: {transaction_db_id}")
    except Exception as e:
        conn_postgres.rollback()
        print(f"[ERROR] Failed to log transaction: {e}")
        continue

    # === STEP 3: Log alert if fraud is likely ===
    if fraud_prob > 0.85:
        log_alert_to_postgres(transaction_db_id, tx, fraud_prob)
