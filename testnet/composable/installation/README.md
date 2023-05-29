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
rm -rf composable-testnet
git clone https://github.com/notional-labs/composable-testnet.git
cd composable-testnet
git checkout v2.3.5
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
banksyd init MONIKERNAME --chain-id banksy-testnet-3
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/composable/genesis.json --inet4-only
mv genesis.json ~/.banksy/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=4d3873e7d858f2cb710fea20c88445ef97d3ae60@37.27.17.146:19656,b2a5b6c11e7d71c2a43d88a73b9dcff3352f4302@57.128.86.7:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:15956,df49f4fee2fe62bc0ca8c27ee0dbae3f0abec98f@46.38.232.86:24656,99004e3251209542b30c7502a7c35b1d574cd3ae@195.3.221.16:26656,de2410e83b86e74a4569e0c120846b67c204f5bc@65.108.226.183:22256,02ea9a908729d6c7a846a535a63fd47131c59b88@65.109.60.19:36656,33d01ca326bb21c3e02c6f05b9cb530eea93c39d@65.109.23.237:30536
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.banksy/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.banksy/cosmovisor/genesis/bin
mkdir -p ~/.banksy/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/banksyd ~/.banksy/cosmovisor/genesis/bin
```

### Create Service File
Create a `banksyd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="banksyd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=banksyd"
Environment="DAEMON_HOME=/home/USER/.banksy"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable banksyd.service

# Start service
sudo service banksyd start

# Check logs
sudo journalctl -fu banksyd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
