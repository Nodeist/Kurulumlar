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
rm -rf noria
git clone https://github.com/noria-net/noria.git noria
cd noria
git checkout v1.2.0
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
noriad init MONIKERNAME --chain-id oasis-3
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/noria/genesis.json --inet4-only
mv genesis.json ~/.noria/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=8336e98410c1c9b91ef86f13a3254a2b30a1a263@65.108.226.183:22156,e82fb793620a13e989be8b2521e94db988851c3c@165.227.113.152:26656,b55e2db9b3b63fde77462c4f5ce589252c5f45af@51.91.30.173:2009,4d8147a80c46ba21a8a276d55e6993353e03a734@165.22.42.220:26656,38de00b6d88286553eb123d16846190e5c594c59@51.79.30.118:26656,6b00a46b8c79deab378a8c1d5c2a63123b799e46@34.69.0.43:26656,31df60c419e4e5ab122ca17d95419a654729cbb7@102.130.121.211:26656,846731f7097e684efdd6b9446d562228640e2b14@34.27.228.66:26656,bb04cbb3b917efce76a8296a8411f211bad14352@159.203.5.100:26656,c3ee892de5052c2813a7e4968a3ba5c4518455cb@5.170.160.20:26656,aae38d6dd7a997000bd9ac195cb09fc1026f63d8@169.1.84.152:26656,0fbeb25dfdae849be87d96a32050741a77983b13@34.87.180.66:26656,419438c7cb152a88a30d6922a2b2c7077dd4daf5@88.99.3.158:22156,73e5dc6e04a1dd28e5851191eb9dede07f0b38fb@141.94.99.87:14095,ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@176.9.82.221:22156
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.noria/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.noria/cosmovisor/genesis/bin
mkdir -p ~/.noria/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/noriad ~/.noria/cosmovisor/genesis/bin
```

### Create Service File
Create a `noriad.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="noriad node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=noriad"
Environment="DAEMON_HOME=/home/USER/.noria"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable noriad.service

# Start service
sudo service noriad start

# Check logs
sudo journalctl -fu noriad
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
