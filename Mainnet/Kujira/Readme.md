<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/kujira.png">
</p>



# Kujira Node Installation Guide
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
git clone https://github.com/Team-Kujira/core.git
cd core
git checkout v0.7.1
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
kujirad init MONIKERNAME --chain-id kaiyo-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/kujira/genesis.json --inet4-only
mv genesis.json ~/.kujira/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=9813378d0dceb86e57018bfdfbade9d863f6f3c8@3.38.73.119:26656,ccffabe81f2de8a81e171f93fe1209392bf9993f@65.108.234.59:26656,7878121e8fa201c836c8c0a95b6a9c7ac6e5b101@141.95.151.171:26656,0743497e30049ac8d59fee5b2ab3a49c3824b95c@198.244.200.196:26656,2efead362f0fc7b7fce0a64d05b56c5b28d5c2b4@164.92.209.72:36347,d24ee4b38c1ead082a7bcf8006617b640d3f5ab9@91.196.166.13:26656,5d0f0bc1c2d60f1d273165c5c8cefc3965c3d3c9@65.108.233.175:26656,5a70fdcf1f51bb38920f655597ce5fc90b8b88b8@136.244.29.116:41656,35af92154fdb2ac19f3f010c26cca9e5c175d054@65.108.238.61:27656,e65c2e27ea06b795a25f3ce813ed2062371705b8@213.239.212.121:13657,f6d0d3ac0c748a343368705c37cf51140a95929b@146.59.81.204:36657
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.kujira/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.kujira/cosmovisor/genesis/bin
mkdir -p ~/.kujira/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/kujirad ~/.kujira/cosmovisor/genesis/bin
```

### Create Service File
Create a `kujirad.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="kujirad node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=kujirad"
Environment="DAEMON_HOME=/home/USER/.kujira"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable kujirad.service

# Start service
sudo service kujirad start

# Check logs
sudo journalctl -fu kujirad
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
