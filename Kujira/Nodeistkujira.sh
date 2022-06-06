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
PEERS=e9dd010ad140eb98a8b8b541a7a3777eb0ef9628@65.21.155.148:26656,1f441ca5b137dedef7e8035706691be3c1b220f4@135.181.209.51:26866,bee48b090b97ef1a8adca4adecf897e5d29c6909@3.39.245.44:26656,921693f4de5cb20cfeb361f9764bc90dd7606127@164.92.154.80:36346,1e6a1c254a5a01c93f41af7539cbbc4061b686e8@157.90.183.167:26656,100555857d21385f21f55f627e2050064b4eaea8@164.92.201.23:26656,ce425190e69ef737094cf294266236c28df6cfff@143.110.152.205:26656,092617bcf66bc91118225b7794fd0acf4202d92a@65.108.102.123:26656,769dbbfe4b1ec128d9c10e48af77aabd64713f98@78.47.24.137:26656,2dc5a88da1c654e656ed9e6c0a1172f76a5c68a5@78.47.214.201:26656,a6b606f088b409f7ee321d0737207bedf685906d@149.102.159.152:26656,7a7a0e149f7dff9d41664ce5e0b6d0098fccbdc1@65.108.75.237:26656,835f78b1bc9a3e7b4a116d8876d8760da8518aef@149.102.145.82:26656,66ab5592bb1b5f9064ecb51360fe6584ae931bf8@65.108.0.234:4656,c8e8269ea91affb567ae2e21f8b0b18ada6d6f6b@209.145.59.96:26656,4e65a6e5952b96ab22a82a94301ae216a73cfc85@135.181.98.169:36656,71232e64790482cd46a0b4446b647435f48aad39@149.102.159.237:26656,874097303aedd950c7d51160bc64e610baf46adc@65.21.189.66:26656,cfe536c1d25c2995df53b255f6d4fac0eeaa23bf@143.244.184.71:26656,24bfd7ebcecf276e9d21b9391c731fd2e8b15a64@188.166.94.181:26656,cf7b696ad9f62c975d87a0f2ebe11aea82cc272f@65.108.98.218:19095,d99bfd2844a8d202e4527462dae5bd02a004d2db@128.199.139.93:26656,cf0c1fb5ca00f3a8576e0aacdcdc1a35f38a9e03@138.201.16.240:14095,02a17766abb65427eaa8810ac323a0208d18e6c4@5.252.22.209:26656,c060c23319ad5953511f5a842f2cce4132bc286f@49.12.200.119:26656,f67973148d8a87944b6ac3def1b02cd33328d594@154.53.51.217:46656,b015fdabb62f649ac0e5f52b8051b8248c1a8482@137.184.126.130:26656,43815d1f4c2b6b421bd861ad6704dbb110a74db0@178.79.191.211:26656,579821e9ea54b2d59065ec39531379d563c68e30@79.116.135.91:26656,3e147439968a0673fc5f34809f6316cf04b5f6d7@185.211.6.115:26656,c5841c44e2e283c2bb3eaf68509d9b4a4076a687@185.163.64.143:27656,f8d6fd74311ef2c715517fe5c23149ce62d7691f@188.166.188.139:26656,e339f3edf2a438ff99c32dc8f2a780425f0fb109@89.163.208.188:26656,e92fc7c63efcf6dcaa63586a8af5dc89ce4ae879@37.99.41.222:26656,10383be2db517113c2e9bfd440ec1981523dd007@82.65.223.126:46656,4a9c09a040acd251a09b3710560fe50cf9b81fa6@157.90.81.24:2210,20352634b2f4b80a01eef4b850e5aa689aa5a034@206.189.111.65:26656,ae4234e1151243fff7b00b759c4afb200b442389@172.105.101.234:26656,14899ef39849ff05756cdd3f94b9ddcb1d469173@178.62.49.177:26656,32987bd6d2c8e98aef650e08e8e270e07578f888@195.201.164.223:26656,f0e098e90f4e3791c3409ed11b9e0aab3388530b@167.235.240.46:26656,a88e77760761df731f3497a32858163392ad4a86@146.190.237.165:26656,7c24e574fa2e7c4704b1db0023ab935a15c9bac4@20.29.120.97:26656
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
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:36346\"/" $HOME/.kujir/config/config.toml

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
