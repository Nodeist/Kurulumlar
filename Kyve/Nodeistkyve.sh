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
echo "export CHAIN_ID=korellia" >> $HOME/.bash_profile
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
mkdir kyvebinary && cd kyvebinary
wget -q https://github.com/KYVENetwork/chain/releases/download/v0.3.0/chain_linux_amd64.tar.gz
tar -xzf chain_linux_amd64.tar.gz
sudo mv chaind kyved
sudo chmod +x kyved
sudo mv $HOME/kyvebinary/kyved /usr/bin/
kyved config chain-id kyve-beta
cd $HOME && rm -rf kyvebinary

#cosmovisor
wget https://github.com/KYVENetwork/chain/releases/download/v0.0.1/cosmovisor_linux_amd64 
mv cosmovisor_linux_amd64 cosmovisor
chmod +x cosmovisor
cp cosmovisor /usr/bin

# config
kyved config chain-id $CHAIN_ID
kyved config keyring-backend file

# init
kyved init $NODENAME --chain-id $CHAIN_ID

# download addrbook and genesis
wget -qO $HOME/.kyve/config/genesis.json "https://github.com/KYVENetwork/chain/releases/download/v0.0.1/genesis.json"
wget -qO $HOME/.kyve/config/addrbook.json "https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Kyve/addrbook.json"

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ukyve\"/" $HOME/.kyve/config/app.toml

# set peers and seeds
SEEDS="e56574f922ff41c68b80700266dfc9e01ecae383@18.156.198.41:26656"
PEERS="f0916dd2eb8aeb3170318ce9f126d4b65db20ebe@159.69.154.196:26656,e1a13fab199f489b41c0a0f705bf06cf46dc4d3f@165.227.202.155:26656,051d5068b0408069722aadae95e5d2bb2a470191@154.12.235.154:36656,6fac99ff534a905f3339b400547d2c731ad3d6f7@45.10.42.125:26656,70556c82352b9919fb6f339b9da0ebc587e9148c@18.184.153.246:26656,f6b24090097793d3f898bc32da47eb1f0a774b8e@185.144.99.236:26656,a3fd6919ec3c5eb0fcd26dd9758ad8183bb7a93d@51.15.104.178:26656,52880e07804a612a3611025b4283e845084c2b26@38.242.241.164:26256,48cc1c0a22734dacdb737182d9bef61c28da2f87@182.147.243.129:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.kyve/config/config.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.kyve/config/config.toml

# add external (if dont use sentry), port is default
# external_address=$(wget -qO- eth0.me)
# sed -i -e "s/^external_address = \"\"/external_address = \"$external_address:26656\"/" $HOME/.kyve/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.kyve/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.kyve/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.kyve/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.kyve/config/app.toml

# reset
kyved tendermint unsafe-reset-all

echo -e "\e[1m\e[32m4. Servisler baslatiliyor... \e[0m" && sleep 1
# create service
tee $HOME/kyved.service > /dev/null <<EOF
[Unit]
Description=kyved
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which kyved) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/kyved.service /etc/systemd/system/

# start service
sudo systemctl daemon-reload
sudo systemctl enable kyved
sudo systemctl restart kyved

echo '=============== KURULUM BASARIYLA TAMAMLANDI ==================='
echo -e 'Loglari kontrol et: \e[1m\e[32mjournalctl -ujournalctl -u kyved -f -o cat\e[0m'
echo -e 'Senkronizasyon durumu kontrol et: \e[1m\e[32mcurl -s localhost:26657/status | jq .result.sync_info\e[0m'
