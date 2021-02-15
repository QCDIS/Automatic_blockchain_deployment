#!/bin/bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
rm  /var/lib/dpkg/lock
apt-get install -y docker-ce

git clone https://github.com/hyperledger/sawtooth-core.git
docker pull influxdb
docker pull zh9314/sawtooth-stats-grafana

mkdir /var/lib/influx-data

docker run -d -p 8086:8086 -v /var/lib/influx-data:/var/lib/influxdb -e INFLUXDB_DB=metrics -e INFLUXDB_HTTP_AUTH_ENABLED=true -e INFLUXDB_ADMIN_USER=admin -e INFLUXDB_ADMIN_PASSWORD='test' -e INFLUXDB_USER=lrdata -e INFLUXDB_USER_PASSWORD='test' --name sawtooth-stats-influxdb influxdb

docker run -d -p 3000:3000 zh9314/sawtooth-stats-grafana

