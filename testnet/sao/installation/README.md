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
rm -rf sao-consensus
git clone https://github.com/SaoNetwork/sao-consensus.git
cd sao-consensus
git checkout v0.1.3
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
saod init MONIKERNAME --chain-id sao-testnet1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/sao/genesis.json --inet4-only
mv genesis.json ~/.sao/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=87aae9e66b092c79c6e5e1a7c64ec21128359f7e@144.76.97.251:37656,c6425d191599ad2ac0f6cddaf088df0fa5110c2f@65.108.78.101:26656,b8b0ad82927e46e480a18201b77cd716870d1511@46.101.132.190:26656,1ed54d64859edbfe8109155c0cf6bdb04e592cb6@142.132.248.253:65528,4245cbb64c958bb29a73048e37f8ccc68314b931@115.73.213.74:26656,4fa89d8492cdef5b7f887c4002b3df70d1283063@65.21.134.202:15756,a36a32d394005be2be4d49c998ff0d3e4768858f@8.214.46.204:26656,6940cf462e90af92828024d087d8ed0a7006d7ff@199.175.98.110:26656,5b1a021a6ed3274dc2c855490ad8fe45e03ace99@65.108.75.107:21656
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

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
