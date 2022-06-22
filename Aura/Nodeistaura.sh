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
echo "export CHAIN_ID=halo-testnet-001" >> $HOME/.bash_profile
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
sudo apt install curl build-essential git wget jq make gcc tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y

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
wget https://github.com/aura-nw/aura/archive/refs/tags/halo_6ca81d8.tar.gz
tar -xzvf halo_6ca81d8.tar.gz
cd aura-halo_6ca81d8
make build
mv $HOME/aura-halo_6ca81d8/aurad /usr/local/bin/aurad

# config
aurad config chain-id $CHAIN_ID
aurad config keyring-backend test

# init
aurad init $NODENAME --chain-id $CHAIN_ID

# download addrbook and genesis
wget -qO $HOME/.aura/config/genesis.json "https://raw.githubusercontent.com/aura-nw/testnets/main/halo-testnet-001/genesis.json"

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uaura\"/" $HOME/.aura/config/app.toml

# set peers and seeds
SEEDS="10b5458c22c7dc6862ba9c2f4928a60af214c16c@3.210.178.93:26656,42f0c254710b2b22c67555ff4c2ad7e1390b5965@34.203.177.141:26656"
PEERS=""
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.aura/config/config.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.aura/config/config.toml

# add external (if dont use sentry), port is default
# external_address=$(wget -qO- eth0.me)
# sed -i -e "s/^external_address = \"\"/external_address = \"$external_address:26656\"/" $HOME/.aura/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.aura/config/app.toml 
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.aura/config/app.toml 
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.aura/config/app.toml 
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.aura/config/app.toml 

sleep 1

#Change port 31
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:36318\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:36317\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6311\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:36316\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":36310\"%" $HOME/.aura/config/config.toml
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9310\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9311\"%" $HOME/.aura/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:36317\"%" $HOME/.aura/config/client.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:36316\"/" $HOME/.aura/config/config.toml

sleep 1 


indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.aura/config/config.toml

sleep 1

# reset
aurad tendermint unsafe-reset-all

echo -e "\e[1m\e[32m4. Servisler baslatiliyor... \e[0m" && sleep 1
# create service
tee $HOME/aurad.service > /dev/null <<EOF
[Unit]
Description=aurad
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which aurad) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/aurad.service /etc/systemd/system/

# start service
sudo systemctl daemon-reload
sudo systemctl enable aurad
sudo systemctl restart aurad

echo '=============== KURULUM BASARIYLA TAMAMLANDI ==================='
echo -e 'Loglari kontrol et: \e[1m\e[32mjournalctl -ujournalctl -u aurad -f -o cat\e[0m'
echo -e 'Senkronizasyon durumu kontrol et: \e[1m\e[32mcurl -s localhost:26657/status | jq .result.sync_info\e[0m'
