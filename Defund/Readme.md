<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/defund.png">
</p>



# Defund Node Installation Guide
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
git clone https://github.com/defund-labs/defund.git
cd defund
git checkout v0.1.0
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
defundd init MONIKERNAME --chain-id defund-private-2
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/defund/genesis.json --inet4-only
mv genesis.json ~/.defund/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=6366ac3af3995ecbc48c13ce9564aef0c7a6d7df@defund-testnet.nodejumper.io:28656,f03f3a18bae28f2099648b1c8b1eadf3323cf741@162.55.211.136:26656,a9c52398d4ea4b3303923e2933990f688c593bd8@157.90.208.222:36656,b136caf667b9cb81de8c1858de300376d7a0ee0f@65.21.53.39:46656,a56c51d7a130f33ffa2965a60bee938e7a60c01f@142.132.158.4:10656,51c8bb36bfd184bdd5a8ee67431a0298218de946@57.128.80.37:26656,e47e5e7ae537147a23995117ea8b2d4c2a408dcb@172.104.159.69:45656,b2521331cc7ef94374208aae2c1ed8a3dcdd811b@95.217.118.100:28656,2b76e96658f5e5a5130bc96d63f016073579b72d@51.91.215.40:45656,f8093378e2e5e8fc313f9285e96e70a11e4b58d5@141.94.73.39:45656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.defund/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.defund/cosmovisor/genesis/bin
mkdir -p ~/.defund/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/defundd ~/.defund/cosmovisor/genesis/bin
```

### Create Service File
Create a `defundd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="defundd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=defundd"
Environment="DAEMON_HOME=/home/USER/.defund"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable defundd.service

# Start service
sudo service defundd start

# Check logs
sudo journalctl -fu defundd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
