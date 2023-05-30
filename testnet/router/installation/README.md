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
wget https://ss.nodeist.net/t/router/routerd
chmod +x routerd
mv routerd $HOME/go/bin/

```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
routerd init MONIKERNAME --chain-id router_9601-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/router/genesis.json --inet4-only
mv genesis.json ~/.routerd/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=2aa37da908789ecc7040102d2f31ddc3e143c782@13.233.136.29:26656,2bd1a4c4e355ff54fac0f92cab3b2e6d8adb1bc6@13.127.150.80:26656,1a1e29477e8f44bf9c989ac281b8dc6c6582bf9d@34.204.182.21:26656,569bd6846e80fae1d5b381e0a3a0725290d22884@43.204.133.101:26656,645f023b1f1fe36210d7c24ad0c0682f55f51416@65.2.161.80:26656,a8190578ef042021a55c740d262ba4fd275efd99@65.109.101.54:26656,17b33397e2c639e6f360af30c40353866dc5040f@47.245.25.38:26656,06952dd421e75835e8871de3f60507812156ea03@13.127.165.58:26656,af56b56b146d32a778b733aaed1fc6521f9eba95@95.214.55.138:11656,1c4907f615f850e6a2049ea0f69553e16d7dca2a@65.109.82.112:33756
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.routerd/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.routerd/cosmovisor/genesis/bin
mkdir -p ~/.routerd/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/routerd ~/.routerd/cosmovisor/genesis/bin
```

### Create Service File
Create a `routerd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="routerd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=routerd"
Environment="DAEMON_HOME=/home/USER/.routerd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable routerd.service

# Start service
sudo service routerd start

# Check logs
sudo journalctl -fu routerd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
