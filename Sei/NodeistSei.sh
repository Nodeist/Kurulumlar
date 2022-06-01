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
echo "export CHAIN_ID=sei-testnet-1" >> $HOME/.bash_profile
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
git clone --depth 1 --branch 1.0.1beta https://github.com/sei-protocol/sei-chain.git
cd sei-chain
git checkout 1.0.1beta
go build -o build/seid ./cmd/sei-chaind
chmod +x ./build/seid && sudo mv ./build/seid /usr/local/bin/seid

# config
seid config chain-id $CHAIN_ID
seid config keyring-backend file

# init
seid init $NODENAME --chain-id $CHAIN_ID

# download genesis and addrbook
wget -qO $HOME/.sei/config/genesis.json "https://raw.githubusercontent.com/sei-protocol/testnet/master/sei-testnet-1/genesis.json"
wget -qO $HOME/.sei/config/addrbook.json "https://raw.githubusercontent.com/sei-protocol/testnet/master/sei-testnet-1/addrbook.json"

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0usei\"/" $HOME/.sei/config/app.toml

# set peers and seeds
SEEDS=""
PEERS="b7972b95366cb451f4e3004b6cc3a62f656d81e4@195.2.70.182:26656,a36ee0a2aa73e32910300d5ed2b6e2c0b76861aa@144.91.92.129:26656,7c44dd10010a67f2874314e23a5885c0a067e2e1@62.113.117.51:26656,7f192ef8b05ece5acfd21fcbf4e1288d91265243@195.3.221.48:27656,6840ba2f975da5d1ff02573d7bc9ddfdd7134965@95.216.75.106:11656,9ed9f8d2e3a7f442c234f78d79c2c0e9916ed315@144.76.91.26:26656,352ddd90bbfc7e4f1a98504cbee293108b99673c@85.14.247.139:26656,16b29852507b09f8264f54b8b1e6aa2a0f263a5d@65.108.222.181:26656,724b2377b8f0de7533b71fdb3413d31d16a6aed7@213.136.70.209:26656,bbf3fb6602fc77cda647444cd198d0514acb3623@164.68.120.106:26656,230ebb6472866cf5254c88433f3f4849ecdfd38b@168.119.181.213:26656,c989ecf4521ad739b21179e949d88e3f6fb9233f@176.57.150.149:26641,3de20b80b0230642cb3415a18ba22642e5456523@65.108.138.183:8095,6a78a77c7427c5e4377f0055be67077ee769021a@147.182.158.179:26656,361423bbea64f125d500024dce989b4fe8bc2a52@185.239.209.209:26656,2ed66e6f4d146860085d00d00d748be5ca44809d@46.101.187.13:26656,aff15f34d1e7959619638b338a5fa792be14c415@5.189.145.154:26656,e8841d62fa0fffad13e0578b438a7fe020bc3588@65.108.75.148:26656,1088d4a40eefe813814025ba81a45be21bc9faa0@167.86.72.114:26656,0f8c2f0a4fcd5ed0fca69979dcbbd59e3de64eae@167.235.253.41:26656,688f78994e63665ecd426571d0d56c8e5310d81f@89.163.223.85:26656,5023d370719e0d6e5da0ac27ad89c0c5646584df@167.86.117.19:26656,85917f092c13a8d3d58d136dd72888d5a06fc332@66.94.101.212:26656,b1f397bee3b918f9bbbe23614c7f285f2596a1e1@135.181.136.33:16656,b19bc0551fdc538b85577f6785eb52f76e0ba745@195.2.84.133:26656,6a876e2c9f78a6b086e30f9bcdbdb3b964e50a0f@65.21.132.27:44656,c2a17094321b208ecef4057877b2df11aff0b672@161.97.181.63:26656,dbe05528e8fd087306d05a149462ea22082abb8c@167.235.228.221:26656,75a86059c4727c89db8cb6d75dcf6ee7a11ff665@109.205.180.116:26656,03444777ba8d4ecb45cb0aecb5dde60cb8600da0@65.109.1.107:26656,3590457f1396f2a9a26537eddcaea50bec69342b@65.108.193.210:7095,5655dce3b5802231780755b535555cf960d5d2f9@95.217.118.100:30656,d62154f44941a740ef29cd27f031fed3fd63ff42@168.119.183.189:26656,81a00b254ebdd07f207d3dd2c989ef9efcf9c04c@165.232.128.14:26656,49e9d66477cd5df48ceb884b6870cccfc5fa96c5@47.156.153.124:56656,dc882e58c0c51763a12423dfcac5815ef092bc29@65.108.202.114:26656,23b194ac659ed04bd1fd7433ef025195dc6ce8c2@194.163.179.176:36656,941d775a2f6891db842db4f6142d25957364ccd5@195.201.224.0:26656,7c961e45dbd97c6ffa4869002e8381e1a7617c7e@66.94.117.205:26656,84838a89b697a74475d3e1d015b3b3176ec327e2@185.252.234.103:26656,f9b6f0e2ab372942a4a292a40f26799e219a2cb2@65.108.208.175:26656,b6f64367a7049c6333b0d5b9725bf98881b4288b@178.128.225.238:26656,80db075c4cd4bc8a0572680efdd7f3f62c70bc47@185.215.165.213:26656,220a28ca16eb52b37ef4f7b569e712d895e38ceb@65.21.89.42:22656,b7c64f6d33f97ed357414e83fb73ff1c738d85e4@185.144.99.65:26656,fee894a7b11b76194093fea75a12fd69e493eb54@167.235.228.147:26651,b4bd73ff6bab715ca1d6bda93f3c5ff126390ff5@185.211.6.53:26656,2a1f004695968cb4c620abb8e2d0cc8590afd727@194.163.136.65:26656,5d99b92df276ccbb609cc16261d2cc7da0a003a9@45.77.45.139:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.sei/config/config.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.sei-chain/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.sei/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.sei/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.sei/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.sei/config/app.toml

sleep 1

#Change port 37
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:36378\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:36377\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6371\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:36376\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":36370\"%" $HOME/.sei/config/config.toml
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9370\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9371\"%" $HOME/.sei/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:36377\"%" $HOME/.sei/config/client.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:36376\"/" $HOME/.sei/config/config.toml

sleep 1 

SNAP_RPC="https://sei-testnet-rpc.polkachu.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.sei/config/config.toml

# reset
seid unsafe-reset-all

echo -e "\e[1m\e[32m4. Servisler baslatiliyor... \e[0m" && sleep 1
# create service
tee $HOME/seid.service > /dev/null <<EOF
[Unit]
Description=seid
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which seid) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/seid.service /etc/systemd/system/

# start service
sudo systemctl daemon-reload
sudo systemctl enable seid
sudo systemctl restart seid

echo '=============== KURULUM BASARIYLA TAMAMLANDI ==================='
echo -e 'Loglari kontrol et: \e[1m\e[32mjournalctl -ujournalctl -u seid -f -o cat\e[0m'
echo -e 'Senkronizasyon durumu kontrol et: \e[1m\e[32mcurl -s localhost:26657/status | jq .result.sync_info\e[0m'
