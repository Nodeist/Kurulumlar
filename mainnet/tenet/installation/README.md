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
curl -L "https://github.com/tenet-org/tenet-mainnet/releases/download/v11.0.6/tenet-mainnet_11.0.6_Linux_amd64.tar.gz" > tenet.tar.gz && \
    tar -C ./ -vxzf tenet.tar.gz && \
    rm -f tenet.tar.gz  && \
    chmod +x $HOME/bin/tenetd && \
    sudo mv $HOME/bin/tenetd $HOME/go/bin/
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
tenetd init MONIKERNAME --chain-id tenet_1559-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/tenet/genesis.json --inet4-only
mv genesis.json ~/.tenetd/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=f648944b0da4613caca6426064ec740586a74ddc@157.90.36.48:27166,73663dda0862b32b406a1fbc082e7023bd83e25c@176.9.54.69:26656,9e6d9040cd29e16287c66eab64dd1da92c231d95@164.90.188.179:26656,bfac3f303430ffa520f7a7592b95357a47050ba2@209.38.244.11:26656,89757803f40da51678451735445ad40d5b15e059@134.65.192.54:26656,1a2971826f68be094eae5cc4f19c71a11736cb84@172.104.238.109:26656,31f37574cd759bff7789080c4cb01dbb9cffef9a@162.19.234.110:26656,92e8534db088c30c25b320b08c44b8c3d8098722@57.128.96.155:22456,cd45ac92164ceb542b556aa845916fba5df9c3fa@161.35.83.28:26656,9054705b4c58a9ba7853a3e43ee1f0cf900b4bfb@144.126.236.41:26656,f8432cc5094870c96f34a0ebb36ffb0d38a53ad4@164.92.209.223:26656,ca9244bb137b8445be55e871b55d4ec0a2d5749c@174.138.63.156:26656,af771137a0ec5f3699ad09a4c3bedf1603655776@45.33.69.112:26656,99a16873ea23d8262817340c6110f8b44f8294fd@18.188.170.181:31320,6cceba286b498d4a1931f85e35ea0fa433373057@169.155.170.17:26656,79d85e533ed411e5c227ec91ec382560b35855a6@137.184.180.148:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.tenetd/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.tenetd/cosmovisor/genesis/bin
mkdir -p ~/.tenetd/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/tenetd ~/.tenetd/cosmovisor/genesis/bin
```

### Create Service File
Create a `tenetd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="tenetd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=tenetd"
Environment="DAEMON_HOME=/home/USER/.tenetd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable tenetd.service

# Start service
sudo service tenetd start

# Check logs
sudo journalctl -fu tenetd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
