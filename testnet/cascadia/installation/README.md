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
git clone https://github.com/CascadiaFoundation/cascadia
cd cascadia
git checkout v0.1.1
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
cascadiad init MONIKERNAME --chain-id cascadia_6102-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/cascadia/genesis.json --inet4-only
mv genesis.json ~/.cascadiad/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:15556,893b6d4be8b527b0eb1ab4c1b2f0128945f5b241@185.213.27.91:36656,046e5fdfcf33f221da082b8e4161689bcb915135@77.91.84.30:39656,783a3f911d98ad2eee043721a2cf47a253f58ea1@65.108.108.52:33656,ad417c4efa59e21b43e8e256c73b9939f1c22a0e@23.88.42.28:31656,2256cfe6777faf34317e90c5e12e2e9072322a95@162.55.183.155:10656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.cascadiad/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.cascadiad/cosmovisor/genesis/bin
mkdir -p ~/.cascadiad/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/cascadiad ~/.cascadiad/cosmovisor/genesis/bin
```

### Create Service File
Create a `cascadiad.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="cascadiad node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=cascadiad"
Environment="DAEMON_HOME=/home/USER/.cascadiad"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable cascadiad.service

# Start service
sudo service cascadiad start

# Check logs
sudo journalctl -fu cascadiad
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
