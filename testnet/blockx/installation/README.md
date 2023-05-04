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
curl -LO https://github.com/defi-ventures/blockx-node-public-compiled/releases/download/v9.0.0/blockxd
chmod +x blockxd
mv blockxd $HOME/go/bin/blockxd
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
blockxd init MONIKERNAME --chain-id blockx_12345-2
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/blockx/genesis.json --inet4-only
mv genesis.json ~/.blockxd/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=78dd8371dae4f081e76a32f9b5e90037737a341a@162.19.239.112:26656,3ecc98a3af5d672fc2ca188e8462604ae5d39062@65.21.225.10:49656,85270df0f25f8a3c56884a5f7bfe0a02b49d13d7@193.34.213.6:26656,544b02ceacb0edcc043c7534db8516c20e25f12e@38.146.3.205:21456,dccf886659c4afcb0cd4895ccd9f2804c7e7e1cd@143.198.101.61:26656,49a5a62543f5fec60db42b00d9ebe192c3185e15@143.198.97.96:26656,4a7401f7d6daa39d331196d8cc179a4dcb11b5f9@143.198.110.221:26656,d1771238066b86ede263dacb0e4e54cdf11df19b@131.153.142.181:26656,48546d0a95fdcd88c9f1f399494a67c933a354b9@109.205.61.151:26656,5270135fcd396733582caf8708434d8bbf6cdf3f@74.208.115.223:21256,cdf456fbe774e55aa794eeaa5280a78f1cf0738b@65.108.66.34:26656,9406c6184876b0678e7c5a705899437791a80ed7@136.243.88.91:7130,895b004f4d1ff0c353cb1bbc0a08e2ab13effccf@94.16.117.238:22656,fa3cc9935503c3e8179b1eef1c1fde20e3354ca3@51.159.172.34:26656,1ee1c4f88faeaaae11b9640a2cb6401c11b210d7@141.94.193.12:26656,15ae817291a37b966da62aa5291f4a0bbe029b3f@116.202.85.52:2936,979876b4e2cb608cfd6cb2213b96e5668a7945d5@23.111.174.202:22606,d00711319c7ea918e0bc5922be812f8b58e7f775@65.108.208.155:26656,f6afbe45c799b57fe5c8e5cf2c4fd87023417b50@65.109.154.182:30656,0b406405e7d73d312efec1e086b60e61e99e5f3f@165.232.77.196:26656,52d2e003b90451ad7594d3ff70c14e2f2f27d0c7@188.166.248.94:21256,6f0c9dd5863d613ebb9d897b7e8b6d8738fecf29@4.193.55.49:26656,2786d942f440d22d8c286b35eb359f7c026585cb@38.242.207.201:26656,810a1d2a57cd61b18cfd6fe2c80aee5851aa0cae@165.22.61.253:21256,bc5f4519749ddaf1206ab53e240364b448f36896@65.109.83.24:21256,6b01445d44bbf9de7b895cc1a5245df33e6cebea@37.252.184.231:26656,c5b7f96ac776034107a7f7a546a2c065de081c09@89.58.19.91:26656,772042fa1777c77a6d0349c034396db420da836f@65.109.28.226:07656,14cad9ecd2b421c9035e52e5d779fbe84bddd134@65.109.82.112:2936,3fcb893cfc75546f3ffae9f8e81a230072639249@65.108.206.74:19656,9c0271251221769180e94759a63d2eff50c7b81e@178.128.113.251:21256
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.blockxd/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.blockxd/cosmovisor/genesis/bin
mkdir -p ~/.blockxd/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/blockxd ~/.blockxd/cosmovisor/genesis/bin
```

### Create Service File
Create a `blockxd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="blockxd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=blockxd"
Environment="DAEMON_HOME=/home/USER/.blockxd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable blockxd.service

# Start service
sudo service blockxd start

# Check logs
sudo journalctl -fu blockxd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
