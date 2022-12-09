<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/hypersign.png">
</p>



# Hypersign Node Installation Guide
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
git clone https://github.com/hypersign-protocol/hid-node.git
cd hid-node
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
hypersignd init MONIKERNAME --chain-id hypersign-testnet-sirius
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/hypersign/genesis.json --inet4-only
mv genesis.json ~/.hid-node/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=85279852bd306c385402185e0125dffeed36bf22@38.146.3.194:26656,09ce2d3fc0fdc9d1e879888e7d72ae0fefef6e3d@65.108.105.48:11256
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.hid-node/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.hid-node/cosmovisor/genesis/bin
mkdir -p ~/.hid-node/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/hid-noded ~/.hid-node/cosmovisor/genesis/bin
```

### Create Service File
Create a `hid-noded.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="hid-noded node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=hid-noded"
Environment="DAEMON_HOME=/home/USER/.hid-node"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable hid-noded.service

# Start service
sudo service hid-noded start

# Check logs
sudo journalctl -fu hid-noded
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.

> Use Ansible script to automate the node installation process

> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
