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
git clone https://github.com/AndromaverseLabs/testnet androma
cd androma
git checkout v1
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
andromad init MONIKERNAME --chain-id androma-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/androma/genesis.json --inet4-only
mv genesis.json ~/.androma/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=3410d8c308510223c1fc15a1bb33a0ba8d85a2e2@203.96.179.106:26656,6ca9cc12c3448b22fc51f8ba11eb62b7cb667f04@65.108.132.239:26856,db2a0a0cf06a4cdaf158bfc4919fa520ca02f7c4@135.181.116.109:27786,93ef47cee8857dc069d61404b64c0f1d18bf0b26@65.108.226.26:21656,83324c67e7ec69e249beaaef5d91cf0f1f5014ce@65.108.224.156:17656,f1e10a9358b84f86159c47bcdb74b663fc1f54ee@65.108.226.183:15056,152e12336f6b39ee9ce1bbb16edfe647ba4dd4d6@65.109.92.241:4176,fc6f7914e4beb4b5278e7ba32ec2abde97cd8082@65.109.28.177:26656,6dbdf310876528a45e0f094df1160439f33a1bcf@65.109.87.135:10656,76b1343da5f76dcbef3c50c49f2811eab95129cf@65.108.195.235:23656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.androma/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.androma/cosmovisor/genesis/bin
mkdir -p ~/.androma/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/andromad ~/.androma/cosmovisor/genesis/bin
```

### Create Service File
Create a `andromad.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="andromad node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=andromad"
Environment="DAEMON_HOME=/home/USER/.androma"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable andromad.service

# Start service
sudo service andromad start

# Check logs
sudo journalctl -fu andromad
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
