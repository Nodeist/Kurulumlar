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
echo "export CHAIN_ID=killerqueen-1" >> $HOME/.bash_profile
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
ver="1.18.1" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version


echo -e "\e[1m\e[32m3. kutuphaneler indirilip yukleniyor... \e[0m" && sleep 1
# download binary
cd $HOME
git clone https://github.com/ingenuity-build/quicksilver.git --branch v0.4.2
cd quicksilver
make build
chmod +x ./build/quicksilverd && mv ./build/quicksilverd /usr/local/bin/quicksilverd


# config
quicksilverd config chain-id $CHAIN_ID
quicksilverd config keyring-backend test

# init
quicksilverd init $NODENAME --chain-id $CHAIN_ID

# download genesis
wget -qO $HOME/.quicksilverd/config/genesis.json "https://raw.githubusercontent.com/ingenuity-build/testnets/main/killerqueen/genesis.json"

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uqck\"/" $HOME/.quicksilverd/config/app.toml

# set peers and seeds
SEEDS="dd3460ec11f78b4a7c4336f22a356fe00805ab64@seed.killerqueen-1.quicksilver.zone:26656"
PEERS="4742e1b942acf17c31794cce80d199886d172c4f@135.181.133.37:31656,a57ef5ba1cc5197356707c661e2bf33e51b2847e@154.26.130.167:44656,d1bd9c232bcc31e163082f83642b42d5f382ecbc@43.156.106.22:26656,201721bd252ebf90c46113b5d5ecafbdd428e2f2@43.156.225.194:26656,46d2eb9953403de555369ab5d144c713a6e5b960@144.76.67.53:2390,cdef7359f527cf0c7813a3fa640d412651798c79@65.108.75.32:11656,89064c6c8992d0348a6fa20434e50d33b27713c8@65.108.233.4:26656,3fd5878b299c0061a3965547b5927911e265c741@43.156.106.69:26656,7a91e43cabc2df44beac2ce6b7b5d4bb34c15376@43.156.105.72:26656,167918c83385f9532c9b25f7c9bdec67d053aaea@43.156.106.60:26656,fcfcf2402f106b300ada70fce2ff52603290c43a@104.248.112.44:11656,daa689918642101fbedced891166647c2a575a78@75.119.135.34:26656,b1265b31daa3e0cdd32a38105f7190afdba04109@43.133.184.206:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.quicksilverd/config/config.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.quicksilverd/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.quicksilverd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.quicksilverd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.quicksilverd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.quicksilverd/config/app.toml

sleep 1

#Change port 36
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:36368\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:36367\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6361\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:36366\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":36360\"%" $HOME/.quicksilverd/config/config.toml
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9360\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9361\"%" $HOME/.quicksilverd/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:36367\"%" $HOME/.quicksilverd/config/client.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:36366\"/" $HOME/.quicksilverd/config/config.toml

sleep 1 

# reset
quicksilverd tendermint unsafe-reset-all --home $HOME/.quicksilverd

#Snap
cd $HOME/.quicksilverd
rm -rf data

SNAP_NAME=$(curl -s https://snapshots1-testnet.nodejumper.io/quicksilver-testnet/ | egrep -o ">killerqueen-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots1-testnet.nodejumper.io/quicksilver-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf -



echo -e "\e[1m\e[32m4. Servisler baslatiliyor... \e[0m" && sleep 1
# create service
tee $HOME/quicksilverd.service > /dev/null <<EOF
[Unit]
Description=quicksilverd
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which quicksilverd) start
Restart=always
RestartSec=3
LimitNOFILE=infinity
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/quicksilverd.service /etc/systemd/system/

# start service
sudo systemctl daemon-reload
sudo systemctl enable quicksilverd
sudo systemctl restart quicksilverd

echo '=============== KURULUM BASARIYLA TAMAMLANDI ==================='
echo -e 'Loglari kontrol et: \e[1m\e[32mjournalctl -ujournalctl -u quicksilverd -f -o cat\e[0m'
echo -e 'Senkronizasyon durumu kontrol et: \e[1m\e[32mcurl -s localhost:26657/status | jq .result.sync_info\e[0m'
