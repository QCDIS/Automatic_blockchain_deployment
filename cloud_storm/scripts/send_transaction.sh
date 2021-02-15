#!/bin/bash

TRANSACTION_ID=$(jq ._id $1)
EXECUTION_TIME=$(jq .transaction.execution_time $1)
INPUT_RATE=$(jq .transaction.input_rate $1)
BLOCKCHAIN_ID=$2
DISPLAY=10

TRANSACTION_ID=`echo "$TRANSACTION_ID" | tr -d '"'`
EXECUTION_TIME=`echo "$EXECUTION_TIME" | tr -d '"'`
INPUT_RATE=`echo "$INPUT_RATE" | tr -d '"'`

INFRA="./cloud_storm/cloud/$BLOCKCHAIN_ID/architecture/App/infrasCode.yml"
sudo rm $INFRA
touch $INFRA


###Infrastructure code for exogeni
echo 'Mode: "CTRL" # or CTRL' >> $INFRA
echo 'InfrasCodes:' >> $INFRA
echo '- CodeType: "LOOP"' >> $INFRA
echo '  Duration: null' >> $INFRA
echo '  Count: 1' >> $INFRA
echo '  Deadline: null' >> $INFRA
echo '  OpCodes:' >> $INFRA
#####Execute command
echo '  - Operation: "execute"' >> $INFRA
node_name="\"timeout $EXECUTION_TIME intkey workload --rate $INPUT_RATE -d $DISPLAY ; exit 0\""
echo '    Command: '$node_name >> $INFRA
echo '    ObjectType: VM' >> $INFRA
obj_name="\"subtop0.sub0node0\""
echo '    Objects: '"$obj_name">> $INFRA
# obj_name="\"subtop0.sub0node0\""
# echo $obj_name >> $INFRA


sudo java -jar ./cloud_storm/CloudsStorm-b.1.2.jar run ./cloud_storm/cloud/$BLOCKCHAIN_ID/architecture
