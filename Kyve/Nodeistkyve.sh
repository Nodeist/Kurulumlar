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
# set vars
if [ ! $NODENAME ]; then
	read -p "Node ismi yaziniz: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
echo "export WALLET=wallet" >> $HOME/.bash_profile
echo "export CHAIN_ID=korellia" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo 'Node isminiz: ' $NODENAME
echo 'Cüzdan isminiz: ' $WALLET
echo 'Chain ismi: ' $CHAIN_ID
echo '================================================='
sleep 2
echo -e "\e[1m\e[32m1. Paketler güncelleniyor... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y
echo -e "\e[1m\e[32m2. Bagliliklar yukleniyor... \e[0m" && sleep 1
# packages
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
# install go
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

echo -e "\e[1m\e[32m3. kutuphaneler indirilip yukleniyor... \e[0m" && sleep 1
# download binary
mkdir kyvebinary && cd kyvebinary
wget -q https://github.com/KYVENetwork/chain/releases/download/v0.0.1/chain_linux_amd64.tar.gz
tar -xzf chain_linux_amd64.tar.gz
sudo mv chaind kyved
sudo chmod +x kyved
sudo mv $HOME/kyvebinary/kyved /usr/bin/
cd $HOME && rm -rf kyvebinary

sleep 1

wget https://github.com/KYVENetwork/chain/releases/download/v0.0.1/cosmovisor_linux_amd64 
mv cosmovisor_linux_amd64 cosmovisor
chmod +x cosmovisor
cp cosmovisor /usr/bin

sleep 1

#Set variable
echo export CHAIN_ID=korellia >> $HOME/.profile
echo export denom=tkyve >> $HOME/.profile
mkdir -p ~/.kyve/cosmovisor/genesis/bin/
echo "{}" > ~/.kyve/cosmovisor/genesis/upgrade-info.json
cp /usr/bin/kyved ~/.kyve/cosmovisor/genesis/bin/
echo 'export DAEMON_HOME="$HOME/.kyve"' >> $HOME/.profile
echo 'export DAEMON_NAME="kyved"' >> $HOME/.profile
echo 'export DAEMON_ALLOW_DOWNLOAD_BINARIES="true"' >> $HOME/.profile
echo 'export DAEMON_RESTART_AFTER_UPGRADE="true"' >> $HOME/.profile
echo 'export UNSAFE_SKIP_BACKUP="true"' >> $HOME/.profile
source ~/.profile

sleep 1

# config
kyved config chain-id $CHAIN_ID
kyved config keyring-backend file

# init
kyved init $NODENAME --chain-id $CHAIN_ID

# download addrbook and genesis
wget -qO $HOME/.kyve/config/genesis.json "https://github.com/KYVENetwork/chain/releases/download/v0.0.1/genesis.json"
wget -qO $HOME/.kyve/config/addrbook.json "https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Kyve/addrbook.json"

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0tkyve\"/" $HOME/.kyve/config/app.toml

# set peers and seeds
peers="a3fd6919ec3c5eb0fcd26dd9758ad8183bb7a93d@51.15.104.178:26656,52880e07804a612a3611025b4283e845084c2b26@38.242.241.164:26256,6215a7936b5410dd4b8ec1d25d80b80aaee275bc@45.10.43.108:26656,e56574f922ff41c68b80700266dfc9e01ecae383@18.156.198.41:26656,022399338c77a6be4bf26d6b0735030c6c95732f@194.163.189.114:56656,f85664da0bb5787b6d7e93c4d4cbb344374f1fce@178.20.43.103:26656,52be70508d5bceb14dd8745471f437182201e59b@135.181.6.243:26632,6fac99ff534a905f3339b400547d2c731ad3d6f7@45.10.42.125:26656,eb2172370e3e1f77fadef9018e1c503e12839b7e@62.113.119.150:26656,522bf8fe88ee84316a06c9f94a195fa0096ff2ad@77.83.92.238:26656,8813c8167b8f5a91e10bee676e9738c7d928ad7a@139.59.100.3:26656,e1a13fab199f489b41c0a0f705bf06cf46dc4d3f@165.227.202.155:26656"
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/; s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.kyve/config/config.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.kyve/config/config.toml

# add external (if dont use sentry), port is default
# external_address=$(wget -qO- eth0.me)
# sed -i -e "s/^external_address = \"\"/external_address = \"$external_address:26656\"/" $HOME/.kyve/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.kyve/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.kyve/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.kyve/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.kyve/config/app.toml

sleep 1

#Change port 35
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:36358\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:36357\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6351\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:36356\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":36350\"%" $HOME/.kyve/config/config.toml
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9350\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9351\"%" $HOME/.kyve/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:36357\"%" $HOME/.kyve/config/client.toml

sleep 1

sed -i.bak -e "s/indexer *=.*/indexer = \"null\"/g" $HOME/.kyve/config/config.toml
sed -i "s/index-events=.*/index-events=[\"tx.hash\",\"tx.height\",\"block.height\"]/g" $HOME/.kyve/config/app.toml

sleep 1

# reset
kyved tendermint unsafe-reset-all --home $HOME/.kyve

echo -e "\e[1m\e[32m4. Servisler baslatiliyor... \e[0m" && sleep 1
# create service
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

[Install]
WantedBy=multi-user.target
EOF

sleep 1

sudo mv $HOME/kyved.service /etc/systemd/system/

# start service
sudo systemctl daemon-reload
sudo systemctl enable kyved
sudo systemctl restart kyved

echo '=============== KURULUM BASARIYLA TAMAMLANDI ==================='
echo -e 'Loglari kontrol et: \e[1m\e[32mjournalctl -fu kyved -o cat\e[0m'
echo -e 'Senkronizasyon durumu kontrol et: \e[1m\e[32mcurl -s localhost:26657/status | jq .result.sync_info\e[0m'kyve
