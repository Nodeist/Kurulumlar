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
rm -rf dymension
git clone https://github.com/dymensionxyz/dymension.git
cd dymension || return
git checkout v0.2.0-beta
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
dymd init MONIKERNAME --chain-id 35-c
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/dymension/genesis.json --inet4-only
mv genesis.json ~/.dymension/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=e5226fa166386f9055908194a4942c06b7003ab5@65.108.192.123:42656,adf394846dc942b1fd03f6e310eda60b5eda7848@195.201.197.4:32656,8d5eac1042bac34cddd25d7601789fc03cb3f3a9@168.119.213.113:46656,96ffe4b68c3f97cbeae4b4362634bf1054c7aeeb@142.132.151.99:15658,802b8783727af8094d81f9cb0bf2ad9cc3d32aa0@193.46.243.144:26656,4d2ec1e61d61550fc5bfacc57e971ff9b6181152@135.181.180.29:26656,7f928378eecafe22fe1e93d9f63db181cec3f8a3@145.239.143.76:11256,8f84d324a2d266e612d06db4a793b0d001ee62a0@38.146.3.200:20556,44df333024cebe9b8e8361ac67feaa930ec6dc1f@65.109.85.170:54656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.dymension/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.dymension/cosmovisor/genesis/bin
mkdir -p ~/.dymension/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/dymd ~/.dymension/cosmovisor/genesis/bin
```

### Create Service File
Create a `dymd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="dymd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=dymd"
Environment="DAEMON_HOME=/home/USER/.dymension"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable dymd.service

# Start service
sudo service dymd start

# Check logs
sudo journalctl -fu dymd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
