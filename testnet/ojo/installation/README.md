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
rm -rf ojo
git clone https://github.com/ojo-network/ojo
cd ojo || return
git checkout v0.1.2
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
ojod init MONIKERNAME --chain-id ojo-devnet
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/ojo/genesis.json --inet4-only
mv genesis.json ~/.ojo/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=1786d7d18b39d5824cae23e8085c87883ed661e6@65.109.147.57:36656,9ea0473b3684dbf1f2cf194f69f746566dab6760@78.46.99.50:22656,ed367ee00b2155c743be6f5b635de6e7ea5acc64@149.202.73.104:11356,66b140833cba7cadd92d544088d735e219adbf01@65.108.226.183:21656,0621bb73d18724cae4eb411e6b96765f95a3345e@178.63.8.245:61356,b33500a3aaeb7fa116bdbddbe9c91c3158f38f8d@128.199.18.172:26656,e0fb84d102a7a43e13362c848df725d6868aed55@144.76.164.139:37656,9bcec17faba1b8f6583d37103f20bd9b968ac857@38.146.3.230:21656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.ojo/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.ojo/cosmovisor/genesis/bin
mkdir -p ~/.ojo/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/ojod ~/.ojo/cosmovisor/genesis/bin
```

### Create Service File
Create a `ojod.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="ojod node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=ojod"
Environment="DAEMON_HOME=/home/USER/.ojo"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable ojod.service

# Start service
sudo service ojod start

# Check logs
sudo journalctl -fu ojod
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
