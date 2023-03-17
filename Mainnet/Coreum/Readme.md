<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/coreum.png">
</p>



# Coreum Node Installation Guide
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
curl -LOf https://github.com/CoreumFoundation/coreum/releases/download/v1.0.0/cored-linux-amd64
chmod +x cored-linux-amd64
mv cored-linux-amd64 $HOME/go/bin/cored
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
coreumd init MONIKERNAME --chain-id coreum-mainnet-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/coreum/genesis.json --inet4-only
mv genesis.json ~/.coreum/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=8cedd961a72c183686e9b0b67b6e54fccd6471c3@35.194.10.107:26656,81e76bc013acbb2048e7acfb2ab04d80732a3699@34.122.166.246:26656,55cec213e8f3738d2642147d857afab93b1a4ef6@34.172.192.61:26656,62b207017a272a1452ebe7e67018a4f6be1146d8@34.172.201.60:26656,094189cad7921baf44c280ee8efed959869f3a22@34.66.215.21:26656,d65085259afd2065796bba7430d61fe85042e1c3@190.92.219.25:26656,eeb17ff4b1dad8d20fdafc339c277f7a624bb84a@35.238.253.76:26656,92b67a34dbda739a92cd04561ac8c33bfa858477@34.67.59.88:26656,2505072cc9586c0c4fafa092a2352123d8c12936@34.28.225.76:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.core/coreum-mainnet-1/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.coreum/cosmovisor/genesis/bin
mkdir -p ~/.coreum/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/coreumd ~/.coreum/cosmovisor/genesis/bin
```

### Create Service File
Create a `coreumd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="coreumd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=coreumd"
Environment="DAEMON_HOME=/home/USER/.coreum"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable coreumd.service

# Start service
sudo service coreumd start

# Check logs
sudo journalctl -fu coreumd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
