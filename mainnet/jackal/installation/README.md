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
rm -rf canine-chain
git clone https://github.com/JackalLabs/canine-chain.git
cd canine-chain
git checkout v1.2.1
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
canined init MONIKERNAME --chain-id jackal-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/jackal/genesis.json --inet4-only
mv genesis.json ~/.canine/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=ad8afbc89ac64db1ee99fdd904cbd48876d44b7d@195.3.222.240:26256,c5b43622ecd7413dd41905f6f8f5b5befd299ced@65.109.65.210:32656,c2842c76779913e05fa4256e3caab852e1782951@202.61.194.254:60756,9bcaee1ad957fa75f60a6dd9d8870e53220794a9@104.37.187.214:60756,e0740626622af6f64c5c71cc8a2723bfc7eedf66@99.241.52.117:26456,d9bfa29e0cf9c4ce0cc9c26d98e5d97228f93b0b@65.109.88.38:37656,ee2ef67b49cbc7b4af7ff0b7321870a5d9ae69a5@65.108.138.80:17556,0daa5dcda773b1d3842ba2881cf27aab519a2cac@54.36.108.222:28656,af774f532cf4b53528b0c418d01dbec549207841@162.19.84.205:26656,519f2b648a2a8794ac33b195f39b6d836e09f8f2@131.153.154.13:26656,f3b96273f3b1a7d2594851badd4302f16db81cfa@23.29.55.92:26656,13cf937bc1525c587fa82b441013995238d68a6e@143.42.114.129:26656,55bbee79c024a5032222ee4cac0d932c4033c63a@142.132.209.97:26656,976d837d399c0914cca7ba81fcd554b1f3d7a7bd@216.209.198.116:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.canine/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.canine/cosmovisor/genesis/bin
mkdir -p ~/.canine/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/canined ~/.canine/cosmovisor/genesis/bin
```

### Create Service File
Create a `canined.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="canined node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=canined"
Environment="DAEMON_HOME=/home/USER/.canine"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable canined.service

# Start service
sudo service canined start

# Check logs
sudo journalctl -fu canined
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
