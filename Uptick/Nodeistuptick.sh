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
echo "export CHAIN_ID=uptick_7776-1" >> $HOME/.bash_profile
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
echo -e "\e[1m\e[32m2. Bagliliklar yukleniyor... \e[0m" && sleep 11
# packages
sudo apt install curl build-essential git wget jq make gcc tmux -y

# install go
ver="1.18.1"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download binary
cd $HOME
git clone https://github.com/UptickNetwork/uptick.git && cd uptick
git checkout v0.2.0
make install

# config
uptickd config chain-id $CHAIN_ID
uptickd config keyring-backend file

# init
uptickd init $NODENAME --chain-id $CHAIN_ID

# download genesis
wget -qO $HOME/.uptickd/config/genesis.json "https://raw.githubusercontent.com/UptickNetwork/uptick-testnet/main/uptick_7776-1/genesis.json"

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0auptick\"/" $HOME/.uptickd/config/app.toml

# set peers and seeds
SEEDS=$(curl -sL https://raw.githubusercontent.com/UptickNetwork/uptick-testnet/main/uptick_7776-1/seeds.txt | tr '\n' ',')
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.uptickd/config/config.toml

sleep 1
PEERS="6322143ca13c2e665a22007b156f6da03c5d5d96@89.163.218.107:26656,59322bb080aeefdb799cd6afd76edbb1a28f2be0@159.65.196.145:26656,21b269906ec4410de11d587600522058b791f0ae@194.163.172.188:26656,5cfb7852781a8aabe09b42b10dd68d799679348e@38.242.235.142:26656,02ee3a0f3a2002d11c5eeb7aa813b64c59d6b60e@52.221.152.60:26656,a30d262dc80310dc5311c7eccd9e2fa9489508f5@54.37.1.60:26656,1353b87e249f5c6c91e56ba28c4ed2e951117d38@194.163.138.251:26656,0621ceea3a6c8e14a8df374e473c925a9ac2d231@51.91.210.27:26656,228a2390a58b8c1d81ddf8820b8d35863ebec5ac@51.91.211.94:26656,4672f22ac78e3ae8aea42d625aba8269a86b798b@51.91.209.41:26656,1aad7c79a99724d1988178ce86f468d00f22ada1@54.37.6.31:26656,e2608335228e253ec6e58025158711eb2da71a1b@62.171.152.201:26656,34d4b06d4f2a5cd4d90824275b25f4d86c06a941@136.243.42.116:26656,01321ae5381701f520dace2c166c9b8be6021525@62.171.132.106:26656,2ec3ae0fcd024bd1f9c37fda5f07f5212a56de0b@51.91.209.168:26656,afa0a534274509619d22aece527fb3c09b7416a6@144.91.106.98:26656,05ffa00e1dd4f8bd690ed72e13b1cdbc3220fea9@54.37.6.142:26656,95466ab27a06443ab35aa00ed51f762ac57c3f5c@149.102.152.208:26656,fdb970a918fcbcbfbe2f508ebb4adfbbf3f7f319@144.76.107.250:26356,5e043623fc73315e6632d17497de425483a4d047@135.181.203.201:26656,e8e4577a8b0e6a4af444903f734e6533fc963de8@149.102.159.18:26656,c9d8bae5e9ca6b4c2bfa11c17dc470ef395515b3@65.21.129.95:36656,70c46102ed83f10c886ed21b1dfc7a9a4b858acf@65.21.89.42:21656,9b62239788753c6eda0e44b5aa3181bdfa5720a5@65.108.193.204:26656,464e2ac90f5b206dbef96f32347457c0e763ed14@185.253.217.28:26656,1f6f368a3e8973017cbb6b4878887b170fbef28c@78.46.108.181:26656,12167dfafdd017b65bb4311887029fe86d6a48a7@154.53.52.35:26656,a81a2b4680c0045c43750433f0a18fff3ab56ad4@51.161.83.144:26656,5bb622d09d565cb81d4212f4b05d358b276d4ca4@51.161.82.179:26656,e7efbf0afc4202d31f13c345f7e439efcc25aba0@154.12.228.149:26656,7d468224ec9ff7aeabffc23352e6a8b55ed7c0c5@194.146.12.166:26656,99d45e17dd2879bb5fd964e19d8564f5554a5390@49.12.215.72:26666,83947075e0c4f66161f5ec499c7b8973e8d9419d@144.91.77.189:46656,609a3bf686e248e768735495d46163e7c7a4bfcb@62.171.181.22:26656,8d4d5a503cc5e8c5dd29f41f6a99ab7477c31685@65.108.198.54:26656,2c87e4b230afcef84cd2006a179bbffa74b59d88@65.108.144.69:26656,9afa3612aabf851bd73d9e219274520e8be6454d@154.12.236.150:26656,35d16b3ecaf5044a817ebb52c5ceb7955eb8e1a8@194.163.168.241:26656,87fe9c4d87c388c3690e7e95e720a8c9ac834a07@154.12.242.17:26656,51c2c58bba454c2fc7dcd6f6c32125c6b1ef3f87@161.97.130.125:26656,d318bfbeddb58a1f7b35a930a720a4d3b21923e2@38.242.213.216:26656,3c65d7e9dbf1e079cf73dad44c798c2057535f12@185.215.167.227:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.uptickd/config/config.toml

# disable indexing
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.uptickd/config/config.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.uptickd/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.uptickd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.uptickd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.uptickd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.uptickd/config/app.toml

sleep 1 

# sync using State Sync
SNAP_RPC1="http://peer0.testnet.uptick.network:26657" \
&& SNAP_RPC2="http://peer1.testnet.uptick.network:26657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC2/block | jq -r .result.block.header.height) \
&& BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)) \
&& TRUST_HASH=$(curl -s "$SNAP_RPC2/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC1,$SNAP_RPC2\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.uptickd/config/config.toml


sleep 1 

# Change port 40
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:36408\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:36407\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6401\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:36406\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":36400\"%" $HOME/.uptickd/config/config.toml
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9400\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9401\"%" $HOME/.uptickd/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:36407\"%" $HOME/.uptickd/config/client.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:36406\"/" $HOME/.uptickd/config/config.toml


sleep 1


# reset
uptickd tendermint unsafe-reset-all

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/uptickd.service > /dev/null <<EOF
[Unit]
Description=uptick
After=network-online.target

[Service]
User=$USER
ExecStart=$(which uptickd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable uptickd
sudo systemctl restart uptickd

echo '=============== SETUP FINISHED ==================='
echo -e 'To check logs: \e[1m\e[32mjournalctl -u uptickd -f -o cat\e[0m'
echo -e 'To check sync status: \e[1m\e[32mcurl -s localhost:26657/status | jq .result.sync_info\e[0m'
