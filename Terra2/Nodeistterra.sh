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
echo "export CHAIN_ID=pisco-1" >> $HOME/.bash_profile
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
git clone https://github.com/terra-money/core
cd core
git checkout v2.0.0-rc.0
make install


# config
terrad config chain-id $CHAIN_ID
terrad config keyring-backend file

# init
terrad init $NODENAME --chain-id $CHAIN_ID

# download addrbook and genesis
wget -qO $HOME/.terra/config/genesis.json "https://raw.githubusercontent.com/terra-money/testnet/main/pisco-1/genesis.json"

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.15uluna\"/" $HOME/.terra/config/app.toml

# set peers and seeds
SEEDS="c08d5b3d253bea18b24593a894a0aa6e168079d3@34.232.34.124:26656"
PEERS="a4a8fbd7d26242263250a1d3ecb39f113832534b@52.73.183.21:26656,3a4c8f4d75781f39b558c3889157acfaa144a793@50.19.18.17:26656,1eb3ebfdfe7748b958bcbb9d94fd4f08d699936f@135.181.59.162:17656,d55bea6c5d72d3f306584f4d0937c572dcbb0b95@195.14.6.129:26656,8c83190bc0415af033d480a57d7ff1e199d27676@3.15.238.87:26656,38bfa5761ca97ebe17d20417918dfdbf6fc4767f@65.108.78.29:26656,cb2a7f5c58d87a5d8ed823a9a91d7d127937d653@185.188.42.45:26656,3da66974005f1fc284e5a9aef869e45ee51ba0c0@168.119.249.128:36676,f3df555d809e812d46886b2e22ce492d2dd5e4e4@47.156.153.124:38656,3c53daf0929db5cbdd8ccf6bf629b7631d4a7ae4@88.198.69.199:26857,18418353d979ea112a9a400f969a29d68f664ae9@89.149.218.45:26656,dc2ea6b406a0b8fb8b8f2b1249c25bdbbc8af311@149.102.152.143:46656,d4ca20169b1b5f4cfc374e6733b5ae7423aa9c0f@18.211.127.115:26656,b80a708068b2e94782c0537d54c2b574fe4d7abd@35.234.245.97:26676,6e03f70d2c23556ec19eb9684cc211f167ec4cd4@3.38.246.108:26656,6aac6250e26fed746db0fcc6acf2d5e7ee0442c3@52.196.107.134:26656,37a80dd85e57fe5fa7f448e0653eebff8cf73178@198.244.228.16:26312,b7299905ce49a95e5c25148568044e902479a44b@65.108.126.189:26656,0262654078ca911327ce492a9f997d16d283e1d2@65.21.75.122:26656,3a4c8f4d75781f39b558c3889157acfaa144a793@50.19.18.17:26656,5819ee584b7c72607028e0f4b7728f6980c24b42@136.243.40.105:16095,c5728bfa1ebe6625bfe492d311c73b7c78fef1c0@195.201.149.14:26656,bc35dcbe37d3d060a48ceefa3c984fe97c56605d@195.201.61.185:26656,89aa2169df99b0b7065a781b4694a425e08ea455@3.238.87.247:26656,32b29617ae46228005fec1682f27876e744b5c61@34.139.226.165:56656,5a4cfb8fe5f59af5e6eaf9f980ece79864663e7c@142.132.151.99:15613,2272851b40f70372f8dc64853a2455a428c5f716@13.251.16.47:26656,6a009d0289cf9c65168edd5f192012e8ec9f085d@3.35.78.32:26656,a153dfbe5e4d59b7e7e2dc966839689aac51c8ef@35.158.101.18:26656,d35167d9df89e3366c7d72b8e2faf4e61e5020d8@35.157.163.68:26656,651aefa892c279991b1df0cf4dd57282e95f345a@213.246.39.167:26656,0b22928a9afcfe0a58dbdcf4723db437abf0693b@95.217.42.125:26656,7ab8b3bc2adbb742e2e7164ab4b2e9bb8e88957d@66.42.86.197:26656,f019079b8f92aac23b53e0d46feae2c4b6251b48@162.55.123.196:26656,4b33f43c35066fd4893dd6aede51a3b994d9110f@107.21.250.114:26656,e4da73a7fd6b8ce9f5e55b343794c3007389f418@18.116.74.224:26656,f0e374ed1730692344eac9e4bdc840bc724a67ef@13.215.109.254:26656,13138fbfc808f5c5de3832d5132f71923f174045@88.99.146.56:26656,e6af3be4e2446205fbb83ded4e6797572d746387@3.99.20.122:26656,d5bb589f7a5a8284b7ecc7915740ffa9e6398477@188.166.221.255:26656,e5ca58f6d70681ca6579d3f8eec6a27c518cad8c@34.72.138.134:26656,211992f72d175c4537355bfdb464841ed01d50a5@85.118.207.82:26656,ba8c04500bcbf0c53fcab8ece14571bd330a6bf8@185.252.220.89:25002,213eb45b411c99c540a8f630fa525b124929a06f@65.108.140.215:46656,ebc4390b5adde0d792030026616845c9379f878c@121.78.241.72:16656,622353758d8158dc9781e24e6b18732be2b52be9@65.21.126.187:26656,8800c20c0f23b9eb86d70303785280501ad4e69d@168.119.150.243:26656,c08d5b3d253bea18b24593a894a0aa6e168079d3@34.232.34.124:26656,18453521cdad99e206aec81abc8e1d86cebc6231@172.241.26.39:26656,7b164cd63d1ba0dec4b4951c0342daa795da7470@34.239.232.196:26656,5c7b4e640a381060788e71868530501870565aa8@95.217.197.100:27656,64cd4872abb00b67998c7cd4e4358f35219e2af1@54.169.215.201:26656,4265c50bfaaa5b06f4ebdc0ce693fc8ef1adb138@142.93.199.189:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.terra/config/config.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.terra/config/config.toml

# add external (if dont use sentry), port is default
# external_address=$(wget -qO- eth0.me)
# sed -i -e "s/^external_address = \"\"/external_address = \"$external_address:26656\"/" $HOME/.terra/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.terra/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.terra/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.terra/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.terra/config/app.toml

# reset
terrad tendermint unsafe-reset-all

echo -e "\e[1m\e[32m4. Servisler baslatiliyor... \e[0m" && sleep 1
# create service
tee $HOME/terrad.service > /dev/null <<EOF
[Unit]
Description=terrad
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which terrad) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/terrad.service /etc/systemd/system/

# start service
sudo systemctl daemon-reload
sudo systemctl enable terrad
sudo systemctl restart terrad

echo '=============== KURULUM BASARIYLA TAMAMLANDI ==================='
echo -e 'Loglari kontrol et: \e[1m\e[32mjournalctl -ujournalctl -u terrad -f -o cat\e[0m'
echo -e 'Senkronizasyon durumu kontrol et: \e[1m\e[32mcurl -s localhost:26657/status | jq .result.sync_info\e[0m'
