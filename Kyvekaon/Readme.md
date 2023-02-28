<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/kyve.png">
</p>



# Kyve Node Installation Guide
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
wget https://files.kyve.network/chain/v1.0.0-rc0/kyved_linux_amd64.tar.gz
tar -xvzf kyved_linux_amd64.tar.gz
sudo mv chaind kyved
sudo chmod +x kyved
sudo mv kyved $HOME/go/bin/kyved
rm kyved_linux_amd64.tar.gz
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
kyved init MONIKERNAME --chain-id kaon-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/kyvekaon/genesis.json --inet4-only
mv genesis.json ~/.kyve/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=a16f15669692ac66d1eed3e32485077abdf4b08c@161.97.98.83:26656,e215ad0f0664a121efdd627cb580a5312bb6dd1f@65.109.104.171:28656,1a9a719766a43bac6949770362e0e742af0fa7de@135.181.214.190:26658,5e4396a64a069227e25cb34b35eda9693c8ec260@185.172.191.11:26656,1fa8c846f0bebaf6d1ddf803569709e3965f1999@185.144.99.33:26656,782359e3c4d543a605fda2cdbda4a439cb5a0bac@162.55.245.142:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.kyve/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.kyve/cosmovisor/genesis/bin
mkdir -p ~/.kyve/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/kyved ~/.kyve/cosmovisor/genesis/bin
```

### Create Service File
Create a `kyved.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="kyved node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=kyved"
Environment="DAEMON_HOME=/home/USER/.kyve"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable kyved.service

# Start service
sudo service kyved start

# Check logs
sudo journalctl -fu kyved
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
