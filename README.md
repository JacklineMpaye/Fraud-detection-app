### FraudSense: Mobile Money Fraud Detection System
FraudSense is a real-time fraud detection system tailored to the mobile money ecosystem. By integrating advanced streaming, machine learning, and full-stack technologies, FraudSense enables proactive identification of suspicious transactions to enhance financial security in digital payments.

##📁 Project Structure
Backend/: Python-based backend services

kafka/: Kafka producer and consumer scripts

model_serving/: Model serialization and loading logic

venv/: Virtual environment for dependencies

requirements.txt: Python package dependencies

test.json: Sample transaction data for testing

lib/: Flutter frontend logic and UI components

assets/: Fonts, images, and design elements

android/, ios/, macos/, linux/, web/: Platform-specific build targets

test/: Unit and integration test scripts

pubspec.lock: Flutter dependency lockfile

##🔑 Key Features
Real-time fraud prediction using Kafka streams

Anomaly detection powered by XGBoost

RESTful API with FastAPI

Secure PostgreSQL database integration

Flutter web dashboard with live alert updates

Deployment-ready on DigitalOcean

💻 Technology Stack
Backend: Python, FastAPI, Kafka, XGBoost

Frontend: Flutter Web

Database: PostgreSQL

DevOps: DigitalOcean, systemctl, SCP

##🚀 Getting Started
#1. Clone Repository
bash
Copy
Edit
git clone https://github.com/JacklineMpaye/Fraud-detection-app.git
cd Fraud-detection-app
#2. Backend Setup
bash
Copy
Edit
cd Backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn fastapi_app:app --reload
#3. PostgreSQL Setup
Create a new database:

bash
Copy
Edit
psql -U postgres
CREATE DATABASE fraudsense_db;
Then, restore schema:

bash
Copy
Edit
psql -U postgres -d fraudsense_db < fraudsense_backup.sql
#4. Kafka Setup
Start Zookeeper and Kafka:

bash
Copy
Edit
./bin/zookeeper-server-start.sh -daemon ./config/zookeeper.properties
./bin/kafka-server-start.sh -daemon ./config/server.properties


#5. Kafka Producer & Consumer
bash
Copy
Edit
cd Backend/kafka
python producer.py
python consumer.py
#6. Frontend (Flutter Web)
bash
Copy
Edit
cd Flutter-App
flutter pub get
flutter run -d chrome
Update .env with your API base URL (e.g., your DigitalOcean IP).

#7. Deployment (DigitalOcean)
Upload backend files to your droplet

Run FastAPI with pm2 or systemctl

Build and upload Flutter frontend:

bash
Copy
Edit
flutter build web
scp -r build/web/* user@your_ip:/var/www/html/
📊 Usage
Monitor real-time predictions through the web dashboard

Alerts are flagged when fraud probability > 0.7

Review historical trends and flagged transactions

##🤝 Contributing
To contribute:

Fork the repository

Create a new feature branch

Make your changes and commit

Open a pull request with detailed descriptions

##🌱 Future Recommendations
Integrate with Telecom APIs: Collaborate with mobile money providers to access real transaction data and improve model accuracy.

Deploy on Real-Time Pipelines: Move from testing environments to production by running the system on live transaction streams.

Add Adaptive Learning: Equip the model to learn from new fraud patterns over time without manual retraining.

Implement Risk Scoring: Rank fraud alerts by severity to help users prioritize the most critical threats.

Enable Feedback Loops: Let human reviewers validate alerts and feed corrections back into the system for continuous improvement.



##🙏 Acknowledgements
Special thanks to the Ashesi University Capstone Program and all technical mentors involved. This project was built with inspiration from real-world financial security needs and the desire to reduce digital payment fraud in Africa.
