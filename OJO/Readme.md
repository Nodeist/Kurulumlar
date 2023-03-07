<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/ojo.png">
</p>



# OJO Node Installation Guide
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
rm -rf ojo
git clone https://github.com/ojo-network/ojo.git
cd ojo
git checkout v0.1.2
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
ojod init MONIKERNAME --chain-id ojo-devnet
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/ojo/genesis.json --inet4-only
mv genesis.json ~/.ojo/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=5af3d50dcc231884f3d3da3e3caecb0deef1dc5b@142.132.134.112:25356,c0ee71c74858b339787320596b805ed631c48ebb@213.133.100.172:27433,affee2f485ca15c68c302ad98e8de41fcd0e71ba@162.19.238.49:26656,fbeb2b37fe139399d7513219e25afd9eb8f81f4f@65.21.170.3:38656,dc19e5d986ea79e70180cfbee7789de9cd79e14e@95.217.57.232:56656,97ff540b57b89dd0b6737eddb92977523dd5a7b3@195.3.221.58:12656,8a8b9a8a58c922a7693715100710697ec69b1478@65.109.92.235:11086,7416a65de3cc548a537dbb8bdf93dbd83fe401d2@78.107.234.44:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.ojo/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.ojo/cosmovisor/genesis/bin
mkdir -p ~/.ojo/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/ojod ~/.ojo/cosmovisor/genesis/bin
```

### Create Service File
Create a `ojod.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="ojod node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=ojod"
Environment="DAEMON_HOME=/home/USER/.ojo"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable ojod.service

# Start service
sudo service ojod start

# Check logs
sudo journalctl -fu ojod
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
