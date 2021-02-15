sudo sawset genesis --key /etc/sawtooth/keys/validator.priv -o config-genesis.batch
sudo sawset proposal create --key /etc/sawtooth/keys/validator.priv -o config-consensus.batch sawtooth.consensus.algorithm.name=pbft sawtooth.consensus.algorithm.version=1.0 sawtooth.consensus.pbft.members=[sudo sawset proposal create --key /etc/sawtooth/keys/validator.priv -o pbft-settings.batch sawtooth.consensus.pbft.block_publishing_delay=1000 sawtooth.consensus.pbft.commit_timeout=10000 sawtooth.consensus.pbft.forced_view_change_interval=100 sawtooth.consensus.pbft.idle_timeout=30000 sawtooth.consensus.pbft.view_change_duration=5000
sudo sawadm genesis config-genesis.batch config-consensus.batch pbft-settings.batch
####### start all the service
ssh root@sub0node0 "sudo systemctl start sawtooth-rest-api.service"
ssh root@sub0node0 "sudo systemctl start sawtooth-settings-tp.service"
ssh root@sub0node0 "sudo systemctl start sawtooth-identity-tp.service"
ssh root@sub0node0 "sudo systemctl start sawtooth-intkey-tp-python.service"
ssh root@sub0node0 "sudo systemctl start sawtooth-validator.service"
ssh root@sub0node0 "sudo systemctl start sawtooth-pbft-engine.service"
sleep 10
ssh root@sub1node0 "sudo systemctl start sawtooth-rest-api.service"
ssh root@sub1node0 "sudo systemctl start sawtooth-settings-tp.service"
ssh root@sub1node0 "sudo systemctl start sawtooth-identity-tp.service"
ssh root@sub1node0 "sudo systemctl start sawtooth-intkey-tp-python.service"
ssh root@sub1node0 "sudo systemctl start sawtooth-validator.service"
ssh root@sub1node0 "sudo systemctl start sawtooth-pbft-engine.service"
sleep 10
