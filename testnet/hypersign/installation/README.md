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
rm -rf hid-node
git clone https://github.com/hypersign-protocol/hid-node.git
cd hid-node
git checkout v0.1.7
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
hid-noded init MONIKERNAME --chain-id jagrat
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/hypersign/genesis.json --inet4-only
mv genesis.json ~/.hid-node/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=a275d8018f683f279bf5167a72d294bfacafa839@178.63.102.172:41656,23eff008c88dcc60ef9a71f2fb469c472679c35e@136.243.88.91:5040,934324c3b4318d8438954d19a82673a3d218951b@142.132.209.236:10956,e8e764fa9ecc5727038099205798520c547d7019@51.178.65.184:25656,ec5127072c252f7246fb66f7e7762423a23ff6bd@154.12.228.93:31656,d92268c246e02a54103f7098b901b876c88f006e@5.161.130.108:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:13156,d7c9b9a3c3a6c5f4ccdfb37a8358755b277271c1@3.110.226.164:26656,0c6758a3f4554bbc67da73993bbb697764c5c534@38.242.142.227:26656
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



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
