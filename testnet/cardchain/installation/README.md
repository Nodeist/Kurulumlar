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
curl -L https://github.com/DecentralCardGame/Cardchain/releases/download/v0.81/Cardchain_latest_linux_amd64.tar.gz > Cardchain_latest_linux_amd64.tar.gz
tar -xvzf Cardchain_latest_linux_amd64.tar.gz
chmod +x Cardchaind
mkdir -p $HOME/go/bin
mv Cardchaind $HOME/go/bin
rm Cardchain_latest_linux_amd64.tar.gz
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
Cardchaind init MONIKERNAME --chain-id testnet3
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/cardchain/genesis.json --inet4-only
mv genesis.json ~/.Cardchain/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=5f71d8b873cf04b8bf515569f2fcf4dd479f353b@161.97.89.239:27656,345d8149cbda76ae42142a78df7bbc90f5fc26f2@149.102.142.176:26656,99dcfbba34316285fceea8feb0b644c4dc67c53b@195.201.197.4:31656,b2897d1cf10082ffaa66390cbf3ec70df1b0426d@116.202.227.117:18656,d5fbf52331f8a8851557cd0eabf444850cef5646@135.181.133.16:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.Cardchain/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.Cardchain/cosmovisor/genesis/bin
mkdir -p ~/.Cardchain/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/Cardchaind ~/.Cardchain/cosmovisor/genesis/bin
```

### Create Service File
Create a `Cardchaind.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="Cardchaind node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=Cardchaind"
Environment="DAEMON_HOME=/home/USER/.Cardchain"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable Cardchaind.service

# Start service
sudo service Cardchaind start

# Check logs
sudo journalctl -fu Cardchaind
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
