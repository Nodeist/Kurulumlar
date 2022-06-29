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
echo "export CHAIN_ID=anone-testnet-1" >> $HOME/.bash_profile
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
git clone https://github.com/notional-labs/anone
cd anone || return
git checkout testnet-1.0.3
make install
anoned version # testnet-1.0.3


# config
anoned config chain-id $CHAIN_ID
anoned config keyring-backend file

# init
anoned init $NODENAME --chain-id $CHAIN_ID

# download addrbook and genesis
wget -qO $HOME/.anone/config/genesis.json "https://raw.githubusercontent.com/notional-labs/anone/master/networks/testnet-1/genesis.json"
wget -qO $HOME/.anone/config/addrbook.json "https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Deweb(DWS)/addrbook.json"

# set minimum gas price
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001uan1"|g' $HOME/.anone/config/app.toml

# set peers and seeds
seeds=""
peers="3137535a0d6cc552bd44512ac6a11f4a41c3b3e4@rpc1-testnet.nodejumper.io:26656,49a49db05e945fc38b7a1bc00352cafdaef2176c@95.217.121.243:2280,80f0ef5d7c432d2bae99dc8437a9c3db464890cd@65.108.128.139:2280"
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.anone/config/config.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.anone/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.anone/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.anone/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.anone/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.anone/config/app.toml

sleep 1

#Change port 42
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:36428\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:36427\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6421\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:36426\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":36420\"%" $HOME/.anone/config/config.toml
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9420\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9421\"%" $HOME/.anone/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:36427\"%" $HOME/.anone/config/client.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:36426\"/" $HOME/.anone/config/config.toml

sleep 1 


SNAP_RPC="http://rpc1-testnet.nodejumper.io:26657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.anone/config/config.toml


# reset
anoned tendermint unsafe-reset-all —home $HOME/.anone 

echo -e "\e[1m\e[32m4. Servisler baslatiliyor... \e[0m" && sleep 1
# create service
tee $HOME/anoned.service > /dev/null <<EOF
[Unit]
Description=anoned
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which anoned) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/anoned.service /etc/systemd/system/

# start service
sudo systemctl daemon-reload
sudo systemctl enable anoned
sudo systemctl restart anoned

echo '=============== SETUP FINISHED ==================='
echo -e 'To check logs: \e[1m\e[32mjournalctl -ujournalctl -u anoned -f -o cat\e[0m'
echo -e 'To check sync status: \e[1m\e[32mcurl -s localhost:26657/status | jq .result.sync_info\e[0m'
