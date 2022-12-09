<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/okp4.png">
</p>



# OKP4 Node Installation Guide
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
git clone https://github.com/okp4/okp4d.git
cd okp4d
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
okp4d init MONIKERNAME --chain-id okp4-nemeton
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/okp4/genesis.json --inet4-only
mv genesis.json ~/.okp4d/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=f595a1386d5ca2e0d2cd81d3c6372c3bf84bbd16@65.109.31.114:2280,a49302f8999e5a953ebae431c4dde93479e17155@162.19.71.91:26656,b8330b2cb0b6d6d8751341753386afce9472bac7@89.163.208.12:26656,79d179ea2e1fbdcc0c59a95ab7f1a0c48438a693@65.108.106.131:26706,501ad80236a5ac0d37aafa934c6ec69554ce7205@89.149.218.20:26656,5fbddca54548bf125ee96bb388610fe1206f087f@51.159.66.123:26656,769f74d3bb149216d0ab771d7767bd39585bc027@185.196.21.99:26656,024a57c0bb6d868186b6f627773bf427ec441ab5@65.108.2.41:36656,fff0a8c202befd9459ff93783a0e7756da305fe3@38.242.150.63:16656,2bfd405e8f0f176428e2127f98b5ec53164ae1f0@142.132.149.118:26656,bf5802cfd8688e84ac9a8358a090e99b5b769047@135.181.176.109:53656,dc9a10f2589dd9cb37918ba561e6280a3ba81b76@54.244.24.231:26656,085cf43f463fe477e6198da0108b0ab08c70c8ab@65.108.75.237:6040,803422dc38606dd62017d433e4cbbd65edd6089d@51.15.143.254:26656,dc14197ed45e84ca3afb5428eb04ea3097894d69@88.99.143.105:26656,c0864edb1e36c52dbee47ce38d8b47ec364a9eb9@135.181.24.128:28656,43930c7e1cdcfeadf02b9705aefd9a0a59adc353@148.251.69.216:26656,2e877dac234099023a9237eb2e5a05cfb3893633@144.76.45.59:16656,efc552f1211516d578543fc56afcbfbb77c656bd@5.161.145.101:36656,1b0afc2af49098b5bf6e3c89d7d29ef336c47260@144.76.27.79:60756,de245278be4c3540f0a6a867c4bac83155b4ebac@178.62.30.239:46656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.okp4d/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.okp4d/cosmovisor/genesis/bin
mkdir -p ~/.okp4d/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/okp4d ~/.okp4d/cosmovisor/genesis/bin
```

### Create Service File
Create a `okp4d.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="okp4d node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=okp4d"
Environment="DAEMON_HOME=/home/USER/.okp4d"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable okp4d.service

# Start service
sudo service okp4d start

# Check logs
sudo journalctl -fu okp4d
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.

> Use Ansible script to automate the node installation process

> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
