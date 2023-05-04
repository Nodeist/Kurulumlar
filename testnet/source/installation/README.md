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
git clone -b testnet https://github.com/Source-Protocol-Cosmos/source.git
cd ~/source
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
sourced init MONIKERNAME --chain-id sourcechain-testnet
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/source/genesis.json --inet4-only
mv genesis.json ~/.source/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=cac254555deea35a70c821abd7f3e7db47a46d55@65.109.92.241:20056,5fb7f75e3a97fa0f936020b62daf1e67281f7f16@65.109.92.240:20056,db69700d8b0c277183ab1ec34d79a083c2578d32@65.21.145.209:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:12856,d960215e0788fcfc04b9e2e824e5751bf1efe7fc@65.108.82.152:26656,b24ae5d099d5564a227aa7b1a8278293b8db0cfa@185.255.131.27:26656,cba9a7c35b554596577e9708d405eb83b1f2a6d2@65.21.248.172:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.source/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.source/cosmovisor/genesis/bin
mkdir -p ~/.source/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/sourced ~/.source/cosmovisor/genesis/bin
```

### Create Service File
Create a `sourced.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="sourced node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=sourced"
Environment="DAEMON_HOME=/home/USER/.source"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable sourced.service

# Start service
sudo service sourced start

# Check logs
sudo journalctl -fu sourced
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
