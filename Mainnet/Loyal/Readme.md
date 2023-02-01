<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/loyal.png">
</p>



# Loyal Node Installation Guide
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
git clone https://github.com/LoyalLabs/loyal.git
cd loyal
git checkout v0.25.3
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
loyald init MONIKERNAME --chain-id loyal-main-02
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/loyal/genesis.json --inet4-only
mv genesis.json ~/.loyal/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=c145da9f8b6c729287b42b1b3bcb6ca69e1a644e@54.80.32.192:27656,3708cc20a9715b360a019e87428d71ada431c282@192.99.44.79:17856,56088c15a3dd5cdf4c9bd6cd617b3ac9354209d2@202.61.245.42:26656,041c09adfd15ccffcca848ade600e29e46cad2c9@57.128.86.200:26656,437a4572f9cbcb169f1e86d73ce6d647054d03b3@65.108.8.247:17856,6065a96375db58789d4f7a471705e03e7dd22b01@94.130.240.229:4000,fe2a1be061cd0dbb05b8ee796cdfef577c9f2772@138.201.121.185:26676,d46e5a825b5a472307f94625f449445035efac1e@85.190.246.157:26656,44b08595ad0601efcf5149176390a6c2411950f7@54.165.150.1:27656,7f58a71ca87d868ff258aaab62c81ba41b0fbe85@3.139.87.133:26656,9a1c3be0e46d946950b23fd341ea0c81f7dcc504@51.250.29.146:26656,6e191d5fdd8916992b21180687fbb14c243aa949@38.146.3.137:17256,74e809b5b542a4cfe062fc9dc7f79f64508322f9@209.145.56.176:26656,7af8a92cd72af976adedb8e2621e4c9e60dc085a@95.214.52.174:46656,aa164f282b566c1597d8805bd58401be1c62271a@65.109.112.36:30656,a951c97c7dd522f41d3d0e49032bbc11ea5037b1@209.18.90.20:27656,8df50c7dfb9a8a89312a58d05a52fae767262451@185.119.118.118:4000,37393b914e60ca66827bacff92e515f7a5b2bfb5@192.118.76.122:26656,a74dad2ce31a5590fcd1d225c0a8c39eaa86c36d@65.108.97.58:2566
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.loyal/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.loyal/cosmovisor/genesis/bin
mkdir -p ~/.loyal/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/loyald ~/.loyal/cosmovisor/genesis/bin
```

### Create Service File
Create a `loyald.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="loyald node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=loyald"
Environment="DAEMON_HOME=/home/USER/.loyal"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable loyald.service

# Start service
sudo service loyald start

# Check logs
sudo journalctl -fu loyald
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
