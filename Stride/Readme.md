<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/stride.png">
</p>



# Stride Node Installation Guide
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
git clone https://github.com/Stride-Labs/stride.git
cd stride
git checkout v2.0.3
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
strided init MONIKERNAME --chain-id stride-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/stride/genesis.json --inet4-only
mv genesis.json ~/.stride/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=ffbb05de3bab5939d88ca85aa72b3098d6009fd2@192.168.50.68:26656,dfc52f7dfe9b19d3bc72fc61f428b224716bb163@172.31.1.6:26656,eed404a63d9c446a494f1d6286a780b17812eac8@10.93.14.21:26656,b5f9fa874781f975687018ae559f0d952d3a2e24@0.0.0.0:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.stride/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.stride/cosmovisor/genesis/bin
mkdir -p ~/.stride/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/strided ~/.stride/cosmovisor/genesis/bin
```

### Create Service File
Create a `strided.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="strided node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=strided"
Environment="DAEMON_HOME=/home/USER/.stride"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable strided.service

# Start service
sudo service strided start

# Check logs
sudo journalctl -fu strided
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.

> Use Ansible script to automate the node installation process

> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
