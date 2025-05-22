# 📦 Apache Kafka, apache flink, bigquery (GCP) for bigdata project

This is project for bigdata project with kafka, flink simulation. This project stimulate process send data (producer) to kafka and store in bigquery.

![Status](https://img.shields.io/badge/status-active-success)

---

## 📚 Table of Contents

- [🛠️ Installation](#️-installation)
- [🧪 Testing](#-testing)


---

## 🛠️ Installation

### Prerequisites

- Google cloud platfrom account
- 6 virtual machine running
- OS: Ubuntu or Debian
- Bigquery admin json file: If haven't, go to `IAM & Admin` and go to `service account` in GCP and create grant acess with role `BigQuery Data Editor, BigQuery Data Owner, BigQuery Job User` and install file json with name: `bq-key.json` and upload to the folder `secrets` in `/opt/kafka/secrets/` in broker1 machine and `/opt/flink/secrets/` in flink machine
- Set firewall rule for open TCP port `8081, 2181, 9092`
- `git` and `pip` in virtual machine if dont have can install: 
```bash
sudo apt update && sudo apt install git -y
sudo apt-get install python3-pip -y
```
### Setup

```bash
# 1. Clone the repository in each machine
cd ~ && git clone https://github.com/nvt18624/Bigdata.git
cd Bigdata
chmod +x install.sh env.sh requirement.sh connector.sh flink.sh
# 2. Create virtual environment in each machine and upload bq-key.json to broker1 and flink: In the env.sh, subtitute variables: ip public, project id, dataset ...
source env.sh
scp -i <path_to_private_key> <path_to_bq-key.json> <username>@<ip_broker1> 
scp -i <path_to_private_key> <path_to_bq-key.json> <username>@<ip_flink> 
# 3. In zookeeper machine 
./install.sh
# 4. In broker machine
./install.sh <broker_id = {1,2,3}>
# 5. In zookeeper machine 
sudo nohup /opt/confluent-7.9.0/bin/schema-registry-start /opt/confluent-7.9.0/etc/schema-registry/schema-registry.properties > /tmp/schema-registry.log 2>&1 &
# 6. In broker 1 machine: Move bq-key.json file to folder /opt/kafka/secrets
sudo nohup /opt/kafka/bin/connect-distributed.sh /opt/kafka/config/connect-distributed.properties > /tmp/connector.log 2>&1 &
curl -X POST -H "Content-Type: application/json" -d @/opt/kafka/connector-config/connect-config.json http://localhost:8083/connectors
# 7. In producer machine
./requirement.sh
python3 -m venv env && source env/bin/activate
pip install -r producer_requirement.txt
python producer.py
# 8. In flink machine: move bq-key.json file to folder /opt/flink/secrets
./requirement.txt && ./flink.sh 
cd /opt/flink && /bin/taskmanager.sh start
python3 -m venv env
source env/bin/active
python flink.py
```
## 🧪 Testing
### In each machine
``` bash
# Check port open with kafka: 9092, zookeeper: 2181, schema-registry: 8081, flink: 8081
sudo netstat -tulnp 
# Check connector in broker 1 
curl http://localhost:8083/connectors/bigquery-sink-connector-1/status
# Delete connector in broker 1
curl -X DELETE http://localhost:8083/connectors/bigquery-sink-connector-1
# Kafka server list topic
bin/kafka-topics.sh --list --bootstrap-server localhost:9092
# Schema registry in zookeeper
curl http://<zookeeper_ip>:8081/subjects

```

