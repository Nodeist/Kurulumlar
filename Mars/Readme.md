<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/mars.png">
</p>



# Mars Node Installation Guide
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
git clone https://github.com/mars-protocol/hub.git
cd hub
git checkout v1.0.0-rc7
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
marsd init MONIKERNAME --chain-id ares-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/mars/genesis.json --inet4-only
mv genesis.json ~/.mars/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=b60d9649dd154c169dcf08f47af7c1528c159818@104.248.41.168,7342199e80976b052d8506cc5a56d1f9a1cbb486@65.21.89.54:65.21.89.54:26653,719cf7e8f7640a48c782599475d4866b401f2d34@51.254.197.170,9847d03c789d9c87e84611ebc3d6df0e6123c0cc@91.194.30.203,cec7501f438e2700573cdd9d45e7fb5116ba74b9@176.9.51.55,fe8d614aa5899a97c11d0601ef50c3e7ce17d57b@65.108.233.109,e12bc490096d1b5f4026980f05a118c82e81df2a@85.17.6.142,6bf4d284761f63d9c609deb1cb37d74d43b6aca7@207.180.253.242,8f50c04195cc82d0da34e33cfeb0daa694b14479@65.108.105.48
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.mars/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.mars/cosmovisor/genesis/bin
mkdir -p ~/.mars/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/marsd ~/.mars/cosmovisor/genesis/bin
```

### Create Service File
Create a `marsd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="marsd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=marsd"
Environment="DAEMON_HOME=/home/USER/.mars"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable marsd.service

# Start service
sudo service marsd start

# Check logs
sudo journalctl -fu marsd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
