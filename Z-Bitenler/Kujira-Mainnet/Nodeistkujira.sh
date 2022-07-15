#!/bin/bash
echo "=================================================="
echo "   _  ______  ___  __________________";
echo "  / |/ / __ \/ _ \/ __/  _/ __/_  __/";
echo " /    / /_/ / // / _/_/ /_\ \  / /   ";
echo "/_/|_/\____/____/___/___/___/ /_/    ";
echo -e "\e[0m"
echo "=================================================="                                     


sleep 2

# DEGISKENLER by Nodeist
KUJI:kujirad
KUJI_ID:kaiyo-1
KUJI_PORT:10
KUJI_FOLDER:.kujira
KUJI_FOLDER2:kujira
KUJI_VER:v0.4.1
KUJI_REPO:https://github.com/Team-Kujira/core.git
KUJI_GENESIS:https://raw.githubusercontent.com/Team-Kujira/networks/master/mainnet/kaiyo-1.json
KUJI_ADDRBOOK:
KUJI_MIN_GAS:0.00125
KUJI_DENOM:ukuji
KUJI_SEEDS:5a70fdcf1f51bb38920f655597ce5fc90b8b88b8@136.244.29.116:41656
KUJI_PEERS:9813378d0dceb86e57018bfdfbade9d863f6f3c8@3.38.73.119:26656,ccffabe81f2de8a81e171f93fe1209392bf9993f@65.108.234.59:26656,7878121e8fa201c836c8c0a95b6a9c7ac6e5b101@141.95.151.171:26656,0743497e30049ac8d59fee5b2ab3a49c3824b95c@198.244.200.196:26656,2efead362f0fc7b7fce0a64d05b56c5b28d5c2b4@164.92.209.72:36347,d24ee4b38c1ead082a7bcf8006617b640d3f5ab9@91.196.166.13:26656,5d0f0bc1c2d60f1d273165c5c8cefc3965c3d3c9@65.108.233.175:26656,5a70fdcf1f51bb38920f655597ce5fc90b8b88b8@136.244.29.116:41656,35af92154fdb2ac19f3f010c26cca9e5c175d054@65.108.238.61:27656,e65c2e27ea06b795a25f3ce813ed2062371705b8@213.239.212.121:13657,f6d0d3ac0c748a343368705c37cf51140a95929b@146.59.81.204:36657

sleep 1

echo "export KUJI=${KUJI}" >> $HOME/.bash_profile
echo "export KUJI_ID=${KUJI_ID}" >> $HOME/.bash_profile
echo "export KUJI_PORT=${KUJI_PORT}" >> $HOME/.bash_profile
echo "export KUJI_FOLDER=${KUJI_FOLDER}" >> $HOME/.bash_profile
echo "export KUJI_VER=${KUJI_VER}" >> $HOME/.bash_profile
echo "export KUJI_REPO=${KUJI_REPO}" >> $HOME/.bash_profile
echo "export KUJI_GENESIS=${KUJI_GENESIS}" >> $HOME/.bash_profile
echo "export KUJI_PEERS=${KUJI_PEERS}" >> $HOME/.bash_profile
echo "export KUJI_SEED=${KUJI_SEED}" >> $HOME/.bash_profile
echo "export KUJI_MIN_GAS=${KUJI_MIN_GAS}" >> $HOME/.bash_profile
echo "export KUJI_MIN_GAS=${KUJI_DENOM}" >> $HOME/.bash_profile

sleep 1

if [ ! $NODENAME ]; then
	read -p "NODE ISMI YAZINIZ: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi

echo '================================================='
echo -e "NODE ISMINIZ: \e[1m\e[32m$NODENAME\e[0m"
echo -e "CUZDAN ISMINIZ: \e[1m\e[32m$WALLET\e[0m"
echo -e "CHAIN ISMI: \e[1m\e[32m$KUJI_ID\e[0m"
echo -e "PORT NUMARANIZ: \e[1m\e[32m$KUJI_PORT\e[0m"
echo '================================================='

sleep 2

echo -e "\e[1m\e[32m1. Paketler güncelleniyor... \e[0m" && sleep 1

# GUNCELLEMELER by Nodeist
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Bagliliklar yukleniyor... \e[0m" && sleep 1

# GEREKLI PAKETLER by Nodeist
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

# GO KURULUMU by Nodeist
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

sleep 1

# KUTUPHANE KURULUMU by Nodeist
cd $HOME
git clone $KUJI_REPO
cd core
git checkout $KUJI_VER
make install

sleep 1

# KONFIGURASYON by Nodeist
$KUJI config chain-id $KUJI_ID
$KUJI config keyring-backend file
$KUJI init $NODENAME --chain-id $KUJI_ID

# ADDRBOOK ve GENESIS by Nodeist
wget $KUJI_GENESIS -O $HOME/$KUJI_FOLDER/config/genesis.json
wget $KUJI_ADDRBOOK -O $HOME/$KUJI_FOLDER/config/addrbook.json

# EŞLER VE TOHUMLAR by Nodeist
SEEDS="$KUJI_SEEDS"
PEERS="$KUJI_PEERS"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$KUJI_FOLDER/config/config.toml

sleep 1


# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$KUJI_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$KUJI_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$KUJI_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$KUJI_FOLDER/config/app.toml


# ÖZELLEŞTİRİLMİŞ PORTLAR by Nodeist
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${KUJI_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${KUJI_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${KUJI_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${KUJI_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${KUJI_PORT}660\"%" $HOME/$KUJI_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${KUJI_PORT}317\"%; s%^address = \":8080\"%address = \":${KUJI_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${KUJI_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${KUJI_PORT}091\"%" $HOME/$KUJI_FOLDER/config/app.toml


# PROMETHEUS AKTIVASYON by Nodeist
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/$KUJI_FOLDER/config/config.toml

# MINIMUM GAS AYARI by Nodeist
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00125$KUJI_DENOM\"/" $HOME/$KUJI_FOLDER/config/app.toml

# INDEXER AYARI by Nodeist
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/$KUJI_FOLDER/config/config.toml

# RESET by Nodeist
$KUJI unsafe-reset-all --home $HOME/$KUJI_FOLDER

echo -e "\e[1m\e[32m4. Servisler baslatiliyor... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/$KUJI.service > /dev/null <<EOF
[Unit]
Description=$KUJI
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which $KUJI) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF


# SERVISLERI BASLAT by Nodeist
sudo systemctl daemon-reload
sudo systemctl enable $KUJI
sudo systemctl restart $KUJI

echo '=============== KURULUM TAMAM! by Nodeist ==================='
echo -e 'LOGLARI KONTROL ET: \e[1m\e[32mjournalctl -u $KUJI -f -o cat\e[0m'
echo -e "SENKRONIZASYONU KONTROL ET: \e[1m\e[32mcurl -s localhost:${KUJI_PORT}657/status | jq .result.sync_info\e[0m"
