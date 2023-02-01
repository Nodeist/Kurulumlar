<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/nolus.png">
</p>



# Nolus Node Installation Guide
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
git clone https://github.com/Nolus-Protocol/nolus-core
cd nolus
git checkout v0.1.39
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
nolusd init MONIKERNAME --chain-id nolus-rila
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/nolus/genesis.json --inet4-only
mv genesis.json ~/.nolus/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=98907b8c92c003aa2d003bb5d47e5ae6e34b0732@77.51.200.79:46656,c6e7b095d965209c8d15086c2a173627fb9b29e1@161.97.169.22:26656,e0aac09f3de68abf583b0e3994228ee8bd19d1eb@168.119.124.130:45659,9cafdff7858f3925007e4fa1e7ac3b591a0bd045@45.130.104.142:26656,5c2a752c9b1952dbed075c56c600c3a79b58c395@195.3.220.135:27016,bab17bf921c3bc6882dc0d37ed1ec9da9135a84c@109.123.236.225:13656,90422b8d40906967098a4010318344114e135d84@183.182.125.23:26656,896c70ce52e6c88313048c9a63fcb9e7f0277144@178.208.86.44:46656,67be97f5ef69a4f149fbef7970ba888e5b2c2cff@65.108.231.124:16656,e84c51a539d705787644e235faab6bccd4b73bdd@5.61.33.18:26656,33f4b7f56b6708526f0638162f020394de0ce5e9@65.21.229.33:28656,df5a117c4e2f5d047b57552d71d45e8ea4a30f2c@185.239.209.135:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.nolus/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.nolus/cosmovisor/genesis/bin
mkdir -p ~/.nolus/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/nolusd ~/.nolus/cosmovisor/genesis/bin
```

### Create Service File
Create a `nolusd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="nolusd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=nolusd"
Environment="DAEMON_HOME=/home/USER/.nolus"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable nolusd.service

# Start service
sudo service nolusd start

# Check logs
sudo journalctl -fu nolusd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
