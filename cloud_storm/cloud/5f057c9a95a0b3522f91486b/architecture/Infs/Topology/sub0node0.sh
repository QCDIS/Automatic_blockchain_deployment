#!/bin/bash
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8AA7AF1F1091A5FD
add-apt-repository 'deb [arch=amd64] http://repo.sawtooth.me/ubuntu/bumper/stable xenial universe'
curl -sL https://repos.influxdata.com/influxdb.key |  sudo apt-key add -
apt-add-repository "deb https://repos.influxdata.com/ubuntu xenial stable"
apt-get update
rm  /var/lib/dpkg/lock
apt-get install -y sawtooth python3-sawtooth-identity
apt-get install -y sawtooth-raft-engine sawtooth-pbft-engine python3-sawtooth-poet-cli
apt-get install -y python3-sawtooth-poet-engine python3-sawtooth-poet-families
sawtooth keygen
sawadm keygen
apt-get install -y telegraf
sudo chmod -R 777 /var/log/sawtooth/
sudo chmod -R 777 /var/lib/sawtooth/
###########configure for validator
cat > /etc/sawtooth/validator.toml << EOF
bind = ["network:tcp://192.168.10.10:8800","component:tcp://127.0.0.1:4004","consensus:tcp://127.0.0.1:5050"]
peering = "static"
endpoint = "tcp://192.168.10.10:8800"
peers = ["tcp://192.168.10.11:8800","tcp://192.168.10.12:8800"]
scheduler = 'parallel'
network_public_key = 'wFMwoOt>yFqI/ek.G[tfMMILHWw#vXB[Sv}>l>i)'
network_private_key = 'r&oJ5aQDj4+V]p2:Lz70Eu0x#m%IwzBdP(}&hWM*'
# The minimum number of peers required before stopping peer search.
minimum_peer_connectivity = 1
# The maximum number of peers that will be accepted.
maximum_peer_connectivity = 100
opentsdb_url = "http://192.168.10.5:8086"
opentsdb_db = "metrics"
opentsdb_username  = "lrdata"
opentsdb_password  = "test"
EOF
############configure for rest_api
cat > /etc/sawtooth/rest_api.toml << EOF
opentsdb_url = "http://192.168.10.5:8086"
opentsdb_db = "metrics"
opentsdb_username  = "lrdata"
opentsdb_password  = "test"
EOF
############configure for telegraf
sed -i '/\[outputs.influxdb\]/a \ \ urls = \[\"http://192.168.10.5:8086\"\]\n  database = \"metrics\"\n  username = \"lrdata\"\n  password = \"test\"' /etc/telegraf/telegraf.conf
sed -i '/\[inputs.system\]/a [[inputs.net]]\n[[inputs.procstat]]\n  exe = \"sawtooth\"\n  prefix = \"sawtooth\"' /etc/telegraf/telegraf.conf
