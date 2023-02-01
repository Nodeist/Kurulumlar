<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/terp.png">
</p>



# Terp Node Installation Guide
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
cd $HOME
git clone https://github.com/terpnetwork/terp-core.git
cd terp-core
git checkout v0.2.0
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
terpd init MONIKERNAME --chain-id athena-3
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/terp/genesis.json --inet4-only
mv genesis.json ~/.terp/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=c989593c89b511318aa6a0c0d361a7a7f4271f28@65.108.124.172:26656,f9d7b883594e651a45e91c49712151bf93322c08@141.95.65.26:29456,19566196191ca68c3688c14a73e47125bdebe352@62.171.171.91:26656,c2a177164098b317261d55fb1c946a97e5e35adb@75.119.134.69:30656,360c7c554ba16333b5901a2a341e466ad2c1db37@146.19.24.52:33656,c88a36db47a5f8dded9cd1eb5a7b1af75e5d9294@217.13.223.167:60656,8441f75ff50ccd2a892e5eafb65e4c2ea34aeac3@95.217.118.96:26757,aea62af2f5d457e35a79fbee295bdad3c85a9a8a@45.94.209.226:26656,9d0a1a041c468809dbc2d87e8f46b891b0c5cc58@164.92.116.202:33656,42dfe4bc0cacb118fdb72d251c4b794eb1ea285c@3.135.211.119:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.terp/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.terp/cosmovisor/genesis/bin
mkdir -p ~/.terp/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/terpd ~/.terp/cosmovisor/genesis/bin
```

### Create Service File
Create a `terpd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="terpd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=terpd"
Environment="DAEMON_HOME=/home/USER/.terp"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable terpd.service

# Start service
sudo service terpd start

# Check logs
sudo journalctl -fu terpd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
