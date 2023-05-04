## Instructions
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
rm -rf gitopia
git clone gitopia://gitopia/gitopia
cd gitopia
git checkout v1.2.0
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
gitopiad init MONIKERNAME --chain-id gitopia-janus-testnet-2
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/gitopia/genesis.json --inet4-only
mv genesis.json ~/.gitopia/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=93c4c73375b5f52020e7e7bd3f901ee28f07e6b7@109.123.243.66:41656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:14156,66f94651fb02f277c90c605a38df549d3c0a9269@75.119.151.217:26656,4e4f87cfa1993f4f3f7645c41f469987cafdf960@85.10.202.135:12656,619a23818cddd40d0b9f57e9754b719da13609bc@65.108.108.52:24656,5b1c25f4dff541f77f1532c457f73ca7ee2e4c18@194.163.170.225:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.gitopia/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.gitopia/cosmovisor/genesis/bin
mkdir -p ~/.gitopia/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/gitopiad ~/.gitopia/cosmovisor/genesis/bin
```

### Create Service File
Create a `gitopiad.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="gitopiad node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=gitopiad"
Environment="DAEMON_HOME=/home/USER/.gitopia"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable gitopiad.service

# Start service
sudo service gitopiad start

# Check logs
sudo journalctl -fu gitopiad
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
