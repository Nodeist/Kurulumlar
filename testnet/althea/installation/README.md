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
rm -rf althea-chain
git clone https://github.com/althea-net/althea-chain.git
cd althea-chain
git checkout v0.3.2
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
althea init MONIKERNAME --chain-id althea_7357-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/althea/genesis.json --inet4-only
mv genesis.json ~/.althea/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=16a9576c9a4cf9651b4215e3a877ae002555dd9b@116.202.117.229:31656,ba247bdf826a9636a8276d6a00d8004755f6bb18@162.19.238.210:26656,d5040e6aa2f190e04a39dc27e8199786a848e1cd@161.97.99.251:26156,eab7a70812ba39094fc8bbf4f69f099123863b38@81.30.157.35:11656,bdf94092f6dc380f6526f7b8b46b63192e95a033@173.212.222.167:29656,96320aaab7794933fddbc2bb101e54b8697c58e7@141.95.65.26:26656,17edf24237b1c2b5b196d344761f964407d05862@65.108.233.109:12456,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:52656,ff3fe47b494b0bf3dedf2d47dc9acf0e2ba3b7ae@65.108.43.113:52656,c5f4a56c4f1ba1cf3d4f8d787eb0f90d9cb963ec@65.109.34.133:61056,8cd0cf98fa86c01796b07d230aa5261e06b1b37d@95.217.206.246:26656,76932bbeb29836c6405329c21358d051ef6e33a3@65.109.65.163:21856,70caf9545f6fd67f2561964b0a69bf36ba6f81d4@5.161.205.63:26656,f6e3f995ba1c3ceed8bd556d9a23d2922d98a9a6@66.172.36.136:14656,0d4220d2bbda711183a8db6f45c26b1541fa0d6a@65.109.116.204:21856
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.althea/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.althea/cosmovisor/genesis/bin
mkdir -p ~/.althea/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/althea ~/.althea/cosmovisor/genesis/bin
```

### Create Service File
Create a `althea.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="althea node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=althea"
Environment="DAEMON_HOME=/home/USER/.althea"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable althea.service

# Start service
sudo service althea start

# Check logs
sudo journalctl -fu althea
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
