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
PEERS=17cc34fc4a5c91e67bc7e11b9c15cad10dd11336@138.201.221.94:26656,7d1ac536c8451d1b64e9702fb172ac5b1b725778@65.109.85.221:9000,b6c8dc38a5dba19a3f10d23b3572065db9265fa3@65.109.85.225:9000,3043450abbb1026c2e73d8a2549ee2e395ea5454@65.108.78.41:36656,36bf6f60f2914352c93dcc6d827885e3e58b1f2b@158.160.20.18:26656,ef404b6e855c70ee51532ca83407350d2379bdec@5.161.101.185:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:43656,e95c1138763c637ca62a391bc316c9a96283d79f@188.40.122.98:36656,1a5f37caaa5dd174bc2797bf2a70b804e71bc632@162.55.42.27:26656
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

> Use Ansible script to automate the node installation process

> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
