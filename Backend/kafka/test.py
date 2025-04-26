import requests

test_transaction = {
    "step": 1,
    "type": "TRANSFER",
    "amount": 500.0,
    "nameOrig": "C12345",
    "oldbalanceOrg": 1000.0,
    "newbalanceOrig": 500.0,
    "nameDest": "M67890",
    "oldbalanceDest": 0.0,
    "newbalanceDest": 500.0,
    "isFlaggedFraud": 0
}

res = requests.post("http://127.0.0.1:8000/predict", json=test_transaction)
print(res.status_code, res.json())
