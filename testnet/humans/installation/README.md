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
rm -rf humans
git clone https://github.com/humansdotai/humans
cd humans || return
git checkout v0.2.2
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
humansd init MONIKERNAME --chain-id humans_3000-31
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/humans/genesis.json --inet4-only
mv genesis.json ~/.humansd/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=78dd8371dae4f081e76a32f9b5e90037737a341a@162.19.239.112:26656,9406c6184876b0678e7c5a705899437791a80ed7@136.243.88.91:7130,895b004f4d1ff0c353cb1bbc0a08e2ab13effccf@94.16.117.238:22656,c5b7f96ac776034107a7f7a546a2c065de081c09@89.58.19.91:26656,fa3cc9935503c3e8179b1eef1c1fde20e3354ca3@51.159.172.34:26656,9b3f1541f87cd52abb9cec0ef291bc228247f2a0@91.229.23.155:26656,14cad9ecd2b421c9035e52e5d779fbe84bddd134@65.109.82.112:2936,296c2d0589ada1e97a3959a069e23388877759ed@65.109.156.208:02656,a8502a57d8dedda0e08c6bdb892a64f41309b811@65.108.41.172:28456,cdf456fbe774e55aa794eeaa5280a78f1cf0738b@65.108.66.34:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.humansd/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.humansd/cosmovisor/genesis/bin
mkdir -p ~/.humansd/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/humansd ~/.humansd/cosmovisor/genesis/bin
```

### Create Service File
Create a `humansd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="humansd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=humansd"
Environment="DAEMON_HOME=/home/USER/.humansd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable humansd.service

# Start service
sudo service humansd start

# Check logs
sudo journalctl -fu humansd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
