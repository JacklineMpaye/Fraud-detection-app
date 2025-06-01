# 🚨 FraudSense – Mobile Money Fraud Detection System

FraudSense is a real-time fraud detection system tailored to the mobile money ecosystem. It integrates Apache Kafka, XGBoost, FastAPI, PostgreSQL, and a Flutter web dashboard to help banks and regulators identify fraudulent transactions as they happen.

---

## 📁 Project Structure

- **Backend/** – Python-based backend logic  
  - `kafka/` – Kafka producer & consumer  
  - `model_serving/` – Model loading and prediction  
  - `venv/` – Python virtual environment  
  - `requirements.txt` – Python package dependencies  
  - `test.json` – Sample transaction data  

- **lib/** – Flutter app logic and UI components  
- **assets/** – Images and design assets  
- **android/**, **ios/**, **macos/**, **linux/**, **web/** – Platform-specific Flutter targets  
- **test/** – Testing files  
- **pubspec.lock** – Flutter dependency lock file  

---

## 🔑 Key Features

- Real-time fraud detection using Kafka streaming  
- ML model powered by XGBoost  
- REST API built with FastAPI  
- Flutter web dashboard for alerts  
- PostgreSQL for alert storage and reporting  
- Deployment-ready on DigitalOcean  

---

## 💻 Technology Stack

- **Backend**: Python, FastAPI, Kafka, XGBoost  
- **Frontend**: Flutter (Web)  
- **Database**: PostgreSQL  
- **DevOps**: DigitalOcean, SCP, pm2/systemctl  

---

## 🚀 Getting Started

### 📦 1. Clone the Repository
```bash
git clone https://github.com/JacklineMpaye/Fraud-detection-app.git
cd Fraud-detection-app
```

---

## 🛠️ Backend Setup

```bash
cd Backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn fastapi_app:app --reload
```

---

## 🗄️ PostgreSQL Setup

Create a new database:
```bash
psql -U postgres
CREATE DATABASE fraudsense_db;
```

Restore the schema:
```bash
psql -U postgres -d fraudsense_db < fraudsense_backup.sql
```

---

## 📡 Kafka Setup

Start Zookeeper and Kafka:
```bash
./bin/zookeeper-server-start.sh -daemon ./config/zookeeper.properties
./bin/kafka-server-start.sh -daemon ./config/server.properties
```

---

## 🧩 Kafka Producer & Consumer

```bash
cd Backend/kafka
python producer.py
python consumer.py
```

---

## 🖥️ Frontend (Flutter Web)

```bash
cd Flutter-App
flutter pub get
flutter run -d chrome
```

Update the `.env` file with your API base URL (e.g., your DigitalOcean IP address).

---

## 📊 Usage

- Monitor predictions in real time from the Flutter dashboard  
- Alerts are raised when the fraud probability exceeds `0.7`  
- Analyze flagged transactions and trends via the web interface  

---

## 🔮 Future Recommendations

- **Integrate with Telecom APIs** – Access real transaction data  
- **Deploy on Real-Time Pipelines** – Enable live fraud detection  
- **Add Adaptive Learning** – Allow model to learn from new patterns  
- **Implement Risk Scoring** – Prioritize alerts by severity  
- **Enable Feedback Loops** – Improve model through analyst feedback  

---

## 🤝 Contributing

To contribute:

1. Fork the repository  
2. Create a feature branch  
3. Commit your changes  
4. Open a pull request with a clear description  

---

## 🙏 Acknowledgements

Thanks to the Ashesi University Capstone Program and our mentors for their support. FraudSense was built to help fight mobile money fraud and protect digital transactions across Africa.

## Abstract
The rapid adoption of mobile money in Sub-Saharan Africa, particularly Ghana, has bolstered 
financial inclusion but also increased exposure to sophisticated fraud. Traditional detection 
methods, such as rule-based systems, struggle to address evolving threats. This study proposes 
a neural network-based anomaly detection system to enhance mobile money security by 
identifying fraudulent transactions in real time. Using a Long Short-Term Memory (LSTM) 
model trained on transactional data, the system achieves high accuracy (94.2%), precision 
(89.7%), and recall (87.8%), outperforming conventional approaches. Designed as a micro 
services architecture, it ensures scalability, real-time processing, and seamless integration with 
existing platforms. Key features include real-time monitoring, anomaly detection, alert 
management, and reporting. To address data imbalance, the Hybrid Cluster-Based Sampling 
Technique (HCBST) improves model sensitivity and reduces false positives. By leveraging 
deep learning, this research advances financial security in mobile money ecosystems, offering 
actionable insights for policymakers and service providers. The findings highlight neural 
networks’ potential to safeguard transactions, foster trust, and sustain financial inclusion in 
developing regions.  
