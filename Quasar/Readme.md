<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/quasar.png">
</p>



# Quasar Node Installation Guide
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
wget https://github.com/quasar-finance/binary-release/raw/main/v0.0.2-alpha-11/quasarnoded-linux-amd64
sudo mv quasarnoded-linux-amd64 quasarnoded
sudo chmod +x quasarnoded
sudo mv quasarnoded $HOME/go/bin/quasarnoded
quasarnoded version # 0.0.2-alpha-11
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
quasarnoded init MONIKERNAME --chain-id qsr-questnet-04
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/quasar/genesis.json --inet4-only
mv genesis.json ~/.quasarnode/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=8a19aa6e874ed5720aad2e7d02567ec932d92d22@141.94.248.63:26656,444b80ce750976df59b88ac2e08d720e1dbbf230@68.183.75.239:26666,20b4f9207cdc9d0310399f848f057621f7251846@222.106.187.13:40606,7ef67269c8ec37ff8a538a5ae83ca670fd2da686@137.184.192.123:26656,19afe579cc0a2b38ca87143f779f45e9a7f18a2f@18.134.191.148:26656,a23f002bda10cb90fa441a9f2435802b35164441@38.146.3.203:18256,bba6e85e3d1f1d9c127324e71a982ddd86af9a99@88.99.3.158:18256,966acc999443bae0857604a9fce426b5e09a7409@65.108.105.48:18256 ,177144bed1e280a6f2435d253441e3e4f1699c6d@65.109.85.226:8090,769ebaa9942375e70cebc21a75a2cfda41049d99@135.181.210.186:26656,8937bdacf1f0c8b2d1ffb4606554eaf08bd55df4@5.75.255.107:26656,99a0695a7358fa520e6fcd46f91492f7cf205d4d@34.175.159.249:26656,47401f4ac3f934afad079ddbe4733e66b58b67da@34.175.244.202:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.quasarnode/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.quasarnode/cosmovisor/genesis/bin
mkdir -p ~/.quasarnode/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/quasarnoded ~/.quasarnode/cosmovisor/genesis/bin
```

### Create Service File
Create a `quasarnoded.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="quasarnoded node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=quasarnoded"
Environment="DAEMON_HOME=/home/USER/.quasarnode"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable quasarnoded.service

# Start service
sudo service quasarnoded start

# Check logs
sudo journalctl -fu quasarnoded
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
