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
echo "export CHAIN_ID=harpoon-4" >> $HOME/.bash_profile
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
wget https://raw.githubusercontent.com/Team-Kujira/networks/master/testnet/harpoon-4.json -O $HOME/.kujira/config/genesis.json
wget https://raw.githubusercontent.com/Team-Kujira/networks/master/testnet/addrbook.json -O $HOME/.kujira/config/addrbook.json

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ufetf\"/" $HOME/.kujira/config/app.toml

# set peers and seeds
PEERS=6ff1bdb19816e6e955965c705bd44192c6400601@51.38.127.25:26656,1b1ac7b7e957e9e2d5391a38b1ba3e4e5d2f3210@135.181.146.40:26656,1a80d041e13cb211391785cfdec25fc8ce6fb4c4@157.90.183.167:26656,5da378a7b0edfd1b639262a0d1ce69b3896158a7@38.242.244.73:26656,06174b09db94d2e59d6bda4d60d8328594b9c2e7@217.160.36.66:12156,0b4d4dae6953d954fc94362997dff3456764b2b4@5.9.138.91:26656,092617bcf66bc91118225b7794fd0acf4202d92a@107.181.244.202:26656,20f0409359fa455d7ca11b81039782a260899579@195.201.164.223:26656,74446e62d66daab41734bee243a9aee43cc9c009@65.108.199.187:26656,ccb32ae7e8976a64a340f26610c54a3d4e8a9863@178.62.199.143:26656,c009938f56e54754a70bd6fd46b277c5c4854e56@65.108.11.180:26656,2cc485f4b9fa6651a828a6dd3373f0d2bc05b64f@65.21.201.244:26876,3d207046e1410f67852908b8a11585d463448f11@135.181.157.37:26656,06ebd0b308950d5b5a0e0d81096befe5ba07e0b3@193.31.118.143:25656,1aaa54c8afc9b1acd2421ad42ed6d29839ddd114@38.242.244.75:26656,843e2db960439151cd6b87d7c3bd7aea5e2d552f@95.216.7.241:40000,71df150b968896f49863e228fd3c590c1bcbcd38@194.163.164.52:26656,d2dc7d746b8017b0be594b74691a3ae15b67e1f7@38.242.244.72:26656,21fb5e54874ea84a9769ac61d29c4ff1d380f8ec@188.132.128.149:25656,4a3a0e62750c959ff4e9569461d32a91d9fc5e04@65.108.233.175:26656,a7bab0f25d638f913f558fe9be16718b07cfccda@65.108.72.175:29655,19ade81d57a59b0279af31d57cd62e9a88a25109@195.3.221.131:26656,57cf7bb8c79c46f74c3f9d4fda7ab8047ab518e1@38.242.199.201:26656,4330c56631adda7d64875859a019b3b3ddc6a5d7@16.163.74.176:26646,ccd2861990a98dc6b3787451485b2213dd3805fa@185.144.99.234:26656,d2127444daca86e343a336499fd6c32cd2ce243d@164.92.67.221:26656,deffdfec77bee19f52c54b81b99b376d9814ce6f@80.240.24.175:26656,9eb94f1a8793974a70cd4ec4c296bf0f1e754565@167.71.79.131:26656,e32ccdf863aaae227f35b4e552175c8f5a842cf4@159.223.218.77:26656,64ae92c5854120ce190b3f54ec61317e349acb5f@38.242.244.74:26656,8a5b9e05aaa0203fc00dee3888a0a3955fc9ed3c@167.235.237.28:26656,87ea1a43e7eecdd54399551b767599921e170399@52.215.221.93:26656,eaa7e55efc03f23c5f461f71c06d444693d5352b@135.181.133.37:29656,139b2d1725dd7e31957c1443d101136ba8a56770@65.108.71.202:26656,b690b0e6a904fc0172ef1eccc07bea9f48f4e454@141.94.73.39:53756,2d2805354c7fa940fe7f98ceba93f18a6f2406f0@69.174.102.196:26656,0d277ec63b669054bdc4e63d21cd650280c4f127@104.237.129.29:26656,60fa083de69f33932987e12660f4e1daa8009bf9@38.242.243.71:26656,53d2da3a0bd3d6214263cebca94ee1b58f9f849a@78.183.102.124:27656,cf0c1fb5ca00f3a8576e0aacdcdc1a35f38a9e03@136.243.93.134:14095,45520598b23d1eccc6d69a8975a77b32b1b9787a@65.108.228.227:26656,b525548dd8bb95d93903b3635f5d119523b3045a@194.163.142.29:26656,94f3141cbdc9e26ad07196565761a7cb99bcffe8@46.4.62.104:20095,e94097fc56e34f484c2f882f2c251ddc16bd9465@104.197.218.166:26656,da5a776a0ef10ef52a45d6203bb6a1db9e2fce11@75.119.144.233:26656,640ebd174b1e1fe43f2761dc0fb0e99ff28ccc69@38.242.243.73:26656,4bba4fc2d07b6f8b5aa0de8668e9d10cf22f1fe8@65.108.229.56:26656,1dcfb8684153c711dcc4a7b65043f515d1293ce7@34.125.145.211:26656,239b6d1544eca6129456f28ff47d824c297cbdf0@146.190.230.242:26656,3f26aa959f2a0f16749747c63767c1e491275cae@88.198.242.163:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.kujira/config/config.toml

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

sleep 1

#Change port 34
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:36348\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:36347\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6341\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:36346\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":36340\"%" $HOME/.kujira/config/config.toml
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9340\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9341\"%" $HOME/.kujira/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:36347\"%" $HOME/.kujira/config/client.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:36346\"/" $HOME/.kujira/config/config.toml

sleep 1 

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
