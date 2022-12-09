<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/c4e.png">
</p>



# C4E Node Installation Guide
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
git clone https://github.com/chain4energy/c4e-chain.git
cd c4e-chain
git checkout v1.0.0
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
c4ed init MONIKERNAME --chain-id perun-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/c4e/genesis.json --inet4-only
mv genesis.json ~/.c4e-chain/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=96b621f209eb2244e6b0976a8918e1f6536d9a3d@34.208.153.193:26656,c1bfac5b59966c2fc97d48540b9614f34785fbf3@57.128.144.137:26656,f5d50df79f2aa5a9d18576147f59b8807347b6f9@66.70.178.78:26656,85acd1e5580c950f5ede07c3da4bd814d42cf323@95.179.190.59:26656,fe9a629d1bb3e1e958b2013b6747e3dbbd7ba8d3@149.102.130.176:26656,37f3f290c59dcce9109ac828e9839dc9c22be718@188.34.134.24:26656,bb9cbee9c391f5b0744d5da0ea1abc17ed0ca1b2@159.69.56.25:26656,2f6141859c28c088514b46f7783509aeeb87553f@141.94.193.12:11656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.c4e-chain/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.c4e-chain/cosmovisor/genesis/bin
mkdir -p ~/.c4e-chain/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/c4ed ~/.c4e-chain/cosmovisor/genesis/bin
```

### Create Service File
Create a `c4ed.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="c4ed node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=c4ed"
Environment="DAEMON_HOME=/home/USER/.c4e-chain"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable c4ed.service

# Start service
sudo service c4ed start

# Check logs
sudo journalctl -fu c4ed
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.

> Use Ansible script to automate the node installation process

> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
