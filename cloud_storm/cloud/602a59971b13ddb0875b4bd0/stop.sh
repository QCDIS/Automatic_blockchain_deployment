ssh root@sub0node0 "sudo systemctl stop sawtooth-rest-api.service"
ssh root@sub0node0 "sudo systemctl stop sawtooth-settings-tp.service"
ssh root@sub0node0 "sudo systemctl stop sawtooth-identity-tp.service"
ssh root@sub0node0 "sudo systemctl stop sawtooth-intkey-tp-python.service"
ssh root@sub0node0 "sudo systemctl stop sawtooth-validator.service"
ssh root@sub0node0 "sudo systemctl stop sawtooth-pbft-engine.service"
sleep 10
ssh root@sub1node0 "sudo systemctl stop sawtooth-rest-api.service"
ssh root@sub1node0 "sudo systemctl stop sawtooth-settings-tp.service"
ssh root@sub1node0 "sudo systemctl stop sawtooth-identity-tp.service"
ssh root@sub1node0 "sudo systemctl stop sawtooth-intkey-tp-python.service"
ssh root@sub1node0 "sudo systemctl stop sawtooth-validator.service"
ssh root@sub1node0 "sudo systemctl stop sawtooth-pbft-engine.service"
sleep 10
