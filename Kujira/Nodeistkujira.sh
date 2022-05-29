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
echo "export CHAIN_ID=harpoon-3" >> $HOME/.bash_profile
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
wget https://go.dev/dl/go1.18.2.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go1.18.2.linux-amd64.tar.gz"
rm "go1.18.2.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
curl https://get.ignite.com/cli! | bash

echo -e "\e[1m\e[32m3. kutuphaneler indirilip yukleniyor... \e[0m" && sleep 1

# download binary
cd $HOME
git clone https://github.com/Team-Kujira/core $HOME/kujira-core
cd kujira-core
ignite chain build

# config
kujirad config chain-id $CHAIN_ID
kujirad config keyring-backend file

# init
kujirad init $NODENAME --chain-id $CHAIN_ID

# download addrbook and genesis
wget https://raw.githubusercontent.com/Team-Kujira/networks/master/testnet/harpoon-3.json -O $HOME/.kujira/config/genesis.json
wget https://raw.githubusercontent.com/Team-Kujira/networks/master/testnet/addrbook.json -O $HOME/.kujira/config/addrbook.json

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ufetf\"/" $HOME/.kujira/config/app.toml

# set peers and seeds
PEERS="2dd16d52e2a054d9ffa6d72b25df8a517e1abfa0@135.181.59.162:18656,bee48b090b97ef1a8adca4adecf897e5d29c6909@3.39.245.44:26656,cf0c1fb5ca00f3a8576e0aacdcdc1a35f38a9e03@138.201.16.240:14095,f0e098e90f4e3791c3409ed11b9e0aab3388530b@167.235.240.46:26656,86093241c8b102a6fe2f9a0836adab46bc078b6e@213.52.129.168:26656,0df7e31b5c8bac85d314a5dd25d2a8de10d4f716@45.79.38.32:26656,ae4234e1151243fff7b00b759c4afb200b442389@172.105.101.234:26656,f9346e4680529c222f374dfb62eb53769a10d656@116.203.210.205:26656,861f4624276d80aa538ad446ce608910ca24940d@148.251.177.45:11656,f05653bf9ace9aa2aba55c931646897d30461cc6@65.108.67.92:26656,f871ffd78a73875a40192cc715420cec38f83d73@2a01:4f9:1a:a718::2:26656,1257a50952d824e3b27ffa5a137ffd602b31a23e@95.216.75.106:26656,1e6a1c254a5a01c93f41af7539cbbc4061b686e8@157.90.183.167:26656,0124108674c7e30eadcb8bad6040ce8c1cdd4001@65.108.66.4:10156,df694b1db9ab3e464d465b69bf96d55fbb72e85e@65.21.200.36:26676,4e334cfd50217f1b69c6af4c31d0fd8741ac18be@65.108.231.167:26656,843e2db960439151cd6b87d7c3bd7aea5e2d552f@188.40.140.51:46656,4a9c09a040acd251a09b3710560fe50cf9b81fa6@157.90.81.24:2210,f258cf0fe4ce8d533baf80c4a6079ddcb90e6d83@65.108.205.202:26656,90e60c7bbf85c6be81e8895bfebff070b38adb6c@185.169.252.239:26656,deffdfec77bee19f52c54b81b99b376d9814ce6f@80.240.24.175:26656,c5841c44e2e283c2bb3eaf68509d9b4a4076a687@185.163.64.143:27656,9798a032b72383cd2a2b3e9e1defcce9b6993e58@13.124.132.217:26656,c2b15500ec431294d0df944150aff8804ee68eb5@168.119.187.160:26656,09010b38a2234577208810d30b028d4910272abb@65.108.89.79:26656,1f441ca5b137dedef7e8035706691be3c1b220f4@135.181.209.51:26866,abe382421cfc6d0fc37fab4acfbdc894d8a6b879@79.116.135.91:26656"
sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.kujira/config/config.toml

sleep 1
SNAP_RPC="https://kujira-testnet-rpc.polkachu.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.kujira/config/config.toml

sleep 1



# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.kujira/config/config.toml

# add external (if dont use sentry), port is default
# external_address=$(wget -qO- eth0.me)
# sed -i -e "s/^external_address = \"\"/external_address = \"$external_address:26656\"/" $HOME/.kujira/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.kujira/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.kujira/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.kujira/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.kujira/config/app.toml

# reset
kujirad tendermint unsafe-reset-all

echo -e "\e[1m\e[32m4. Servisler baslatiliyor... \e[0m" && sleep 1
# create service
tee $HOME/kujirad.service > /dev/null <<EOF
[Unit]
Description=kujirad
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which kujirad) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/kujirad.service /etc/systemd/system/

# start service
sudo systemctl daemon-reload
sudo systemctl enable kujirad
sudo systemctl restart kujirad

echo '=============== KURULUM BASARIYLA TAMAMLANDI ==================='
echo -e 'Loglari kontrol et: \e[1m\e[32mjournalctl -ujournalctl -u kujirad -f -o cat\e[0m'
echo -e 'Senkronizasyon durumu kontrol et: \e[1m\e[32mcurl -s localhost:26657/status | jq .result.sync_info\e[0m'
