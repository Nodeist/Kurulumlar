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
echo "export CHAIN_ID=sei-testnet-3" >> $HOME/.bash_profile
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

sleep 1

# install go
ver="1.18.1" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version

sleep 1

echo -e "\e[1m\e[32m3. kutuphaneler indirilip yukleniyor... \e[0m" && sleep 1
# download binary
cd $HOME
git clone --depth 1 --branch 1.0.4beta https://github.com/sei-protocol/sei-chain.git
cd sei-chain && make install
go build -o build/seid ./cmd/seid
chmod +x ./build/seid && sudo mv ./build/seid /usr/local/bin/seid

sleep 1

mv $HOME/go/bin/seid /usr/local/bin/
mv $HOME/.sei-chain $HOME/.sei
mv $HOME/sei-chain $HOME/sei


sleep 1


# config
seid config chain-id $CHAIN_ID
seid config keyring-backend test

# init
seid init $NODENAME --chain-id $CHAIN_ID

# add wallet
seid keys add $WALLET --recover

# fund your wallet
WALLET_ADDRESS=$(seid keys show $WALLET -a)
seid add-genesis-account $WALLET_ADDRESS 100000000usei

# generate gentx
seid gentx $WALLET 100000000usei \
--commission-max-change-rate=0.01 \
--commission-max-rate=0.20 \
--commission-rate=0.05 \
--pubkey=$(seid tendermint show-validator) \
--chain-id $CHAIN_ID \
--moniker $NODENAME

sleep 2

gentx=$(readlink -f $HOME/.sei/config/gentx/*)

echo -e "Gentx Dosyanız Burada: \e[1m\e[32m$gentx\e[0m"
echo -e "Gentx Dosyanızın İçeriği\n\n\e[1m\e[32m$(cat $gentx)\n\e[0m"
echo -e "Yedeklemeniz Gerekenler:"
echo -e "	Klasörü komple: \e[1m\e[32m$HOME/.sei/config/\e[0m"
