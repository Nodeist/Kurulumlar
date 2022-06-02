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
echo -e "\e[1m\e[32mNode isminizi yazin\e[0m"
if [ ! $NODENAME ]; then
	read -p "Node ismi yazin: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
echo -e "\e[1m\e[32mCüzdan Adresinizi yazin from Polkadot.js wallet\e[0m"
if [ ! $WALLET_ADDRESS ]; then
	read -p "Cüzdan Adresinizi yazin: " WALLET_ADDRESS
	echo 'export WALLET_ADDRESS='$WALLET_ADDRESS >> $HOME/.bash_profile
fi
echo -e "\e[1m\e[32mPLOT boyutu yazın gigabytes veya terabytes, ornek: 100G veya 2T (fakat en az 10G yazin)\e[0m"
if [ ! $PLOT_SIZE ]; then
	read -p "PLOT boyutu yazın: " PLOT_SIZE
	echo 'export PLOT_SIZE='$PLOT_SIZE >> $HOME/.bash_profile
fi
source ~/.bash_profile

echo '================================================='
echo -e "Node isminiz: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Cüzdan adresiniz: \e[1m\e[32m$WALLET_ADDRESS\e[0m"
echo -e "PLOT harddisk boyutunuz: \e[1m\e[32m$PLOT_SIZE\e[0m"
echo -e '================================================='
sleep 3

echo -e "\e[1m\e[32m1. Paketler güncelleniyor... \e[0m" && sleep 1
# update packages
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Gereklilikler yükleniyor... \e[0m" && sleep 1
# update dependencies
sudo apt install curl jq -y

# update executables
cd $HOME
rm -rf subspace-*
APP_VERSION=$(curl -s https://api.github.com/repos/subspace/subspace/releases/latest | jq -r ".tag_name")
wget -O subspace-node https://github.com/subspace/subspace/releases/download/${APP_VERSION}/subspace-node-ubuntu-x86_64-${APP_VERSION}
wget -O subspace-farmer https://github.com/subspace/subspace/releases/download/${APP_VERSION}/subspace-farmer-ubuntu-x86_64-${APP_VERSION}
chmod +x subspace-*
mv subspace-* /usr/local/bin/

echo -e "\e[1m\e[32m4. Servisler başlatılıyor... \e[0m" && sleep 1
# create subspace-node service 
tee $HOME/subspaced.service > /dev/null <<EOF
[Unit]
Description=Subspace Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which subspace-node) --chain gemini-1 --execution wasm --pruning 1024 --keep-blocks 1024 --validator --name $NODENAME
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# create subspaced-farmer service 
tee $HOME/subspaced-farmer.service > /dev/null <<EOF
[Unit]
Description=Subspaced Farm
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which subspace-farmer) farm --reward-address $WALLET_ADDRESS --plot-size $PLOT_SIZE
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

mv $HOME/subspaced* /etc/systemd/system/
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable subspaced subspaced-farmer
sudo systemctl restart subspaced
sleep 30
sudo systemctl restart subspaced-farmer
sleep 5

echo "==================================================="
echo -e '\n\e[42mCNode durumu kontrol\e[0m\n' && sleep 1
if [[ `service subspaced status | grep active` =~ "running" ]]; then
  echo -e "Node'unuz başarıyla yüklendi \e[32mve çalışıyor\e[39m!"
  echo -e "Node durumunu kontrol et: \e[7mservice subspaced status\e[0m"
else
  echo -e "Node'unuz \e[31mhatalı yüklendi lütfen rekrar deneyin."
fi
sleep 2
echo "==================================================="
echo -e '\n\e[42mFarmer durumu\e[0m\n' && sleep 1
if [[ `service subspaced-farmer status | grep active` =~ "running" ]]; then
  echo -e "Farmer başarıyla yüklendi \e[32mve çalışıyor\e[39m!"
  echo -e "Farmer durumunu kontrol et:\e[7mservice subspaced-farmer status\e[0m"
else
  echo -e "Farmer \e[31mwas hatalı yüklendi lüttfen tekrar deneyin.."
fi
