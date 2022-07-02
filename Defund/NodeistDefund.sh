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
echo "export CHAIN_ID=defund-private-1" >> $HOME/.bash_profile
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
ver="1.17.2"
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
cd $HOME
git clone https://github.com/defund-labs/defund
cd defund
make install

# config
defundd config chain-id $CHAIN_ID
defundd config keyring-backend file

# init
defundd init $NODENAME --chain-id $CHAIN_ID

# download addrbook and genesis
wget -qO $HOME/.defund/config/genesis.json "https://raw.githubusercontent.com/defund-labs/defund/163e2669b6870aa26b73d843312b22c9948b29c6/testnet/private/genesis.json"
wget -qO $HOME/.defund/config/addrbook.json "https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Defund/addrbook.json"

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ufetf\"/" $HOME/.defund/config/app.toml

# set peers and seeds
PEERS=5edb1d1ea619e6aca6901cdc2b5efdf7675bc203@65.108.75.237:2000,35f08f53a9951fc578ccb0d831a12f3db3e8bf9b@78.24.218.129:26656,0a210aa5877f295549fda04ffdc8a6ec30800701@38.242.220.37:26641,2db5d89ae038a9340733584c793dd39af2287e31@65.108.201.154:2070,64da25d0392f02d714b00bc2718c10e1f4176a20@185.209.228.203:26656,22e62b40fafb5ea108a5f21fe96a9190c03cd18f@49.12.246.112:26617,c0e274d771a82e1543896e46f1fa1803e039e538@46.8.220.166:26656,3964d1fb5145570c235816951f74c3a305b97ce1@95.216.39.183:26656,a7490dc2dbccb0913f8970a07591299348464d07@194.163.155.84:26651,63dd3684e5a45f6ddd93bdb80e42f26c9532f8a2@95.217.40.205:28656,f2cd8aba31e3423bd4ebe94732979571d6cc85fa@38.146.3.180:26656,019c0f713f1a3ff1e0b8ec87e40b98580f7311f7@51.91.208.59:26606,187b6c15982e0c59947278d4695d449179538b63@95.216.2.219:26656,e104f008f6d1227170d3b4ce1d73f0ea2068094f@84.201.162.168:26656,e23a7d906f45171d8bf7ca9c7785e91d4e09a4bd@77.83.92.238:60656,8e6903fe46ce8e13d582c0e01312872a2ba78a12@78.47.128.136:36656,4196d1145cfd6755d80305ce6bb3db4395f7b3f9@173.212.207.91:26656,c175754acc4d416ea0906851ab13690a5d99b61c@188.234.241.56:26656,1bf56637dcb950453c370ef7726da74436d21a61@95.214.52.200:26656,2c09aae4723bce93fff10948aed6e842b8cbce1d@89.163.223.34:26656,81015180073356e4fd62d0cd586027a2cd34d3d9@207.180.198.158:26656,3413532ad88c0d48023161eb9f8b10a9fb917673@5.164.29.175:46656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.defund/config/config.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.defund/config/config.toml

# add external (if dont use sentry), port is default
# external_address=$(wget -qO- eth0.me)
# sed -i -e "s/^external_address = \"\"/external_address = \"$external_address:26656\"/" $HOME/.defund/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.defund/config/app.toml

sleep 1

#Change port 32
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:36328\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:36327\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6321\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:36326\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":36320\"%" $HOME/.defund/config/config.toml
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9320\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9321\"%" $HOME/.defund/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:36327\"%" $HOME/.defund/config/client.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:36326\"/" $HOME/.defund/config/config.toml

sleep 1 

SNAP_RPC="https://defund-testnet-rpc.polkachu.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.defund/config/config.toml

sleep 1

sed -i.bak -e "s/indexer *=.*/indexer = \"null\"/g" $HOME/.defund/config/config.toml
sed -i "s/index-events=.*/index-events=[\"tx.hash\",\"tx.height\",\"block.height\"]/g" $HOME/.defund/config/app.toml

sleep 1

# reset
defundd tendermint unsafe-reset-all

echo -e "\e[1m\e[32m4. Servisler baslatiliyor... \e[0m" && sleep 1
# create service
tee $HOME/defundd.service > /dev/null <<EOF
[Unit]
Description=defundd
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which defundd) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/defundd.service /etc/systemd/system/

# start service
sudo systemctl daemon-reload
sudo systemctl enable defundd
sudo systemctl restart defundd

echo '=============== KURULUM BASARIYLA TAMAMLANDI ==================='
echo -e 'Loglari kontrol et: \e[1m\e[32mjournalctl -ujournalctl -u defundd -f -o cat\e[0m'
echo -e 'Senkronizasyon durumu kontrol et: \e[1m\e[32mcurl -s localhost:26657/status | jq .result.sync_info\e[0m'
