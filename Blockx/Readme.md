<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/blockx.png">
</p>



# Blockx Node Installation Guide
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
wget (Private Repo)
chmod +x blockxd
mv blockxd $HOME/go/bin/
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
blockxd init MONIKERNAME --chain-id blockx_12345-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/blockx/genesis.json --inet4-only
mv genesis.json ~/.blockxd/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=8339668165d1fe98f24c042e7a61fd7c6aa7a1aa@142.93.202.64,85f8e76274cb95d9dde3487d5b8547be27f58192@167.99.12.133,d7206cb001a85c9c7437f1f9c798ac6aef474cea@159.223.101.23,6b0f6f7871beb1b16e3d306362bf17932c7268e8@192.241.149.124,3a36a796162153a6ef2a9f0fd56198b6c4870157@159.89.52.0,f997153b25637ed58924994d7a168cb38a3f7602@4.193.55.49,6bc5cf39d3f471c852720710d062beadd3395769@148.113.139.9,ce99a0050f5f92303eb2b384c62123b0cc1fff84@85.239.241.145,aefb7fa893e8218937b2094ffe4df18b76d19680@91.229.23.155,8807db839efe14a9cd1b5b76ee5beac4f14bd622@104.248.249.90,93208b250758151f8fe3408c09592bc0317297a0@85.239.238.220,23b12388a6922cb3bb7b72b8b7cc7429b7444f80@142.93.3.163
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.blockxd/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.blockxd/cosmovisor/genesis/bin
mkdir -p ~/.blockxd/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/blockxd ~/.blockxd/cosmovisor/genesis/bin
```

### Create Service File
Create a `blockxd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="blockxd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=blockxd"
Environment="DAEMON_HOME=/home/USER/.blockxd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable blockxd.service

# Start service
sudo service blockxd start

# Check logs
sudo journalctl -fu blockxd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
