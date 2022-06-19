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


sudo useradd -s /sbin/nologin geth
sudo rm -rf /home/geth
sudo mkdir -p /home/geth
sudo mkdir -p /home/geth/.ethereum/geth/
sudo chown -R geth:geth /home/geth
sudo chmod -R 700 /home/geth
if [ ! $PASS ]; then
read -p "Enter a new password for your account: " PASS
echo $PASS > /home/geth/.ethereum/password.txt
fi

echo -e "\e[1m\e[32m1. Paketler güncelleniyor... \e[0m" && sleep 1

# packages
apt update && apt install unzip sudo -y < "/dev/null"

# install geth
cd $HOME
wget -O geth-v1.0.0-alpha3-linux-amd64.zip https://github.com/oasysgames/oasys-validator/releases/download/v1.0.0-alpha3/geth-v1.0.0-alpha3-linux-amd64.zip 
unzip geth-v1.0.0-alpha3-linux-amd64.zip
sudo mv geth /usr/local/bin/geth


# download binary
wget -O genesis.zip https://github.com/oasysgames/oasys-validator/releases/download/v1.0.0-alpha3/genesis.zip
unzip genesis.zip
mv genesis/testnet.json /home/geth/genesis.json
sudo -u geth geth init /home/geth/genesis.json
echo '[ "enode://4a85df39ec500acd31d4b9feeea1d024afee5e8df4bc29325c2abf2e0a02a34f6ece24aca06cb5027675c167ecf95a9fc23fb7a0f671f84edb07dafe6e729856@35.77.156.6:30303" ]' > /home/geth/.ethereum/geth/static-nodes.json

sudo -u geth geth account new --password "/home/geth/.ethereum/password.txt" >/home/geth/.ethereum/wallet.txt
OASYS_ADDRESS=$(grep -a "Public address of the key: " /home/geth/.ethereum/wallet.txt | sed -r 's/Public address of the key:   //')

# export NETWORK_ID=248
#export NETWORK_ID=9372
#export OASYS_ADDRESS="0xc3f3e1Fc51Fa86e4125712B4E838d8E910982503"


# set seeds
sed -i.bak "s/db-path:.*/db-path: \"\/var\/sui\/db\"/ ; s/genesis-file-location:.*/genesis-file-location: \"\/var\/sui\/genesis.blob\"/" /var/sui/fullnode.yaml

#Run
cargo build --release -p sui-node
mv ~/sui/target/release/sui-node /usr/local/bin/

echo -e "\e[1m\e[32m4. Servisler baslatiliyor... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/suid.service > /dev/null <<EOF
[Unit]
Description=Oasys Node
After=network.target

[Service]
User=geth
Type=simple
ExecStart=$(which geth) \
 --networkid 9372 \
 --syncmode full --gcmode archive \
 --mine --miner.gaslimit 30000000 \
 --allow-insecure-unlock \
 --unlock $OASYS_ADDRESS \
 --password /home/geth/.ethereum/password.txt \
 --http --http.addr 0.0.0.0 --http.port 8545 \
 --http.vhosts '*' --http.corsdomain '*' \
 --http.api net,eth,web3 \
 --snapshot=false
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target

sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF

# start service
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable oasysd
sudo systemctl restart oasysd

echo "==================================================="
echo -e '\n\e[42mOasysd Durumunu Kontrol Et\e[0m\n' && sleep 1
if [[ `service oasysd status | grep active` =~ "running" ]]; then
  echo -e "Oasys Node \e[32mbaşarıyla yüklendi ve çalışıyor!\e[39m!"
  echo -e "Node durumunu kontrol et:\e[7mservice oasysd status\e[0m"
else
  echo -e "Oasys Node Kurulumu \e[31mBAŞARISIZ\e[39m, Lütfen temiz sunucuya tekrar kurun."
fi
