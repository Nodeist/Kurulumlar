&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>



# Obol Athena testnet preparation guide.

![Obol by Nodeist](https://img3.teletype.in/files/2f/d8/2fd8b17f-23dd-4def-937b-c50b4f11c7f8.jpeg)

Obol Network is a distributed protocol and ecosystem for Ethereum POS with the mission to eliminate single technical points of failure in Ethereum through distributed validator technology (DVT).

As a layer, Obol is focused on enabling the main chain to scale by providing unauthorized access to distributed validators. The staking infrastructure is entering a phase in the evolution of its protocol to include minimally reliable staking networks that can be connected at any scale.

On 07/08/2022 the team announced the launch of the first public testnet called Athena. You can find all the details here https://blog.obol.tech/the-athena-testnet/.

## Preparation
For participation, we need to give the enr key to the form, for this we will do the following.
and then we will fill out the form. https://obol.typeform.com/AthenaTestnet

### Update packages
```
sudo apt update && sudo apt upgrade -y
```

### Install required packages
```
sudo apt install curl ncdu htop git wget -y
```

### Install Docker
```
cd $HOME

apt update && apt purge docker docker-engine docker.io containerd docker-compose -y

rm /usr/bin/docker-compose /usr/local/bin/docker-compose

curl -fsSL https://get.docker.com -o get-docker.sh

sh get-docker.sh

curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

### Library installation
```
git clone https://github.com/ObolNetwork/charon-distributed-validator-node.git

chmod o+w charon-distributed-validator-node

cd charon-distributed-validator-node

docker run --rm -v "$(pwd):/opt/charon" ghcr.io/obolnetwork/charon:v0.8.1 create enr
```

* If you have done the operations correctly, at the end of all the operations, you will be given an `enr-` key, copy and backup that key and paste it into the form.
also backup the `.charon/charon-enr-private-key` file.

That's all for now.
