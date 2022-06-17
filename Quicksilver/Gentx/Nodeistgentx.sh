
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
	read -p "Node isminizi yazın " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
echo "export WALLET=wallet" >> $HOME/.bash_profile
echo "export CHAIN_ID=killerqueen-1" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Node isminiz: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Cüzdan isminiz: \e[1m\e[32m$WALLET\e[0m"
echo -e "Chain ismi: \e[1m\e[32m$CHAIN_ID\e[0m"
echo -e '================================================='
sleep 2

echo -e "\e[1m\e[32m1. paketler yukleniyor... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. gereklilikler yukleniyor... \e[0m" && sleep 1
# packages
sudo apt install curl build-essential git wget jq make gcc tmux -y

# install go
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

echo -e "\e[1m\e[32m3. kutuphane indiriliyor ve yukleniyor... \e[0m" && sleep 1
# download binary
cd $HOME
git clone https://github.com/ingenuity-build/quicksilver.git --branch v0.3.0
cd quicksilver
make build
chmod +x ./build/quicksilverd && mv ./build/quicksilverd /usr/local/bin/quicksilverd

# config
quicksilverd config chain-id $CHAIN_ID
quicksilverd config keyring-backend test

# init
quicksilverd init $NODENAME --chain-id $CHAIN_ID

# add wallet
quicksilverd keys add $WALLET --recover

# fund your wallet
WALLET_ADDRESS=$(quicksilverd keys show $WALLET -a)
quicksilverd add-genesis-account $WALLET_ADDRESS 100000000uqck

# generate gentx
quicksilverd gentx $WALLET 100000000uqck \
--commission-max-change-rate=0.01 \
--commission-max-rate=0.20 \
--commission-rate=0.05 \
--pubkey=$(quicksilverd tendermint show-validator) \
--chain-id $CHAIN_ID \
--moniker $NODENAME
sleep 2
gentx=$(readlink -f $HOME/.quicksilverd/config/gentx/*)

echo -e "Gentx dosyanızın konumu: \e[1m\e[32m$gentx\e[0m"
echo -e "Bu içeriği google forma yazın:\n\n\e[1m\e[32m$(cat $gentx)\n\e[0m"
echo -e "Yedeklenmesi gerekenler:"
echo -e "	Klasörü komple yedekleyin \e[1m\e[32m$HOME/.quicksilverd/config/\e[0m"
