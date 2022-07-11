
echo -e "\e[1m\e[32m1. Paketler güncelleniyor... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Bagliliklar yukleniyor... \e[0m" && sleep 1
# packages
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

#Docker
cd  $HOME 
apt update &&  apt purge docker docker-engine docker.io containerd docker-compose -y
 rm /usr/bin/docker-compose /usr/local/bin/docker-compose
 curl -fsSL https://get.docker .com -o get-docker.sh
 sh get-docker.sh
 
 sleep 1
 
 
curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
 chmod +x /usr/local/ bin/docker-compose
 ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
 
 sleep 1
 
 echo -e "\e[1m\e[32m3. kutuphaneler indirilip yukleniyor... \e[0m" && sleep 1
# download binary
git clone https://github.com/ObolNetwork/charon-distributed-validator-node.git
chmod o+w charon-distributed-validator-node
cd charon-distributed-validator-node
docker run --rm -v " $( pwd ) :/opt/charon" ghcr.io/obolnetwork/charon:v0.8.1 create enr



echo '=============== KURULUM TAMAMLANDI ==================='
echo '=============== FORMA GIRECEGINIZ ENR ANAHTARINI KAYDEDIN ==================='
