import pandas as pd
from kafka import KafkaProducer
import json
import time

# Load your dataset
df = pd.read_csv('smart_synthetic_mobile_money.csv')

# Initialize Kafka producer
producer = KafkaProducer(
    bootstrap_servers='localhost:9092',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

# Only send exactly what FastAPI expects
for index, row in df.iterrows():
    transaction = {
        "step": int(row["step"]),
        "transaction_id": row["transaction_id"],
        "transaction_type": row["transaction_type"],
        "channel": row["channel"],
        "device_type": row["device_type"],
        "network_provider": row["network_provider"],
        "time_of_day": row["time_of_day"],
        "day_of_week": row["day_of_week"],
        "amount": float(row["amount"]),
        "customer_id": row["customer_id"],
        "customer_type": row["customer_type"],
        "customer_region": row["customer_region"],
        "old_balance": float(row["old_balance"]),
        "new_balance": float(row["new_balance"]),
        "recipient_id": row["recipient_id"],
        "recipient_type": row["recipient_type"],
        "recipient_region": row["recipient_region"],
        "recipient_old_balance": float(row["recipient_old_balance"]),
        "recipient_new_balance": float(row["recipient_new_balance"]),
        "isFlaggedFraud": int(row["isFlaggedFraud"])
    }

    producer.send("test", transaction)
    print(f"[ SENT] Transaction {index + 1}")
    time.sleep(0.1)
