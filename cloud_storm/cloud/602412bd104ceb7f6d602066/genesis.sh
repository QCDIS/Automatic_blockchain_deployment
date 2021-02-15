sudo sawset genesis --key /etc/sawtooth/keys/validator.priv -o config-genesis.batch
sudo sawset proposal create --key /etc/sawtooth/keys/validator.priv -o config-consensus.batch sawtooth.consensus.algorithm.name=PoET sawtooth.consensus.algorithm.version=0.1 sawtooth.poet.report_public_key_pem="$(cat /etc/sawtooth/simulator_rk_pub.pem)" sawtooth.poet.valid_enclave_measurements=$(poet enclave measurement) sawtooth.poet.valid_enclave_basenames=$(poet enclave basename)
sudo poet registration create --key /etc/sawtooth/keys/validator.priv -o poet.batch
sudo sawset proposal create --key /etc/sawtooth/keys/validator.priv -o poet-settings.batch sawtooth.poet.target_wait_time=5 sawtooth.poet.initial_wait_time=25 sawtooth.publisher.max_batches_per_block=100
sudo sawadm genesis config-genesis.batch config-consensus.batch poet.batch poet-settings.batch
sudo chmod -R 777 /var/log/sawtooth/
sudo chmod -R 777 /var/lib/sawtooth/
####### start all the service
ssh root@sub0node0 "sudo systemctl start sawtooth-rest-api.service"
ssh root@sub0node0 "sudo systemctl start sawtooth-settings-tp.service"
ssh root@sub0node0 "sudo systemctl start sawtooth-identity-tp.service"
ssh root@sub0node0 "sudo systemctl start sawtooth-intkey-tp-python.service"
ssh root@sub0node0 "sudo systemctl start sawtooth-validator.service"
ssh root@sub0node0 "sudo systemctl start sawtooth-poet-validator-registry-tp.service"
ssh root@sub0node0 "sudo systemctl start sawtooth-poet-engine.service"
ssh root@sub0node0 "sudo systemctl restart telegraf"
sleep 10
ssh root@sub1node0 "sudo systemctl start sawtooth-rest-api.service"
ssh root@sub1node0 "sudo systemctl start sawtooth-settings-tp.service"
ssh root@sub1node0 "sudo systemctl start sawtooth-identity-tp.service"
ssh root@sub1node0 "sudo systemctl start sawtooth-intkey-tp-python.service"
ssh root@sub1node0 "sudo systemctl start sawtooth-validator.service"
ssh root@sub1node0 "sudo systemctl start sawtooth-poet-validator-registry-tp.service"
ssh root@sub1node0 "sudo systemctl start sawtooth-poet-engine.service"
ssh root@sub1node0 "sudo systemctl restart telegraf"
sleep 10
