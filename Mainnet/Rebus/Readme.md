<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/rebus.png">
</p>



# Rebus Node Installation Guide
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
git clone https://github.com/rebuschain/rebus.core.git
cd rebus
git checkout v0.2.3
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
rebusd init MONIKERNAME --chain-id reb_1111-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/rebus/genesis.json --inet4-only
mv genesis.json ~/.rebusd/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=9be95ccf0086b96b707115b7707ea73420b11b6b@159.223.152.53:26656,3a3e7123b9ae814b8d8517b6635d21b9ae45bf25@195.3.222.148:26656,d28516746773bfaeca4efa5537c0bf5990b8828e@65.21.229.33:27656,7197d316935ca7b7ac36da7d4a3a6df16cd286a7@93.170.72.118:26656,87102b5dd22c1d17f97197c078f23726ae3c6214@tinyo.fi:26656,b9b70240be5b970a4939ddd5cc9a45ff4be6c292@198.244.167.164:26656,9289288c444b781a18f13c69da42b99424442cbb@65.108.44.149:21656,4ef77b2a17e71d2535b3c8ec11830708fc299705@209.222.98.90:26656,c301abd7abe536d7791eb139599a68ecaab4ffbc@65.108.6.121:26656,dda7abe32cc84a722cf6b1d2ee3b61ebe7ad71df@135.181.212.183:21656,07b84cf4b47a2e5ad251267716fe05bcf30330cd@65.21.170.3:29656,b4941d0929595b9f83d190559e1d7126fec91cb0@172.96.161.94:26656,ce8b36056ace01414fa7a92e43eaa5bfd8705dd4@138.201.141.76:26656,89ded0a3987d22e46b756fead439e2a4d25f23cb@185.144.99.30:26656,62859ddc0485dbb37b7442135b8d468c4b2222b3@65.108.132.239:36656,eeca453e3a1cf670c78e2255b8f0bd5a9443c30b@65.108.225.71:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.rebusd/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.rebusd/cosmovisor/genesis/bin
mkdir -p ~/.rebusd/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/rebusd ~/.rebusd/cosmovisor/genesis/bin
```

### Create Service File
Create a `rebusd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="rebusd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=rebusd"
Environment="DAEMON_HOME=/home/USER/.rebusd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable rebusd.service

# Start service
sudo service rebusd start

# Check logs
sudo journalctl -fu rebusd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
