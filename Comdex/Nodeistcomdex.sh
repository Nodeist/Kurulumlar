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
echo "export CHAIN_ID=comets-test" >> $HOME/.bash_profile
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
git clone https://github.com/comdex-official/comdex.git
cd comdex
git fetch --tags
git checkout v1.0.0
make all

# config
comdex config chain-id $CHAIN_ID
comdex config keyring-backend file

# init
comdex init $NODENAME --chain-id $CHAIN_ID

# download addrbook and genesis
wget -qO $HOME/.comdex/config/genesis.json "https://raw.githubusercontent.com/comdex-official/networks/main/testnet/comets-test/genesis_final.json"

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.2ucmdx\"/" $HOME/.comdex/config/app.toml

# set peers and seeds
PEERS="652d29528dd6b987b56631ced09be0775adced52@34.131.43.186:26656,a26081c37215d11f2513f9a93e0925a3e3d3f110@44.200.185.103:26656,e290237daeb22cce48eb25a5b468f80d3dc547e6@65.108.103.236:22656,5f9fbda6543fdf0f0240ca6099c9d01e58ce6a07@141.94.170.26:24456,e3da7120edfc0f7e50e562153b485753300651df@173.249.40.87:36656,5529cb720b231af7b660ef5280ee5277bc349c48@185.137.122.68:2020,e6542aa3b5b97cc32a723270e0a2092952cf370c@135.181.209.51:26846,9c25a7ab94a315f683c3693e17aec6b2c91c851c@52.77.115.73:26656,3659590cd1466671a49421089e55f1392e1cad0e@15.207.189.210:26656,c299ff4127fa6694067b8620bfbfc5f595d25630@3.237.7.35:26656,8b1ccf5cf3a3ba65ee074f46ea8c6c164d867104@52.201.166.91:26656,5307ce50bd8a6f7bb5a922e3f7109b5f3241c425@13.51.118.56:26656,d165b9ed5609e252c9853098fbec843ed53dc662@65.2.70.193:26656,865a47c33b0115cee680826dacac8b191a630d89@142.132.230.221:26656,0e9d27fc1980738061f69384ed376ca30811310c@135.181.129.86:10256,73c2b5e49bac8cefd7cbb89f75cf7c745c449a19@65.108.66.4:10056,1887b6517973bfa5ae0d89fedbef7215072064fe@94.250.203.3:46656,d7974fca9bc9ce0f30581c9d0d8915c13c2ed04e@138.94.49.246:26656,ee7046106dfb77941596c02c02ef7a6f1dcf9adb@134.122.39.186:26656,bfbb0f1fa252f2a53190859339a5466032363987@65.108.48.106:26656,128b624f9ad8b635c1118b0c6374d033dddfa7cc@141.95.65.26:34656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.comdex/config/config.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.comdex/config/config.toml

# add external (if dont use sentry), port is default
# external_address=$(wget -qO- eth0.me)
# sed -i -e "s/^external_address = \"\"/external_address = \"$external_address:26656\"/" $HOME/.comdex/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.comdex/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.comdex/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.comdex/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.comdex/config/app.toml

sleep 1

#Change port 39
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:36398\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:36397\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6391\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:36396\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":36390\"%" $HOME/.comdex/config/config.toml
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9390\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9391\"%" $HOME/.comdex/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:36397\"%" $HOME/.comdex/config/client.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:36396\"/" $HOME/.comdex/config/config.toml

sleep 1 

# reset
comdex tendermint unsafe-reset-all

echo -e "\e[1m\e[32m4. Servisler baslatiliyor... \e[0m" && sleep 1
# create service
tee $HOME/comdex.service > /dev/null <<EOF
[Unit]
Description=comdex
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which comdex) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/comdex.service /etc/systemd/system/

# start service
sudo systemctl daemon-reload
sudo systemctl enable comdex
sudo systemctl restart comdex

echo '=============== KURULUM BASARIYLA TAMAMLANDI ==================='
echo -e 'Loglari kontrol et: \e[1m\e[32mjournalctl -ujournalctl -u comdex -f -o cat\e[0m'
echo -e 'Senkronizasyon durumu kontrol et: \e[1m\e[32mcurl -s localhost:26657/status | jq .result.sync_info\e[0m'
