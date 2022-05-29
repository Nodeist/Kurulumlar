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
    wget -q https://github.com/KYVENetwork/chain/releases/download/v0.3.0/chain_linux_amd64.tar.gz
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
    PEERS="e7b4f7833edea6281071bec25e9c7e0e8455cb7e@173.249.59.141:26656,eb2fa2e524332f90e76d1bc9e989b96b1d1c8476@167.86.69.194:26656,fd5d98a69998017c10ef9f4f08254d222478aa8b@195.2.85.56:26656,9a655c23bd3f043cebe8bc557b9c221d03e54b84@185.218.124.201:26656,a24fc4dfdf780931a9d3c1f5082431fea7a33dca@65.108.225.158:10656,6215a7936b5410dd4b8ec1d25d80b80aaee275bc@45.10.43.108:26656,189d8c0f278aa7925bc1501f6f8e2febafb6066f@135.181.251.108:26656,71ea9b725f02ec514b01b28c72f738b0bc810e69@144.76.63.67:26209,4e3da7567b4696b5a9d5163932f9999136ee916d@185.43.4.187:26656,9fac06a086f3dbc854dd84926ccf7c177074aaa1@136.244.119.227:26656"
    sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.kyve/config/config.toml
    rm $HOME/.kyve/config/addrbook.json && wget -P $HOME/.kyve/config https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Kyve/addrbook.json
        sleep 2

    pruning="custom"
    pruning_keep_recent="100"
    pruning_keep_every="0"
    pruning_interval="10"
    sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.defund/config/app.toml
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
