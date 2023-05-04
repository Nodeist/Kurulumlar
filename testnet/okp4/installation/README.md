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
rm -rf okp4d
git clone https://github.com/okp4/okp4d.git
cd okp4d
git checkout v4.1.0
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
okp4d init MONIKERNAME --chain-id okp4-nemeton-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/okp4/genesis.json --inet4-only
mv genesis.json ~/.okp4d/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:13656,8028015d1c6828a0b734f3b108f0853b0e19305e@157.90.176.184:26656,8cdeb85dada114c959c36bb59ce258c65ae3a09c@88.198.242.163:36656,42fbb917fca6787bc3ab774865f4bb1ef950f114@65.108.226.26:30656,78d923333e39e747c6a7fbfcc822ec6279990556@91.211.251.232:28656,d1c1b729eff9afe7dfd371f190df6282c82ccfad@65.109.89.5:31656,874373b78d2cd50e716aa464bf407581d9305655@94.250.201.130:27656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.okp4d/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.okp4d/cosmovisor/genesis/bin
mkdir -p ~/.okp4d/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/okp4d ~/.okp4d/cosmovisor/genesis/bin
```

### Create Service File
Create a `okp4d.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="okp4d node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=okp4d"
Environment="DAEMON_HOME=/home/USER/.okp4d"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable okp4d.service

# Start service
sudo service okp4d start

# Check logs
sudo journalctl -fu okp4d
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
