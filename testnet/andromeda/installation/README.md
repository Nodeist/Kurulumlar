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
git clone https://github.com/andromedaprotocol/andromedad.git
cd andromedad || return
git checkout galileo-3-v1.1.0-beta1
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
andromedad init MONIKERNAME --chain-id galileo-3
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/andromeda/genesis.json --inet4-only
mv genesis.json ~/.andromedad/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=20248068f368f5d1eda74646d2bfd1fcdaffb3e1@89.58.59.75:60656,f81993a28a2cf0111dfa8b1943daba4691ef3825@45.142.214.163:26656,7ac17e470c16814be55aa02a1611b23a3fba3097@75.119.141.16:26656,064497a6f023caa1e5f1482425576540c22476fb@65.21.133.114:56656,b9836aff6d8e79b9a04b4a2a80d6007bf33a526b@198.244.179.125:32069,bd323d2c7ce260b831d20923d390e4a1623f32c4@213.239.215.195:20095,03603fb96ded3aabe7451efad31fb8d0c523a0ee@146.19.75.97:26656,72bba2142c9cada7e4b8e861fb79e8a66e345d99@95.217.236.79:50656,79d6dc8e8c827280f64164523d1ff02f9fde6f6d@38.242.230.118:26656,cdd5f44252e54bf8ebc4d35f10f1dbc40bb94128@194.163.134.227:26656,3c68a8074d2bfa2e5a4af81c64833871b3fa10f6@38.242.225.219:26656,315f2fa0bffec75bc93e449fd5dc194fe2d707e6@65.109.25.58:15656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.andromedad/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.andromedad/cosmovisor/genesis/bin
mkdir -p ~/.andromedad/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/andromedad ~/.andromedad/cosmovisor/genesis/bin
```

### Create Service File
Create a `andromedad.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="andromedad node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=andromedad"
Environment="DAEMON_HOME=/home/USER/.andromedad"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable andromedad.service

# Start service
sudo service andromedad start

# Check logs
sudo journalctl -fu andromedad
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
