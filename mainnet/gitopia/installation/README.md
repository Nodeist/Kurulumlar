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
git clone https://github.com/gitopia/gitopia.git
cd gitopia
git checkout v2.0.0
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
gitopiad init MONIKERNAME --chain-id gitopia
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/gitopia/genesis.json --inet4-only
mv genesis.json ~/.gitopia/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=4cf66531681c92f15c95c25bd1bff524f9dca35e@65.109.154.181:26656,b2f764694d52e09793d68259d584ece0c194b6fe@65.108.229.93:26656,082e95b5d5351e68dcfb24dff802f9064cfd5a4c@65.109.92.241:51056,a94aec7233f9fec2b2de4b5c9dab6ad979820b3d@65.109.104.118:60756,a0ebd1e5845148c47451452047c7c99621da195e@65.109.96.93:60556,4adfa5889675e1e91ea4459e15ff4a0ba53e7828@65.108.224.156:19656,12f6b84a23b054a6591c647c2a4456c40af65cce@5.9.147.22:24657,88497ab3bbbcc1e8545771f45020e738bcce590f@95.165.89.222:24136,abca18ed112719b4f0a23932797dba2733f0fd44@23.88.5.169:25656,976d95adec7f0d7fda4464df019fa538fa0bb4ce@144.76.97.251:44656,ffd761a9e0d86609de6dae5935f99451694051a9@34.28.130.17:26656,5b2df98ad73a0a81a5bd31da4489a9236a7d7a99@65.21.91.160:26867,712dd67b7abe08577d394e90a4930492c8f7d2ee@65.108.124.219:41656
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
