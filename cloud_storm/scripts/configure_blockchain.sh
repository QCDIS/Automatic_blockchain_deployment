#!/bin/bash

############################################################
# File name: configure_blockchain.sh
# Create cloudsStorm architecture files based on user input
# Arguments:
#   input.json
############################################################


# Retrieve input from input.json file that is passed in the command line argument
ID=$(jq ._id $1)
BLOCKCHAIN_TYPE=$(jq .input.blockchain_type $1)
CONSENSUS_ALGORITHM=$(jq .input.consensus_algorithm $1)
HOSTS=$(jq .input.hosts $1)
HOSTS_NR=`echo $HOSTS | jq length`
CLOUD=`echo $HOSTS | jq '.[0].cloud'`
DOMAIN=`echo $HOSTS | jq '.[0].domain'`


TOTAL_VM=0
for i in `seq 0 "$(($HOSTS_NR-1))"`
do
    AMOUNT=`echo $HOSTS | jq ".[$i].number"`
    TOTAL_VM=$(($TOTAL_VM + $AMOUNT))
done

# Strip ID from quotes
ID=`echo $ID | tr -d '"'`

# Create folder to store blockchain code
ID=`echo "$ID" | tr -d '"'`
mkdir ./cloud_storm/cloud/$ID

# Create folder to store architecture
mkdir ./cloud_storm/cloud/$ID/architecture

# Copy template folder that contains credentials
cp -r ./cloud_storm/cloud/template_folder/. ./cloud_storm/cloud/$ID/architecture



##########################################
#######Create and define subtopology files
##########################################



for i in `seq 0 "$(($HOSTS_NR-1))"`
do
    # Create file define the subtopology in
    touch "./cloud_storm/cloud/$ID/architecture/Infs/Topology/subtop$i.yml"

    CLUSTER="./cloud_storm/cloud/$ID/architecture/Infs/Topology/subtop$i.yml"
    # Store user input in variables
    CLOUD=`echo $HOSTS | jq ".[$i].cloud"`
    INSTANCE_TYPE=`echo $HOSTS | jq ".[$i].instance_type"`
    OS_TYPE=`echo $HOSTS | jq ".[$i].os_type"`
    ZONE=`echo $HOSTS | jq ".[$i].zone"`
    AMOUNT=`echo $HOSTS | jq ".[$i].number"`

    echo 'extraInfo:' >> $CLUSTER
    echo 'VMs:' >> $CLUSTER
    
    for j in `seq 0 "$(($AMOUNT-1))"`
    do
        a="sub$i"
        b="node$j"
        NODE_NAME="${a}${b}"
        NODE_NAME2=\"$NODE_NAME\"
        echo '- name:' "$NODE_NAME2" >> $CLUSTER
        echo '  nodeType:' "$INSTANCE_TYPE" >> $CLUSTER
        echo '  OStype:' "$OS_TYPE" >> $CLUSTER
        if [ $CLOUD = '"ExoGENI"' ];
        then
            echo '  defaultSSHAccount: "root"' >> $CLUSTER

        else
            echo '  defaultSSHAccount: "ubuntu"' >> $CLUSTER
            SCRIPT_VAR="name@$NODE_NAME.sh"
            SCRIPT_VAR=\"$SCRIPT_VAR\"
            echo '  script:' $SCRIPT_VAR>> $CLUSTER
        fi        
    done
done


# Create extra virtual machine for the monitor node 
if [ $CLOUD = '"ExoGENI"' ];
        then
            echo '- name: "monitor"' >> $CLUSTER
            echo '  nodeType:' "$INSTANCE_TYPE" >> $CLUSTER
            echo '  OStype:' "$OS_TYPE" >> $CLUSTER
            echo '  defaultSSHAccount: "root"' >> $CLUSTER
        else
            echo '- name: "monitor"' >> $CLUSTER
            echo '  nodeType:' "$INSTANCE_TYPE" >> $CLUSTER
            echo '  OStype:' "$OS_TYPE" >> $CLUSTER
            echo '  defaultSSHAccount: "ubuntu"' >> $CLUSTER
            echo '  script: "name@influxdb.sh"' >> $CLUSTER
fi        


# Define private subnet
SUBNET=192.168.10.0
SUBNET_NUM=10
IP=10
NETMASK=24

net="http://192.168.$SUBNET_NUM.5:8086"
net2=\"$net\"


########Create JSON object that defines all subnets. 
########This JSON is created for for easy access to ip addresses from the peers.
SUBNETS_JSON=$(jo -p subnets=[]) 
j2=$(jo -p subnet_add=192.168.$SUBNET_NUM.0 netmask=$NETMASK members=[])

for i in `seq 0 "$(($HOSTS_NR-1))"`
do
    AMOUNT=`echo $HOSTS | jq ".[$i].number"`

    for j in `seq 0 "$(($AMOUNT-1))"`
    do
        a="sub$i"
        b="node$j"
        NODE_NAME="${a}${b}"

        NODE_JSON=$(jo -p $NODE_NAME=192.168.$SUBNET_NUM.$IP)
        j2=`echo $j2 | jq ".members += [$NODE_JSON]"`
        IP="$(($IP+1))"
    done

    SUBNETS_JSON=`echo $SUBNETS_JSON | jq ".subnets += [$j2]"`

done

###########################################
########Create and define top topology file
###########################################


touch "./cloud_storm/cloud/$ID/architecture/Infs/Topology/_top.yml"
TOPOLOGY="./cloud_storm/cloud/$ID/architecture/Infs/Topology/_top.yml"

SUBNET_NUM=10
SUBNET="192.168.$SUBNET_NUM.0"
IP=10
NETMASK='"24"'

cat >> $TOPOLOGY <<- "EOF"
---
userName: "jardenna"
publicKeyPath: "name@test.pub"
topologies:
EOF


#######Define subtopologies
for i in `seq 0 "$(($HOSTS_NR-1))"`
do
    CLOUD=`echo $HOSTS | jq ".[$i].cloud"`
    INSTANCE_TYPE=`echo $HOSTS | jq ".[$i].instance_type"`
    OS_TYPE=`echo $HOSTS | jq ".[$i].os_type"`
    ZONE=`echo $HOSTS | jq ".[$i].zone"`
    AMOUNT=`echo $HOSTS | jq ".[$i].number"`
    subtopo="\"subtop$i\""
    echo '- topology: '$subtopo >> $TOPOLOGY
    echo '  cloudProvider:' $CLOUD >> $TOPOLOGY
    echo '  domain:' $ZONE >> $TOPOLOGY
done

echo 'connections:' >> $TOPOLOGY
echo 'subnets:' >> $TOPOLOGY
subnet="\"s1\""
echo '- name:' $subnet >> $TOPOLOGY
l="192.168.$SUBNET_NUM.0"
l=\"$l\"
echo '  subnet:' $l>> $TOPOLOGY
echo '  netmask:' $NETMASK >> $TOPOLOGY
echo '  members:' >> $TOPOLOGY


########Define subnets
for i in `seq 0 "$(($HOSTS_NR-1))"`
do
    if [ $i -eq 0 ]
    then
        echo '  - vmName:' "\"subtop$i.monitor\"" >> $TOPOLOGY
        m="192.168.$SUBNET_NUM.5"
        m=\"$m\"
        echo '    address:' $m >> $TOPOLOGY
    fi

    for j in `seq 0 "$(($AMOUNT-1))"`
    do
        a="sub$i"
        b="node$j"
        NODE_NAME="${a}${b}"
        echo '  - vmName:' "\"subtop$i.$NODE_NAME\"" >> $TOPOLOGY
        n="192.168.$SUBNET_NUM.$IP"
        n=\"$n\"
        echo '    address:' $n >> $TOPOLOGY
        IP="$(($IP+1))"
    done

done





###########################################
########Create influxdb script for monitor
###########################################


CLOUD=`echo $HOSTS | jq '.[0].cloud'`
touch "./cloud_storm/cloud/$ID/architecture/Infs/Topology/influxdb.sh"
MONITOR_SCRIPT="./cloud_storm/cloud/$ID/architecture/Infs/Topology/influxdb.sh"

echo '#!/bin/bash' >> $MONITOR_SCRIPT


cat >> $MONITOR_SCRIPT <<- "EOF"
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

EOF





###########################################
########Create script for nodes
##########################################


for i in `seq 0 "$(($HOSTS_NR-1))"`
do
    CLOUD=`echo $HOSTS | jq ".[$i].cloud"`
    INSTANCE_TYPE=`echo $HOSTS | jq ".[$i].instance_type"`
    OS_TYPE=`echo $HOSTS | jq ".[$i].os_type"`
    ZONE=`echo $HOSTS | jq ".[$i].zone"`
    AMOUNT=`echo $HOSTS | jq ".[$i].number"`

    for j in `seq 0 "$(($AMOUNT-1))"`
    do
        a="sub$i"
        b="node$j"
        NODE_NAME="${a}${b}"
        touch "./cloud_storm/cloud/$ID/architecture/Infs/Topology/$NODE_NAME.sh"
        NODE_SCRIPT="./cloud_storm/cloud/$ID/architecture/Infs/Topology/$NODE_NAME.sh"
        echo '#!/bin/bash' >> $NODE_SCRIPT
        CURRENT_NODE=`echo $SUBNETS_JSON | jq ".subnets[0].members[$j].$NODE_NAME"`
        CURRENT_NODE=`echo "$CURRENT_NODE" | tr -d '"'`
        # Install sawtooth
        echo 'apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8AA7AF1F1091A5FD' >> $NODE_SCRIPT
        echo "add-apt-repository 'deb [arch=amd64] http://repo.sawtooth.me/ubuntu/bumper/stable xenial universe'" >> $NODE_SCRIPT
        echo 'curl -sL https://repos.influxdata.com/influxdb.key |  sudo apt-key add -' >> $NODE_SCRIPT
        echo 'apt-add-repository "deb https://repos.influxdata.com/ubuntu xenial stable"' >> $NODE_SCRIPT
        echo 'apt-get update' >> $NODE_SCRIPT
        echo 'rm  /var/lib/dpkg/lock' >> $NODE_SCRIPT
        echo 'apt-get install -y sawtooth python3-sawtooth-identity' >> $NODE_SCRIPT
        # Install consensus algorithm engines
        echo 'apt-get install -y sawtooth-raft-engine sawtooth-pbft-engine python3-sawtooth-poet-cli' >> $NODE_SCRIPT
        echo 'apt-get install -y python3-sawtooth-poet-engine python3-sawtooth-poet-families' >> $NODE_SCRIPT
        # Generate key
        echo 'sawtooth keygen' >> $NODE_SCRIPT
        echo 'sawadm keygen' >> $NODE_SCRIPT
        # Install telegraf
        echo 'apt-get install -y telegraf' >> $NODE_SCRIPT
        echo 'sudo chmod -R 777 /var/log/sawtooth/' >> $NODE_SCRIPT
        echo 'sudo chmod -R 777 /var/lib/sawtooth/' >> $NODE_SCRIPT
        # Condigure for validator
        echo '###########configure for validator' >> $NODE_SCRIPT
        echo 'cat > /etc/sawtooth/validator.toml << EOF' >> $NODE_SCRIPT
        echo 'bind = ["network:tcp://'$CURRENT_NODE':8800","component:tcp://127.0.0.1:4004","consensus:tcp://127.0.0.1:5050"]' >> $NODE_SCRIPT
        echo 'peering = "static"' >> $NODE_SCRIPT
        echo 'endpoint = "tcp://'$CURRENT_NODE':8800"'>> $NODE_SCRIPT


        # Define IP addresses of peerslist
        echo -e 'peers = [\c'>> $NODE_SCRIPT

        COUNT=0
        PEERS_ARR=()
        for l in `seq 0 "$(($HOSTS_NR-1))"`
        do
            AMOUNT2=`echo $HOSTS | jq ".[$l].number"`
            for k in `seq 0 "$(($AMOUNT2-1))"`
            do
                #Specify node name
                a="sub$l"
                b="node$k"
                NODE_NAME_2="${a}${b}"
                PEERS=`echo $SUBNETS_JSON | jq ".subnets[0].members[$k].$NODE_NAME_2"`
                PEERS=`echo $PEERS | tr -d '"'`
                
                if [ $PEERS != $CURRENT_NODE ];
                then
                    if [ $COUNT -eq "$(($TOTAL_VM-2))" ];
                    then
                        PEER='"tcp://'$PEERS':8800"'
                        echo "$PEER]" >> $NODE_SCRIPT
                    else
                        PEER='"tcp://'$PEERS':8800"'
                        echo -e "$PEER,\c" >> $NODE_SCRIPT
                        COUNT=$(($COUNT + 1))
                    fi
                fi
            done
        done

        echo "scheduler = 'parallel'" >> $NODE_SCRIPT
        echo "network_public_key = 'wFMwoOt>yFqI/ek.G[tfMMILHWw#vXB[Sv}>l>i)'" >> $NODE_SCRIPT
        echo "network_private_key = 'r&oJ5aQDj4+V]p2:Lz70Eu0x#m%IwzBdP(}&hWM*'" >> $NODE_SCRIPT
        echo "# The minimum number of peers required before stopping peer search." >> $NODE_SCRIPT
        echo "minimum_peer_connectivity = 1" >> $NODE_SCRIPT
        echo "# The maximum number of peers that will be accepted." >> $NODE_SCRIPT
        echo "maximum_peer_connectivity = 100" >> $NODE_SCRIPT
        echo 'opentsdb_url = '"$net2">> $NODE_SCRIPT
        echo 'opentsdb_db = "metrics"'>> $NODE_SCRIPT
        echo 'opentsdb_username  = "lrdata"'>> $NODE_SCRIPT
        echo 'opentsdb_password  = "test"'>> $NODE_SCRIPT
        echo 'EOF' >> $NODE_SCRIPT
        # Configure for rest api
        echo '############configure for rest_api' >> $NODE_SCRIPT 
        echo 'cat > /etc/sawtooth/rest_api.toml << EOF' >> $NODE_SCRIPT 
        echo 'opentsdb_url = '"$net2" >> $NODE_SCRIPT 
        echo 'opentsdb_db = "metrics"' >> $NODE_SCRIPT 
        echo 'opentsdb_username  = "lrdata"' >> $NODE_SCRIPT 
        echo 'opentsdb_password  = "test"' >> $NODE_SCRIPT 
        echo 'EOF' >> $NODE_SCRIPT 
        backslash='\'
        # Configure for telegraf
        echo '############configure for telegraf' >> $NODE_SCRIPT 
        echo "sed -i '/\[outputs.influxdb\]/a \ \ urls = \["$backslash"\"$net"$backslash"\"\]\n  database = "$backslash"\"metrics"$backslash"\"\n  username = "$backslash"\"lrdata"$backslash"\"\n  password = "$backslash"\"test"$backslash"\"' /etc/telegraf/telegraf.conf" >> $NODE_SCRIPT 
        echo "sed -i '/\[inputs.system\]/a [[inputs.net]]\n[[inputs.procstat]]\n  exe = "$backslash"\"sawtooth"$backslash"\"\n  prefix = "$backslash"\"sawtooth"$backslash"\"' /etc/telegraf/telegraf.conf" >> $NODE_SCRIPT 

    done
done





#######################################################################
########Create file to generate genesis block - consensus algorithm
#######################################################################


touch "./cloud_storm/cloud/$ID/genesis.sh"
GENESIS_SCRIPT="./cloud_storm/cloud/$ID/genesis.sh"

touch "./cloud_storm/cloud/$ID/stop.sh"
STOP_SCRIPT="./cloud_storm/cloud/$ID/stop.sh"

echo 'sudo sawset genesis --key /etc/sawtooth/keys/validator.priv -o config-genesis.batch' >> $GENESIS_SCRIPT

# If user input specifies Raft
if [ $CONSENSUS_ALGORITHM = '"raft"' ];
then
    # Get IP addresses of peers
    echo -e 'sudo sawset proposal create --key /etc/sawtooth/keys/validator.priv -o config-consensus.batch sawtooth.consensus.algorithm.name=raft sawtooth.consensus.algorithm.version=0.1.1 sawtooth.consensus.raft.peers=[\c'>> $GENESIS_SCRIPT
    COUNT=0
    for i in `seq 0 "$(($HOSTS_NR-1))"`
    do
        AMOUNT=`echo $HOSTS | jq ".[$p].number"`
        for j in `seq 0 "$(($AMOUNT-1))"`
        do
            # Specify node name
            a="sub$i"
            b="node$j"
            NODE_NAME_2="${a}${b}"
            PEERS=`echo $SUBNETS_JSON | jq ".subnets[0].members[$j].$NODE_NAME_2"`
            PEERS=`echo $PEERS | tr -d '"'`
            if [ $COUNT -eq "$(($TOTAL_VM-1))" ];
            then
                echo '\"$(ssh root@'$PEERS' "cat /etc/sawtooth/keys/validator.pub")\"]' >> $GENESIS_SCRIPT
            else
                echo -e '\"$(ssh root@'$PEERS' "cat /etc/sawtooth/keys/validator.pub")\",\c' >> $GENESIS_SCRIPT
                COUNT=$(($COUNT + 1))
            fi
        done
    done


    echo "sudo sawset proposal create --key /etc/sawtooth/keys/validator.priv -o raft-settings.batch sawtooth.consensus.raft.heartbeat_tick=2 sawtooth.consensus.raft.election_tick=20 sawtooth.consensus.raft.period=3500" >> $GENESIS_SCRIPT
    echo "sudo sawadm genesis config-genesis.batch config-consensus.batch raft-settings.batch" >> $GENESIS_SCRIPT

    # Start all the service (Raft 3 nodes)
    echo '####### start all the service' >> $GENESIS_SCRIPT
    for i in `seq 0 "$(($HOSTS_NR-1))"`
    do
        AMOUNT=`echo $HOSTS | jq ".[$i].number"`
        for j in `seq 0 "$(($AMOUNT-1))"`
        do
            a="sub$i"
            b="node$j"
            NODE_NAME="${a}${b}"
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-rest-api.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-settings-tp.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-identity-tp.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-intkey-tp-python.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-validator.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-raft-engine.service"' >> $GENESIS_SCRIPT
            echo 'sleep 10' >> $GENESIS_SCRIPT

            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-rest-api.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-settings-tp.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-identity-tp.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-intkey-tp-python.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-validator.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-raft-engine.service"' >> $STOP_SCRIPT
            echo 'sleep 10' >> $STOP_SCRIPT
        done    
    done


# If user input specifies pBFT
elif [ $CONSENSUS_ALGORITHM = '"pBFT"' ];
then

    # Get IP addresses of peers
    echo -e 'sudo sawset proposal create --key /etc/sawtooth/keys/validator.priv -o config-consensus.batch sawtooth.consensus.algorithm.name=pbft sawtooth.consensus.algorithm.version=1.0 sawtooth.consensus.pbft.members=[\c' >> $GENESIS_SCRIPT
    COUNT=0
    for i in `seq 0 "$(($HOSTS_NR-1))"`
    do
        AMOUNT=`echo $HOSTS | jq ".[$p].number"`
        for j in `seq 0 "$(($AMOUNT-1))"`
        do
            # Specify node name
            a="sub$i"
            b="node$j"
            NODE_NAME_2="${a}${b}"
            PEERS=`echo $SUBNETS_JSON | jq ".subnets[0].members[$j].$NODE_NAME_2"`
            PEERS=`echo $PEERS | tr -d '"'`

            if [ $COUNT -eq "$(($TOTAL_VM-1))" ];
            then
                echo '\"$(ssh root@'$PEERS' "cat /etc/sawtooth/keys/validator.pub")\"]' >> $GENESIS_SCRIPT
            else
                echo -e '\"$(ssh root@'$PEERS' "cat /etc/sawtooth/keys/validator.pub")\",\c' >> $GENESIS_SCRIPT
                COUNT=$(($COUNT + 1))
            fi
        done
    done


    echo "sudo sawset proposal create --key /etc/sawtooth/keys/validator.priv -o pbft-settings.batch sawtooth.consensus.pbft.block_publishing_delay=1000 sawtooth.consensus.pbft.commit_timeout=10000 sawtooth.consensus.pbft.forced_view_change_interval=100 sawtooth.consensus.pbft.idle_timeout=30000 sawtooth.consensus.pbft.view_change_duration=5000" >> $GENESIS_SCRIPT
    echo "sudo sawadm genesis config-genesis.batch config-consensus.batch pbft-settings.batch" >> $GENESIS_SCRIPT


    # Start all the service
    echo '####### start all the service' >> $GENESIS_SCRIPT
    for i in `seq 0 "$(($HOSTS_NR-1))"`
    do
        AMOUNT=`echo $HOSTS | jq ".[$i].number"`
        for j in `seq 0 "$(($AMOUNT-1))"`
        do
            a="sub$i"
            b="node$j"
            NODE_NAME="${a}${b}"
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-rest-api.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-settings-tp.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-identity-tp.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-intkey-tp-python.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-validator.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-pbft-engine.service"' >> $GENESIS_SCRIPT
            echo 'sleep 10' >> $GENESIS_SCRIPT

            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-rest-api.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-settings-tp.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-identity-tp.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-intkey-tp-python.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-validator.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-pbft-engine.service"' >> $STOP_SCRIPT
            echo 'sleep 10' >> $STOP_SCRIPT
        done    
    done


# If user input specifies PoET
elif [ $CONSENSUS_ALGORITHM = '"PoET"' ];
then

    # Get IP addresses of peers
    echo 'sudo sawset proposal create --key /etc/sawtooth/keys/validator.priv -o config-consensus.batch sawtooth.consensus.algorithm.name=PoET sawtooth.consensus.algorithm.version=0.1 sawtooth.poet.report_public_key_pem="$(cat /etc/sawtooth/simulator_rk_pub.pem)" sawtooth.poet.valid_enclave_measurements=$(poet enclave measurement) sawtooth.poet.valid_enclave_basenames=$(poet enclave basename)'>> $GENESIS_SCRIPT
    echo "sudo poet registration create --key /etc/sawtooth/keys/validator.priv -o poet.batch" >> $GENESIS_SCRIPT
    echo "sudo sawset proposal create --key /etc/sawtooth/keys/validator.priv -o poet-settings.batch sawtooth.poet.target_wait_time=5 sawtooth.poet.initial_wait_time=25 sawtooth.publisher.max_batches_per_block=100" >> $GENESIS_SCRIPT
    echo "sudo sawadm genesis config-genesis.batch config-consensus.batch poet.batch poet-settings.batch">> $GENESIS_SCRIPT
    echo "sudo chmod -R 777 /var/log/sawtooth/" >> $GENESIS_SCRIPT
    echo "sudo chmod -R 777 /var/lib/sawtooth/" >> $GENESIS_SCRIPT

    # start all the service (PoET nodes)
    echo '####### start all the service' >> $GENESIS_SCRIPT
    for i in `seq 0 "$(($HOSTS_NR-1))"`
    do
        AMOUNT=`echo $HOSTS | jq ".[$i].number"`
        for j in `seq 0 "$(($AMOUNT-1))"`
        do
            a="sub$i"
            b="node$j"
            NODE_NAME="${a}${b}"
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-rest-api.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-settings-tp.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-identity-tp.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-intkey-tp-python.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-validator.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-poet-validator-registry-tp.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl start sawtooth-poet-engine.service"' >> $GENESIS_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl restart telegraf"' >> $GENESIS_SCRIPT
            echo 'sleep 10' >> $GENESIS_SCRIPT

            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-rest-api.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-settings-tp.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-identity-tp.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-intkey-tp-python.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-validator.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-poet-validator-registry-tp.service"' >> $STOP_SCRIPT
            echo 'ssh root@'$NODE_NAME' "sudo systemctl stop sawtooth-poet-engine.service"' >> $STOP_SCRIPT
            echo 'sleep 10' >> $STOP_SCRIPT
        done    
    done
fi





#####################################
######Create infrastrucutre code
#####################################

touch "./cloud_storm/cloud/$ID/architecture/App/infrasCode.yml"
INFRA="./cloud_storm/cloud/$ID/architecture/App/infrasCode.yml"

GENESIS_SCRIPT3="./cloud_storm/cloud/$ID/genesis.sh"
STOP_SCRIPT3="./cloud_storm/cloud/$ID/stop.sh"

# Infrastructure code for exogeni (to get around dpkg error)
if [ $CLOUD = '"ExoGENI"' ];
then
    echo 'Mode: "CTRL" # or CTRL' >> $INFRA
    echo 'InfrasCodes:' >> $INFRA
    echo '- CodeType: "LOOP"' >> $INFRA
    echo '  Duration: null' >> $INFRA
    echo '  Count: 1' >> $INFRA
    echo '  Deadline: null' >> $INFRA
    echo '  OpCodes:' >> $INFRA

    #For each zone
    for i in `seq 0 "$(($HOSTS_NR-1))"`
    do    
        echo '    - Operation: "provision"' >> $INFRA
        echo '      ObjectType: SubTopology' >> $INFRA
        echo -n '      Objects: ' >> $INFRA
        subtopo="\"subtop$i\""
        echo $subtopo >> $INFRA

        if [[ "$i" -eq 0 ]];
        then 
            echo '    - Operation: "sleep"' >> $INFRA
            echo '      Command: "10m"' >> $INFRA
        fi
        
        AMOUNT=`echo $HOSTS | jq ".[$i].number"`
        # For each number of virtual machines in that zone
        for j in `seq 0 "$(($AMOUNT-1))"`
        do
            a="sub$i"
            b="node$j"
            NODE_NAME="${a}${b}"
            NODE_SCRIPT="./cloud_storm/cloud/$ID/architecture/Infs/Topology/$NODE_NAME.sh"
            NODE_SCRIPT3="./cloud_storm/cloud/$ID/architecture/Infs/Topology/$NODE_NAME.sh"
            
            # Put command
            echo '    - Operation: "put"' >> $INFRA
            echo '      Options:' >> $INFRA
            echo '        Src: file@'$NODE_SCRIPT3 >> $INFRA
            echo '        Dst: file@/root' >> $INFRA
            echo '      ObjectType: VM' >> $INFRA
            echo -n '      Objects: ' >> $INFRA
            subtopo2="subtop$i"
            gen_obj_name="\"$subtopo2.$NODE_NAME\""
            echo $gen_obj_name >> $INFRA


            # Execute command
            echo '    - Operation: "execute"' >> $INFRA
            node_name="\"bash /root/$NODE_NAME.sh &\""
            echo '      Command: '$node_name >> $INFRA
            echo '      ObjectType: VM' >> $INFRA
            echo -n '      Objects: ' >> $INFRA
            subtopo="subtop$i"
            obj_name="\"$subtopo.$NODE_NAME\""
            echo $obj_name >> $INFRA
        done

        echo '    - Operation: "put"' >> $INFRA
        echo '      Options:' >> $INFRA
        echo '        Src: file@'$MONITOR_SCRIPT >> $INFRA
        echo '        Dst: file@/root' >> $INFRA
        echo '      ObjectType: VM' >> $INFRA
        echo -n '      Objects: ' >> $INFRA
        subtopo2="subtop$i"
        gen_obj_name="\"$subtopo2.monitor\""
        echo $gen_obj_name >> $INFRA

        echo '    - Operation: "execute"' >> $INFRA
        monitor_name="\"bash /root/influxdb.sh\""
        echo '      Command: '$monitor_name >> $INFRA
        echo '      ObjectType: VM' >> $INFRA
        echo -n '      Objects: ' >> $INFRA
        subtopo2="subtop$i"

        gen_obj_name="\"$subtopo2.monitor\""
        echo $gen_obj_name >> $INFRA

        echo '    - Operation: "sleep"' >> $INFRA
        echo '      Command: "2m"' >> $INFRA
    

        GENESIS_SCRIPT3="./cloud_storm/cloud/$ID/genesis.sh"
        STOP_SCRIPT3="./cloud_storm/cloud/$ID/stop.sh"

        # Stop script
        echo '    - Operation: "put"' >> $INFRA
        echo '      Options:' >> $INFRA
        echo '        Src: file@'$STOP_SCRIPT3 >> $INFRA
        echo '        Dst: file@/root' >> $INFRA
        echo '      ObjectType: VM' >> $INFRA
        echo -n '      Objects: ' >> $INFRA
        gen_obj_name="\"subtop0.sub0node0\""
        echo $gen_obj_name >> $INFRA

        # Genesis code
        echo '    - Operation: "put"' >> $INFRA
        echo '      Options:' >> $INFRA
        echo '        Src: file@'$GENESIS_SCRIPT3 >> $INFRA
        echo '        Dst: file@/root' >> $INFRA
        echo '      ObjectType: VM' >> $INFRA
        echo -n '      Objects: ' >> $INFRA
        echo $gen_obj_name >> $INFRA

        echo '    - Operation: "execute"' >> $INFRA
        gen_name="\"bash /root/genesis.sh\""
        echo '      Command: '$gen_name >> $INFRA
        echo '      ObjectType: VM' >> $INFRA
        echo -n '      Objects: ' >> $INFRA
        echo $gen_obj_name >> $INFRA
    done

# Infrastructure code for other clouds
else
    echo 'Mode: "CTRL" # or CTRL' >> $INFRA
    echo 'InfrasCodes:' >> $INFRA
    echo '- CodeType: "LOOP"' >> $INFRA
    echo '  Duration: null' >> $INFRA
    echo '  Count: 1' >> $INFRA
    echo '  Deadline: null' >> $INFRA
    echo '  OpCodes:' >> $INFRA


    for i in `seq 0 "$(($HOSTS_NR-1))"`
    do
        echo '  - Operation: "provision"' >> $INFRA
        echo '    ObjectType: SubTopology' >> $INFRA
        echo -n '    Objects: ' >> $INFRA
        subtopo="\"subtop$i\""
        echo $subtopo >> $INFRA
    done
    echo '  - Operation: "sleep"' >> $INFRA
    echo '    Command: "10m"' >> $INFRA

    gen_obj_name="\"subtop0.sub0node0\""
    # Stop script
    echo '  - Operation: "put"' >> $INFRA
    echo '    Options:' >> $INFRA
    echo '      Src: file@'$STOP_SCRIPT3 >> $INFRA
    echo '      Dst: file@/root' >> $INFRA
    echo '    ObjectType: VM' >> $INFRA
    echo -n '    Objects: ' >> $INFRA
    echo $gen_obj_name >> $INFRA

    # Genesis code
    echo '  - Operation: "put"' >> $INFRA
    echo '    Options:' >> $INFRA
    echo '      Src: file@'$GENESIS_SCRIPT3 >> $INFRA
    echo '      Dst: file@/root' >> $INFRA
    echo '    ObjectType: VM' >> $INFRA
    echo -n '    Objects: ' >> $INFRA
    echo $gen_obj_name >> $INFRA

    echo '  - Operation: "execute"' >> $INFRA
    script="\"bash /root/genesis.sh\""
    echo '    Command: '$script >> $INFRA
    echo '    ObjectType: VM' >> $INFRA
    echo -n '    Objects: ' >> $INFRA
    gen_obj_name="\"subtop0.sub0node0\""
    echo $gen_obj_name >> $INFRA
fi


# Run cloudsStorm to create virtual machines in the cloud 
sudo java -jar ./cloud_storm/CloudsStorm-b.1.2.jar run ./cloud_storm/cloud/$ID/architecture

