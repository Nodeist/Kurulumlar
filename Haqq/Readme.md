<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/haqq.png">
</p>



# Haqq Node Installation Guide
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
git clone https://github.com/haqq-network/haqq.git
cd haqqd
git checkout v1.3.0
make build
mkdir -p $HOME/.haqqd/cosmovisor/genesis/bin
mv build/haqqd $HOME/.haqqd/cosmovisor/genesis/bin/
rm -rf build
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
haqqd init MONIKERNAME --chain-id haqq_54211-3
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/haqq/genesis.json --inet4-only
mv genesis.json ~/.haqqd/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=6fad54232f11a0306bd0d942c2ec5f9ba0ae2f1a@34.91.54.209:26656,62d44513c7fd5aafa65773e5c015ca032f8eea4a@213.239.213.179:26656,ee4db669ed2ff87cb2a47f848fa061517eb47737@161.97.151.46:26656,56158e0f2acf850114e82644afceb565a73b08cc@185.144.99.95:26656,125063c422e09faf45b849dd73dea61f624db891@65.109.53.60:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:35656,6771e65c1b30cc514faf5943320fdda480fe9124@95.216.39.183:26656,a884387139109784cad9193652b82ef20a85d713@38.242.159.148:26656,23ff658b56fbb8bc73372973a34733ff5d79b435@142.132.202.50:11604,2d13d679b64e1a574904a140f72815644ec71131@65.21.133.125:30656,2fdcd211d7457390cc7de84dc5b87750f1ece442@121.4.161.226:35656,54e81994c61bbb6c414f8ab0a606a7edda138a3b@95.216.154.100:26656,0833039f717227ccd156d156ea772746b8ac6d71@146.19.24.139:26656,1fefb6b75431482502e125a290deba1e7e539d4e@135.181.148.11:26656,927a323649e7dd8d4c75da6e5edaee439652b46f@65.109.92.241:20116,d648d598c34e0e58ec759aa399fe4534021e8401@109.205.180.81:26656,32a8eec046b95e8646ff0810b4596dc7083a0beb@65.108.145.131:26656,8e394150929e74e51fc097023420515ce77f7533@135.181.150.198:26656,9eb507f9365313dbe7f426050fec9648298f58ee@109.205.183.51:26656,064fe9fe19fe5552b2d4922d659466e583f42b22@95.216.2.219:26658,3f11b1e4dd940582ef03f0355959676e684b0370@65.108.87.238:26656,24e894d4d8a18276acf6051cccf369a1ce69842d@65.108.151.105:26656,f54d4de6d4ae81ec8a2315b54247872b315f198d@65.109.57.9:26656,7f2828e3910a4b165a65e5bfb2465c1e809bad3b@65.108.48.182:26656,d59dc597f0d41bcbc7ff53374686affb143726c2@51.195.203.103:35656,3df5a68b919177179c6dcb0b9c9354fd6bbba1c8@65.109.92.240:20116,70c1b8334bf08fe5d56fb53d07da11f01faa560b@65.109.30.90:26656,64a840f6f5344a22a485b2818f9da9a457d42827@95.217.57.232:36656,51e4544568cf880451bfffc292de88adc472f0e0@34.147.126.38:26656,00b1befaceba6b0178d2b6076ae0968adf4bd7b5@65.108.67.152:26656,47a269c3e30f70d8234a2afd8e9055e74129fde0@65.108.129.29:36656,b9d04ade732a3bb91b91e279c36c6f2c12d522d3@109.107.187.78:26656,45bc6d84ffb3bb725cf78e82205639797c30af67@65.108.199.62:26656,d37e2f7b34035937e8ddbdd445c9bf09c131b46a@84.46.242.147:26656,ba56c564a5430632e59e2b08fc348735bc56b32f@154.12.232.140:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.haqqd/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.haqqd/cosmovisor/genesis/bin
mkdir -p ~/.haqqd/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/haqqd ~/.haqqd/cosmovisor/genesis/bin
```

### Create Service File
Create a `haqqd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="haqqd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=haqqd"
Environment="DAEMON_HOME=/home/USER/.haqqd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable haqqd.service

# Start service
sudo service haqqd start

# Check logs
sudo journalctl -fu haqqd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
