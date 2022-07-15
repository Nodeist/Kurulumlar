#!/bin/bash
echo "=================================================="
echo "   _  ______  ___  __________________";
echo "  / |/ / __ \/ _ \/ __/  _/ __/_  __/";
echo " /    / /_/ / // / _/_/ /_\ \  / /   ";
echo "/_/|_/\____/____/___/___/___/ /_/    ";
echo -e "\e[0m"
echo "=================================================="  

sleep 3

# server update and port settings
sudo apt-get update -y
sudo apt install ufw -y
sudo ufw enable
sudo ufw allow 22
sudo ufw allow ssh
sudo ufw allow 31244/tcp
sudo ufw allow 31245/tcp
sudo ufw status

echo "---------------------"
echo "--------------------- Portlar ayarlandı düğüm yükleniyor..."
echo "--------------------- Node loading please wait"
echo "---------------------"
sleep 3

# required libraries
sudo apt install pkg-config curl git build-essential libssl-dev libclang-dev -y
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustc --version
rustup toolchain install nightly
rustup default nightly
rustc --version
git clone --branch testnet https://github.com/massalabs/massa.git

# rustc explain fixed
sudo apt install make clang pkg-config libssl-dev -y
rustup default nightly 
rustup update

# settings file
echo "---------------------"
echo "Düğüm başarıyla yüklendi..."
echo "Node installed successfully..."
echo "---------------------"
sleep 2

echo " Sunucu ip adresini giriniz (Enter your server's ip address) :"
read ipadr
echo -e "[network]\nroutable_ip = '$ipadr'" >> massa/massa-node/config/config.toml
#echo -e '[network]\nroutable_ip = "$ipadr"' >> massa/massa-node/config/config.toml

# reboot to take effect
echo "Restarting the server for the settings to take effect."
echo "Routable dosyası oluşturuldu, ayarların geçerli olabilmesi için sunucu yeniden başlatılıyor..."
sleep 2
reboot
