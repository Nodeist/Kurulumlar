<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/jackal.png">
</p>



# Jackal Node Installation Guide
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
git clone https://github.com/JackalLabs/canine-chain
cd canine-chain
git checkout v1.2.0
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
canined init MONIKERNAME --chain-id jackal-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/jackal/genesis.json --inet4-only
mv genesis.json ~/.canine/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=c98028a169aabe5f8555090e6cd3370308b391b3@135.181.20.44:2506,ec38fb158ffb0272c4b7c951fc790a8f9849e280@198.244.212.27:26656,399068f8371dce4ae5d7cd7da2c965e765e68f4b@65.108.238.102:17556,39b55b1c49ad0994bbead006be40d9c84b0bf2d4@78.107.253.133:28656,f90a64a0a3f3c0480360e0fe5dd0f806d7741558@207.244.127.5:26656,57d82676ab660e8e4471664d7fee18e3e2e3dd19@89.58.38.59:26656,8be44995ab4eeafcde6e0a9e196c40d483ef6d2a@51.81.155.97:10556
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.canine/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.canine/cosmovisor/genesis/bin
mkdir -p ~/.canine/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/canined ~/.canine/cosmovisor/genesis/bin
```

### Create Service File
Create a `canined.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="canined node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=canined"
Environment="DAEMON_HOME=/home/USER/.canine"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable canined.service

# Start service
sudo service canined start

# Check logs
sudo journalctl -fu canined
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.

> Use Ansible script to automate the node installation process

> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
