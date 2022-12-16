<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/celestia.png">
</p>



# Celestia Node Installation Guide
Feel free to skip this step if you already have Go and Cosmovisor.


## Install Go
We will use Go `v1.19.3` as example here. The code below also cleanly removes any previous Go installation.

```
sudo rm -rvf /usr/local/go/
wget https://golang.org/dl/go1.19.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.3.linux-amd64.tar.gz
rm go1.19.3.linux-amd64.tar.gz
```

### Configure Go
Unless you want to configure in a non-standard way, then set these in the `~/.profile` file.

```
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
```


### Install Cosmovisor
We will use Cosmovisor `v1.0.0` as example here.

```
go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0
```

## Install Node
Install the current version of node binary.

```
git clone https://github.com/celestiaorg/celestia-app.git celestia
cd celestia
git checkout 0.11.0
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
celestia-appd init YOUR_MONIKER --chain-id mocha
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/celestia/genesis.json --inet4-only
mv genesis.json ~/.celestia-app/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=3247475e99137ea3a9158a07d3d898281f8c70e5@135.181.136.124:26656,e8906342e657ace92e1ed8599f0949da8dd75fbd@146.19.24.52:20656,a4a4e43dd641f1b921f76a02154846968024f744@95.111.235.247:26656,1d667e973e0dfcf0f92f7a202c241f5cfa6039cb@188.34.154.35:26656,5f7eeebf3d90344a6efeea95f8f260fe455b8096@46.4.23.42:36656,1afcd97b0bf289700378e18b45dc1f927917bba0@65.109.92.79:11656,1166d64ee61acbaa34cf6d4be99af60725549bb4@35.198.125.182:26656,77fe717fc70370c5b1782c136a5bf7ef1e1e7b5d@167.235.233.34:26656,a217dde054663543e4b68ace5267adbda3119ff9@65.109.92.28:26656,eec289755259106bf29266c401bace003289c6be@35.234.94.146:26656,70ad1e4808ad49f192f3536cf180aa22ca804fc6@34.88.189.48:26656,8084e73b70dbe7fba3602be586de45a516012e6f@144.76.112.238:26656,cc77755c7fed7457c6e33f6e65b0300e8fe9add0@5.161.109.144:26656,6dd7ccf76ee531a102f5f9e24b7cc521c9a01a28@65.109.85.170:37656,0d8b40858dcdf1e4370b2ed66b632bddf13a150d@75.119.143.147:26656,d1ef32ab00da8117731660fc30a2a800b642f6ad@34.141.57.183:26656,45f432d7ea5e4cbb25e945b8cc557df07bf4fcb6@65.109.92.26:26656,5ec7477a55b48984ec778bd1bef87d2ac8cf95eb@138.201.60.238:26656,7ff5fcd0e0db0518258b18bfd8cd5b45436dec2a@65.109.22.167:26656,3ad7f2d36f5e15d902c7aff7a305bea40f03f95c@163.172.111.148:26656,e286b562eddc6fea1b2635f6623430225666fb2f@147.135.144.58:26656,42b331adaa9ece4c455b92f0d26e3382e46d43f0@161.97.180.20:56656,1f243a32a4c741e6838f247350f0aa7655ea264e@173.249.40.87:26656,cb0db7a1fb8897c8eec9b09285e39d1756ed87b7@65.109.88.254:26656,1630a016ecf7232d6ca584e6628629b3deec63cf@65.21.95.15:11656,34a266af640b860be5272a7d02b6481e009581bb@54.39.128.229:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.celestia-app/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.celestia-app/cosmovisor/genesis/bin
mkdir -p ~/.celestia-app/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/celestiad ~/.celestia-app/cosmovisor/genesis/bin
```

### Create Service File
Create a `celestia-appd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="celestia node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=celestia-appd"
Environment="DAEMON_HOME=/home/USER/.celestia-app"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable celestia-appd.service

# Start service
sudo service celestia-appd start

# Check logs
sudo journalctl -fu celestia-appd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.

> Use Ansible script to automate the node installation process

> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
