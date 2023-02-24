<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/coreum.png">
</p>



# Coreum Node Installation Guide
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
curl -LOf https://github.com/CoreumFoundation/coreum/releases/download/v0.1.1/cored-linux-amd64
chmod +x cored-linux-amd64
mv cored-linux-amd64 $HOME/go/bin/cored
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
cored init MONIKERNAME --chain-id coreum-testnet-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/coreum/genesis.json --inet4-only
mv genesis.json ~/.core/coreum-testnet-1/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=69d7028b7b3c40f64ea43208ecdd43e88c797fd6@34.69.126.231:26656,b2978432c0126f28a6be7d62892f8ded1e48d227@34.70.241.13:26656,7c0d4ce5ad561c3453e2e837d85c9745b76f7972@35.238.77.191:26656,0aa5fa2507ada8a555d156920c0b09f0d633b0f9@34.173.227.148:26656,4b8d541efbb343effa1b5079de0b17d2566ac0fd@34.172.70.24:26656,27450dc5adcebc84ccd831b42fcd73cb69970881@35.239.146.40:26656,5add70ec357311d07d10a730b4ec25107399e83c@5.196.7.58:26656,1a3a573c53a4b90ab04eb47d160f4d3d6aa58000@35.233.117.165:26656,abbeb588ad88176a8d7592cd8706ebbf7ef20cfe@185.241.151.197:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.core/coreum-testnet-1/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.core/coreum-testnet-1/cosmovisor/genesis/bin
mkdir -p ~/.core/coreum-testnet-1/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/cored ~/.core/coreum-testnet-1/cosmovisor/genesis/bin
```

### Create Service File
Create a `cored.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="cored node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=cored"
Environment="DAEMON_HOME=/home/USER/.core/coreum-testnet-1"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable cored.service

# Start service
sudo service cored start

# Check logs
sudo journalctl -fu cored
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
