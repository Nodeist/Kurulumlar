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
rm -rf Timpi-ChainTN
git clone https://github.com/Timpi-official/Timpi-ChainTN.git
cd Timpi-ChainTN
cd cmd/TimpiChain
go build
cp TimpiChain /root/go/bin/timpid
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
timpid init MONIKERNAME --chain-id TimpiChainTN
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/timpi/genesis.json --inet4-only
mv genesis.json ~/.TimpiChain/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=dfb017436f9d4898ffbacd26f9965bd1e273351b@148.113.138.171:26656,7d6938bdfce943c1d2ba10f3c3f0fe8be7ba7b2c@173.249.54.208:26656,319ec1fd84c147d49f08078aef085c57a8edf09a@45.79.48.248:26656,0373e97105a51c2711ba486f8906acb8da1978f7@167.235.153.124:26656,1a99c42921864c8dc322a579bd57ce2f4778a9f1@5.180.186.25:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.TimpiChain/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.TimpiChain/cosmovisor/genesis/bin
mkdir -p ~/.TimpiChain/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/timpid ~/.TimpiChain/cosmovisor/genesis/bin
```

### Create Service File
Create a `timpid.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="timpid node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=timpid"
Environment="DAEMON_HOME=/home/USER/.TimpiChain"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable timpid.service

# Start service
sudo service timpid start

# Check logs
sudo journalctl -fu timpid
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
