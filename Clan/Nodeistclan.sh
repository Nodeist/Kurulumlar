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
echo "export CHAIN_ID=playstation-2" >> $HOME/.bash_profile
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
	mkdir clanbinary && cd clanbinary
	wget https://github.com/ClanNetwork/clan-network/releases/download/v1.0.4-alpha/clan-network_v1.0.4-alpha_linux_amd64.tar.gz
    sudo tar -C /usr/local/bin -zxvf clan-network_v1.0.4-alpha_linux_amd64.tar.gz
    mv /usr/local/bin/cland /usr/bin
    sleep 1
    cland config chain-id playstation-2
    cd $HOME && rm -rf clanbinary
    wget -q -O ~/.clan/config/genesis.json https://raw.githubusercontent.com/ClanNetwork/testnets/main/playstation-2/genesis.json

# config
cland config chain-id $CHAIN_ID
cland config keyring-backend file

# init
cland init $NODENAME --chain-id $CHAIN_ID

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uclan\"/" $HOME/.clan/config/app.toml

# set peers and seeds
    PEERS="be8f9c8ff85674de396075434862d31230adefa4@35.231.178.87:26656,0cb936b2e3256c8d9d90362f2695688b9d3a1b9e@34.73.151.40:26656,e85dc5ec5b77e86265b5b731d4c555ef2430472a@23.88.43.130:26656,9d7ec4cb534717bfa51cdb1136875d17d10f93c3@116.203.60.243:26656,3049356ee6e6d7b2fa5eef03555a620f6ff7591b@65.108.98.218:56656,61db9dede0dff74af9309695b190b556a4266ebf@34.76.96.82:26656,d97c9ac4a8bb0744c7e7c1a17ac77e9c33dc6c34@34.116.229.135:26656"
    sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.clan/config/config.toml
	
# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.clan/config/config.toml

# add external (if dont use sentry), port is default
# external_address=$(wget -qO- eth0.me)
# sed -i -e "s/^external_address = \"\"/external_address = \"$external_address:26656\"/" $HOME/.clan/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.clan/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.clan/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.clan/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.clan/config/app.toml

sleep1

#Change port 31
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:36318\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:36317\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6311\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:36316\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":36310\"%" $HOME/.clan/config/config.toml
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9310\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9311\"%" $HOME/.clan/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:36317\"%" $HOME/.clan/config/client.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:36316\"/" $HOME/.clan/config/config.toml

sleep 1 

# reset
cland tendermint unsafe-reset-all

echo -e "\e[1m\e[32m4. Servisler baslatiliyor... \e[0m" && sleep 1
# create service
tee $HOME/cland.service > /dev/null <<EOF
[Unit]
Description=cland
After=network-online.target
[Service]
Type=simple
User=$USER
ExecStart=$(which cland) start
Restart=always
RestartSec=3
LimitNOFILE=infinity
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/cland.service /etc/systemd/system/

# start service
sudo systemctl daemon-reload
sudo systemctl enable cland
sudo systemctl restart cland

echo '=============== KURULUM BASARIYLA TAMAMLANDI ==================='
echo -e 'Loglari kontrol et: \e[1m\e[32mjournalctl -ujournalctl -u cland -f -o cat\e[0m'
echo -e 'Senkronizasyon durumu kontrol et: \e[1m\e[32mcurl -s localhost:26657/status | jq .result.sync_info\e[0m'
