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
rm -rf ununifi
git clone https://github.com/UnUniFi/chain ununifi
cd ununifi || return
git checkout v2.1.0
make build
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
ununifid init MONIKERNAME --chain-id ununifi-beta-v1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/ununifi/genesis.json --inet4-only
mv genesis.json ~/.ununifi/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=1357ac5cd92b215b05253b25d78cf485dd899d55@[2600:1f1c:534:8f02:7bf:6b31:3702:2265]:26656,ed7e91350c4086fa1a2237978d4fbda50f9620a1@51.195.145.109:26656,1f954a27230c300417b4abf876dc26e1b243b6c6@128.1.131.123:26656,7fcfaf5941c0a4c22d39ec239862a97fda5dc5d8@159.69.59.89:26676,c25eea256d716ced4a156515bffe74709700d752@54.86.9.250:26656,5fe291fddba68eba46711af84cc9803629e42a6a@75.119.158.3:26656,cea8d05b6e01188cf6481c55b7d1bc2f31de0eed@3.101.90.205:26656,fa38d2a851de43d34d9602956cd907eb3942ae89@45.77.14.59:26656,67899600321bc673dce01489f0a79007cb44da96@139.144.77.82:26656,796c62bb2af411c140cf24ddc409dff76d9d61cf@[2600:1f1c:534:8f02:ca0e:14e9:8e60:989e]:26656,6031e074a44b10563209a0fb81a1fc08323796d7@192.99.44.79:23256,553d7226aaee5a043b234300f57f99e74c81f10c@88.99.69.190:26656,51da685a375d9fdebf20e989f3c2775a0f717d2d@184.174.35.252:26656,e9539642f4ca58bb6dc09257d4ba8fc00467235f@65.108.199.120:60656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.ununifi/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.ununifi/cosmovisor/genesis/bin
mkdir -p ~/.ununifi/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/ununifid ~/.ununifi/cosmovisor/genesis/bin
```

### Create Service File
Create a `ununifid.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="ununifid node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=ununifid"
Environment="DAEMON_HOME=/home/USER/.ununifi"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable ununifid.service

# Start service
sudo service ununifid start

# Check logs
sudo journalctl -fu ununifid
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
