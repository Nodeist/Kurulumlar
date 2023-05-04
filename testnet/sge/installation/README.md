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
git clone https://github.com/sge-network/sge
git clone https://github.com/sge-network/networks
cd sge
git fetch --tags
git checkout v0.0.5
cd sge
go mod tidy
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
sged init MONIKERNAME --chain-id sge-network-2
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/sge/genesis.json --inet4-only
mv genesis.json ~/.sge/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=62b76a24869829fb3be53c25891ba37eca5994bd@95.217.224.252:26656,b29612454715a6dc0d1f0c42b426bf30f1d27738@78.46.99.50:24656,14823c9230ac2eb50fd48b7313e8ddd4c13207c6@94.130.219.37:26000,cfa86646e5eb05e111e7dde27750ff8ebe67d165@89.117.56.126:23956,43b05a6bab7ca735397e9fae2cb0ad99977cf482@34.83.191.67:26656,ddcd5fda167e6b45208faed8fd7e2f0640b4185c@52.44.14.245:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.sge/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.sge/cosmovisor/genesis/bin
mkdir -p ~/.sge/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/sged ~/.sge/cosmovisor/genesis/bin
```

### Create Service File
Create a `sged.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="sged node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=sged"
Environment="DAEMON_HOME=/home/USER/.sge"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable sged.service

# Start service
sudo service sged start

# Check logs
sudo journalctl -fu sged
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
