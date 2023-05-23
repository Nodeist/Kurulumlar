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
rm -rf nolus-core
git clone https://github.com/nolus-protocol/nolus-core
cd nolus-core
git checkout v0.3.0
make build
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
nolusd init MONIKERNAME --chain-id pirin-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/nolus/genesis.json --inet4-only
mv genesis.json ~/.nolus/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=39fa78be2d32bde352c7252c219f75ad81aaf14a@144.76.40.53:19756,18845b356886a99ee704f7a06de79fc8208b47d1@57.128.96.155:19756,e5e2b4ae69c1115f126abcd5aa449842e29832b0@51.255.66.46:2110,13f2ff36f5caeec4bca6705aebc0ce5fb65aefb3@168.119.89.8:27656,6cceba286b498d4a1931f85e35ea0fa433373057@169.155.170.20:26656,7740f125a480d1329fa1015e7ea97f09ee4eded7@107.135.15.66:26746,488c9ee36fc5ee54e662895dfed5e5df9a5ff2d5@136.243.39.118:26656,aeb6c84798c3528b20ee02985208eb72ed794742@185.246.87.116:26666,cbbb839a7fee054f7e272688787200b2b847bbf0@103.180.28.91:26656,67d569007da736396d7b636224b97349adcde12f@51.89.98.102:55666,e16568ad949050e0a817bddaf651a8cce04b0e7a@176.9.70.180:26656
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

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
