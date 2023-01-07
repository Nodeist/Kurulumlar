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
wget $KYVE_REPO
tar -xvzf https://kyve-korellia.s3.eu-central-1.amazonaws.com/v0.7.0/kyved_linux_amd64.tar.gz
chmod +x kyved
sudo mv kyved $HOME/go/bin/kyved
rm kyved_linux_amd64.tar.gz
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
kyved init MONIKERNAME --chain-id korellia
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/kyve/genesis.json --inet4-only
mv genesis.json ~/.kyve/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=94f8496c7f50cdbb3b6114b81356ecc547e5417a@95.217.239.213,bd1993c1595bc23ec3691056ea2041214aa01b40@148.251.47.69,abfb21fe07f6575ede31e8cf00f10c4fe07b03b0@167.235.31.186,4daaf2978669a3b5f79a777b81f5c2bb2dcf8dcf@75.119.134.69,f6f6f2fba5e2f0f859994b08b93d005b63eaa26d@195.201.237.172,a1e6b2f31f83fce519433286592809c7ec775261@5.161.85.85,16f8c16da06483cf620c42c7c59ac97eaeb011cf@168.119.213.113,802eb6c2b3277bf04eff9c74e16d0e05cc1a59e3@95.216.143.230,d2549f542370737bb07d2e6376984b5cf9dc871f@161.97.92.178,d57eed80e3f0ae8d27d0df5737816acd62001c97@75.119.130.253
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
