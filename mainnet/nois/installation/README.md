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
rm -rf noisd
git clone https://github.com/noislabs/noisd.git
cd noisd
git checkout v1.0.0
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
noisd init MONIKERNAME --chain-id nois-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/nois/genesis.json --inet4-only
mv genesis.json ~/.noisd/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=00852ba0bfdf20aac74369b1a5c43e50668c9738@135.181.128.114:17356,d2041f5d812b4fb196d5210a287448b68fe7bef9@95.217.104.49:51656,8ec2fee6c37c07cc5af57ec870015a0191d4707d@65.108.65.36:51656,ad53e98a88aa0c6f724b457ad6575b83c5f4a02b@167.235.15.19:30656,9d21af60ad2568ffcb55a0bd0eb03b6cfa2644c5@49.12.120.113:26656,374615fcb23cfbd30a59a2b904cf675d9b93b7e0@78.46.61.117:01656,497dff4750970f8d142c9c61da4acee0e3ff76c4@141.95.155.224:12156,288e7a14ccac3cdc1d8ab20335d4c48edf5930f2@84.46.250.136:17356,3784e5ecd7f703c8a37427463e9c7c7b31389345@142.132.211.91:51656,732fe2553e152d37b29653ee07324fdbfd5ef961@95.217.200.26:36656,379c0e32463be66e5cf8d13d62eb87ddb1a702c2@142.132.152.46:47656,1eef6409922688e5bf6f00891537552b9ba5540f@135.181.119.59:51656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.noisd/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.noisd/cosmovisor/genesis/bin
mkdir -p ~/.noisd/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/noisd ~/.noisd/cosmovisor/genesis/bin
```

### Create Service File
Create a `noisd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="noisd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=noisd"
Environment="DAEMON_HOME=/home/USER/.noisd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable noisd.service

# Start service
sudo service noisd start

# Check logs
sudo journalctl -fu noisd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
