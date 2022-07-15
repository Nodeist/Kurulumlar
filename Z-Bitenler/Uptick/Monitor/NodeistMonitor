#!/bin/bash
echo "=================================================="
echo "   _  ______  ___  __________________";
echo "  / |/ / __ \/ _ \/ __/  _/ __/_  __/";
echo " /    / /_/ / // / _/_/ /_\ \  / /   ";
echo "/_/|_/\____/____/___/___/___/ /_/    ";
echo -e "\e[0m"
echo "==================================================" 

sleep 2

echo -e "\e[1m\e[32m1. GUNCELLEMELER YUKLENIYOR... \e[0m" && sleep 1
sudo apt-get update

echo "=================================================="

echo -e "\e[1m\e[32m2. GEREKLI PAKETLER INDIRILIYOR... \e[0m" && sleep 1
sudo apt install jq -y
sudo apt install python3-pip -y
sudo pip install yq

echo "=================================================="

echo -e "\e[1m\e[32m3. DOCKER KONTROL EDILIYOR... \e[0m" && sleep 1

if ! command -v docker &> /dev/null
then
    echo -e "\e[1m\e[32m3.1 DOCKER YUKLENIYOR... \e[0m" && sleep 1
    sudo apt-get install ca-certificates curl gnupg lsb-release wget -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
fi

echo "=================================================="

echo -e "\e[1m\e[32m4. DOCKER COMPOSE KONTROL EDILIYOR ... \e[0m" && sleep 1

docker compose version
if [ $? -ne 0 ]
then
    echo -e "\e[1m\e[32m4.1 DOCKER KOMPOSE YUKLENIYOR... \e[0m" && sleep 1
    mkdir -p ~/.docker/cli-plugins/
    curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
    chmod +x ~/.docker/cli-plugins/docker-compose
    sudo chown $USER /var/run/docker.sock
fi

echo "=================================================="

echo -e "\e[1m\e[32m5. NODEISTOR REPOSU INDIRILIYOR... \e[0m" && sleep 1

rm -rf cosmos_node_monitoring
git clone https://github.com/Nodeist/Nodeistor.git

chmod +x $HOME/Nodeistor/ag_ekle.sh
