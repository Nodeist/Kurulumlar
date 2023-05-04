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
rm -rf elys
git clone https://github.com/elys-network/elys.git
cd elys
git checkout v0.4.0
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
elysd init MONIKERNAME --chain-id elystestnet-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/elys/genesis.json --inet4-only
mv genesis.json ~/.elys/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=0ea4e8352215aad85ff33a20a3bf4acf49070662@64.226.117.34:21956,fed5ba77a69a4e75f44588f794999e9ca0c6b440@45.67.217.22:21956,5f15c422f789fb7c1929f859006d43c27aa61ec0@31.220.84.183:27656,d9f2e28e398d42fe7ca8ed322ee168b3e867bc95@65.108.199.222:34656,5c2a752c9b1952dbed075c56c600c3a79b58c395@178.211.139.77:27296,a346d8325a9c3cd40e32236eb6de031d1a2d895e@95.217.107.96:26156,8dd419e6ed9117dbc793a1a59f7eca3d2c615fb3@65.109.157.236:60556,18842ea01d32c76aa7d1668a734ffbac231f1fe6@81.6.58.121:26656,3f30f68cb08e4dae5dd76c5ce77e6e1a15084346@212.95.51.215:56656,cdf9ae8529aa00e6e6703b28f3dcfdd37e07b27c@37.187.154.66:26656,89c4d6fa66c4e4517742e564cd6ba1532496fd43@65.108.108.52:32656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:15356,78aa6b222ae1f619bef03a9d98cb958dfcccc3a8@46.4.5.45:22056,8aa0021c45a64f736e2192f5e520c768bc9fbae2@46.101.132.190:26656,b06c8ad5bb82d577acd0060242e225980db88377@65.108.225.70:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.elys/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.elys/cosmovisor/genesis/bin
mkdir -p ~/.elys/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/elysd ~/.elys/cosmovisor/genesis/bin
```

### Create Service File
Create a `elysd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="elysd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=elysd"
Environment="DAEMON_HOME=/home/USER/.elys"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable elysd.service

# Start service
sudo service elysd start

# Check logs
sudo journalctl -fu elysd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
