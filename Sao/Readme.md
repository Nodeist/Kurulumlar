<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/sao.png">
</p>



# Sao Node Installation Guide
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
rm -rf sao-consensus
git clone https://github.com/SaoNetwork/sao-consensus
cd sao-consensus
git checkout testnet0
make install
sudo mv $HOME/go/bin/saod /usr/bin/
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
saod init MONIKERNAME --chain-id sao-testnet0
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/sao/genesis.json --inet4-only
mv genesis.json ~/.sao/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=a5298771c624a376fdb83c48cc6c630e58092c62@192.18.136.151:26656,59cef823c1a426f15eb9e688287cd1bc2b6ea42d@152.70.126.187:26656,e96613a87f825269bf81ece62a9c53e611f0143c@91.201.113.194:46656,91b67dd0d2904d95748e1ec5311e39033cfeaabc@65.109.92.240:1076,af7259853f202391e624c612ff9d3de1142b4ca4@52.77.248.130:26656,c196d06c9c37dee529ca167701e25f560a054d6d@3.35.136.39:26656,87aae9e66b092c79c6e5e1a7c64ec21128359f7e@144.76.97.251:37656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.sao/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.sao/cosmovisor/genesis/bin
mkdir -p ~/.sao/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/saod ~/.sao/cosmovisor/genesis/bin
```

### Create Service File
Create a `saod.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="saod node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=saod"
Environment="DAEMON_HOME=/home/USER/.sao"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable saod.service

# Start service
sudo service saod start

# Check logs
sudo journalctl -fu saod
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
