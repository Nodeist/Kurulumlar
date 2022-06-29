#!/bin/bash
echo "=================================================="
echo -e "\033[0;35m"
echo " | \ | |         | |    (_)   | |  ";
echo " |  \| | ___   __| | ___ _ ___| |_ ";
echo " |     |/ _ \ / _  |/ _ \ / __| __| ";
echo " | |\  | (_) | (_| |  __/ \__ \ |_ ";
echo " |_| \_|\___/ \__,_|\___|_|___/\__| ";
echo -e "\e[0m"
echo "=================================================="                                                            
sleep 2
GREEN="\e[32m"
NC="\e[0m"
dependiences () {
    echo -e '\e[0;33mGereklilikler yukleniyors\e[0m'
    echo -e ''
    sudo apt update
    sudo apt install make clang pkg-config libssl-dev build-essential git jq zip screen ncdu nload -y < "/dev/null"
}

variables (){
    echo export CHAIN_ID=korellia >> $HOME/.profile
    echo export denom=tkyve >> $HOME/.profile
    source $HOME/.profile
}

binaries () {
    echo -e ''
    echo -e '\e[0;33mDownload Binaries\e[0m' && sleep 1
    echo -e ''
    echo -e "\033[1;34m"
    if [ ! $node_name ]; then
        read -p ' Node ismi yazin: ' node_name
        echo 'export node_name='$node_name >> $HOME/.bash_profile
    fi
    . $HOME/.bash_profile
    echo -e "\033[0m"
    mkdir kyvebinary && cd kyvebinary
    wget -q https://github.com/KYVENetwork/chain/releases/download/v0.5.0/chain_linux_amd64.tar.gz
    sleep 2
    tar -xzf chain_linux_amd64.tar.gz
    sleep 1
    sudo mv chaind kyved
    sudo chmod +x kyved
    sudo mv $HOME/kyvebinary/kyved /usr/bin/
    sleep 1
    kyved config chain-id korellia
    cd $HOME && rm -rf kyvebinary
    wget -q -O ~/.kyve/config/genesis.json https://github.com/KYVENetwork/chain/releases/download/v0.0.1/genesis.json
    echo -e "\033[1;34m"
}

golang () {
if ! command -v go version &> /dev/null
then
    echo "İnstalling Go.."
    echo -e ""
    echo -e "\e[0;33m...\e[0m" && sleep 2
    echo -e ""
	wget -q -O go1.17.1.linux-amd64.tar.gz https://golang.org/dl/go1.17.linux-amd64.tar.gz
	rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.1.linux-amd64.tar.gz && rm go1.17.1.linux-amd64.tar.gz
	echo 'export GOROOT=/usr/local/go' >> $HOME/.bash_profile
	echo 'export GOPATH=$HOME/go' >> $HOME/.bash_profile
	echo 'export GO111MODULE=on' >> $HOME/.bash_profile
	echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile
    . $HOME/.bash_profile
	go version
else
 	echo -e "\e[0;31mGo is already installed.\e[0m" && sleep 2
fi
}

cosmovisor () {
    wget https://github.com/KYVENetwork/chain/releases/download/v0.0.1/cosmovisor_linux_amd64
    mv cosmovisor_linux_amd64 cosmovisor
    chmod +x cosmovisor
if [ -d "$HOME/go/bin" ] 
then
    echo "Ok..." 
else
    mkdir $HOME/go && mkdir $HOME/go/bin
fi
    cp cosmovisor $GOPATH/bin/cosmovisor
    cd $HOME
}

key_gen () {
    echo -e "\033[1;34m"
    echo -e ''
    echo -e '#######################################################################'
if [ ! $NODE_PASS ]; then
	read -p ' Enter your node password !!password must be at least 8 characters!!: ' NODE_PASS
    echo 'export node_pass='$NODE_PASS >> $HOME/.bash_profile
    source $HOME/.bash_profile
    source $HOME/.profile
fi
    echo -e ""
    echo -e '\033[0mKey uretiliyor\e[0m'
    sleep 2
    echo -e ''
    echo -e "\e[33mWait...\e[0m" && sleep 4
    (echo $NODE_PASS; echo $NODE_PASS) | kyved keys add validator --output json &>> $HOME/"$CHAIN_ID"_validator_info.json
    echo -e "Bu kodu yazarak mnemoniclerine ulasabilirsin;"
    echo -e "\e[32mcat $HOME/kyve-beta_validator_info.json\e[39m"
    export KYVE_WALLET=`echo $NODE_PASS | kyved keys show validator -a`
    echo 'export KYVE_WALLET='${KYVE_WALLET} >> $HOME/.bash_profile
    . $HOME/.bash_profile
    echo -e '\n\e[44mCuzdan adresiniz::' $KYVE_WALLET '\e[0m\n'
}


visor_bin () {
    mkdir -p ~/.kyve/cosmovisor/genesis/bin/
    mkdir -p ~/.kyve/cosmovisor/upgrades
    echo "{}" > ~/.kyve/cosmovisor/genesis/upgrade-info.json
    cp /usr/bin/kyved ~/.kyve/cosmovisor/genesis/bin/
    echo 'export DAEMON_HOME="$HOME/.kyve"' >> $HOME/.profile
    echo 'export DAEMON_NAME="kyved"' >> $HOME/.profile
    echo 'export DAEMON_ALLOW_DOWNLOAD_BINARIES="true"' >> $HOME/.profile
    echo 'export DAEMON_RESTART_AFTER_UPGRADE="true"' >> $HOME/.profile
    echo 'export PATH="$DAEMON_HOME/cosmovisor/current/bin:$PATH"' >> ~/.profile
    source ~/.profile
    sleep 2
}

config_service () {
SEEDS=""
    PEERS="04265862b2ed899def419e4a82f213c1a553e363@195.201.41.190:26656,7b6d8e28571257b9687060a9b66c4adbfd4bb490@195.201.237.198:26656,a24fc4dfdf780931a9d3c1f5082431fea7a33dca@65.108.225.158:10656,051d5068b0408069722aadae95e5d2bb2a470191@154.12.235.154:36656,12dc5f2d720216eb0802491f055e06f672efb212@172.93.101.94:26656,3b7eb1230e760792e03a2f2c6b0a3794630a6fe5@135.181.248.87:26656,500488ed06fff03a3850356f3a394a4679c4c1db@144.91.110.21:26656,ff5ad6b9a696951448c2eeba01594dc9d4ba3c66@173.212.201.4:26656,e858def3c74254508c9b005b2339f1eabefa5ab6@149.102.156.196:26656,cfd5095f2edc895185d494ecc5ba61aa1f8167d8@146.190.22.244:26656,144ae1ed0cb47c66eda82cf5e4a77218e36195fb@185.194.219.171:26656,573e1b9b1235806aa79c8b2ec9f9398561d6b4ba@3.72.38.121:26656,18c2e70da1c977b58baa6971757ffe3e8d92d05b@178.205.143.239:16656,d57eed80e3f0ae8d27d0df5737816acd62001c97@75.119.130.253:26656,1290027cd215444ba03f404aac48d2cba2a98b3b@193.188.20.179:11274,0c03ccd5d11e6dba4c40270467603326a89531aa@212.42.113.199:26656,4e3da7567b4696b5a9d5163932f9999136ee916d@185.43.4.187:26656,754085d4a59260ded05f4aa7eff7a56d825636ff@168.119.67.71:62096,01a85f6689021f55a9cb58ed413c3f5832d6b90c@65.108.43.116:56114,d624fc9eb6c6e64eb62dadefbf793c778871cb81@109.234.36.133:26656,c1dd05a984935f7e8f1b56d243e3da7cad7bc630@149.102.144.163:26656,d60d0546032db07e6d9b2c6d8dfd6edd8dbcf033@65.108.45.200:26623,99db1830d0e1d7ad86aca0acebb2e50a58736d61@65.108.136.196:28656,e2134959a6975163817656f676328b55222111de@164.92.212.246:36356,aff0bf8330ecb7d1465b7c66799f3b6c0db60aae@154.12.235.155:36656,776ef51078f573a44327b358d760f0423e57e158@135.181.38.11:26656,b9ce058836c202bce1b01c12e333f32782b80506@65.108.214.245:26656,20657d20756560c79490c09a7089bc9ff372bd09@62.171.185.38:26656,f5876a16367649e7e5bc449677d39e91f5bed495@143.198.74.26:26656,7c0d250b58e033b20e1244f0203d88cf9d336771@37.212.13.117:26656,cf18b627d5ecc823191cc1a1027e290a62ca1b68@207.244.255.154:26656,70556c82352b9919fb6f339b9da0ebc587e9148c@3.68.232.117:26656,ab170b2a811b93d47f491ad2c1adc0d3d6705d5a@142.132.236.231:26656,44185d392e2c7097dd90671bf9570ff2499581be@3.124.184.22:26656"
    sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.kyve/config/config.toml
 rm $HOME/.kyve/config/addrbook.json && wget -P $HOME/.kyve/config https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Kyve/addrbook.json
        sleep 2

    pruning="custom"
    pruning_keep_recent="100"
    pruning_keep_every="0"
    pruning_interval="10"
    sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.kyve/config/app.toml
    sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.kyve/config/app.toml
    sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.kyve/config/app.toml
    sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.kyve/config/app.toml

sleep 2

#Change port 35
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:36358\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:36357\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6351\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:36356\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":36350\"%" $HOME/.kyve/config/config.toml
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9350\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9351\"%" $HOME/.kyve/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:36357\"%" $HOME/.kyve/config/client.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:36356\"/" $HOME/.kyve/config/config.toml

sleep 1 


SNAP_RPC="https://kyve-testnet-rpc.polkachu.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.kyve/config/config.toml

    kyved tendermint unsafe-reset-all

    
    
    echo -e 'Servisler olusturuluyor..'
    sleep 2
sudo tee /etc/systemd/system/kyved.service > /dev/null <<EOF  
[Unit]
Description=Kyve Daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) start
Restart=always
RestartSec=3
LimitNOFILE=infinity

Environment="DAEMON_HOME=$HOME/.kyve"
Environment="DAEMON_NAME=kyved"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=true"

[Install]
WantedBy=multi-user.target
EOF
sudo -S systemctl daemon-reload
sudo -S systemctl enable kyved
sudo -S systemctl start kyved
sleep 2
sed -i 's/#Storage=auto/Storage=persistent/g' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald
}


info () {
    echo -e ${GREEN}"======================================================"${NC}
    echo -e "Cüzdan adresi: ${GREEN}$KYVE_WALLET${NC}"
    echo -e "mnemonicleri bul ve yedekle: ${GREEN}cat $HOME/kyve_korellia_validator_info.json${NC}"
    echo -e ${GREEN}"======================================================"${NC}
}

done_process () {
    LOG_SEE="journalctl -u kyved.service -f -n 100"
    source $HOME/.profile
    echo -e '\n\e[41mIslem tamam! Senkronizasyonu bekle! 10 dakika kadar surebilir.' $LOG_SEE '\e[0m\n'
}

PS3="What do you want?: "
select opt in İnstall Update Additional quit; 
do

  case $opt in
    İnstall)
    echo -e '\e[1;32mThe installation process begins...\e[0m'
    sleep 1
    dependiences
    variables
    binaries
    golang
    cosmovisor
    key_gen
    visor_bin
    config_service
    create_validator
    info
    done_process
    sleep 3
      break
      ;;
    Update)
    echo -e '\e[1;32mThe updating process begins...\e[0m'
    echo -e ''
    echo -e '\e[1;32mSoon...'
    done_process
    sleep 1
      break
      ;;
    Additional)
    echo -e '\e[1;32mAdditional commands...\e[0m'
    echo -e ''
    echo -e '\e[1;32mSoon...'
    sleep 1
      ;;
    quit)
    echo -e '\e[1;32mexit...\e[0m' && sleep 1
      break
      ;;
    *) 
      echo "Invalid $REPLY"
      ;;
  esac
done
