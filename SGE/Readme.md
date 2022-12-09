<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/sge.png">
</p>



# SGE Node Installation Guide
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
git clone https://github.com/sge-network/sge  
cd sge
git checkout v0.0.3
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
sged init MONIKERNAME --chain-id sge-testnet-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/sge/genesis.json --inet4-only
mv genesis.json ~/.sge/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=27f0b281ea7f4c3db01fdb9f4cf7cc910ad240a6@209.34.206.44:26656,5f3196f370fa865bfd3e4a0653dc7853f613aba6@[2a01:4f9:1a:a718::10]:26656,afa90de6a195a4a2993b2501f12a1cd306f01d02@136.243.103.32:60856,dc75f5d2f9458767f39f62bd7eab3f499fdf2761@104.248.236.171:26656,1168931936c638e92ea6d93e2271b3fe5faee6d1@51.91.145.100:26656,8a7d722dba88326ee69fcc23b5b2ac93e36d7ff2@65.108.225.158:17756,445506c736895336e36dd4f8228a60c257b30e61@20.12.75.0:26656,971643c5b9f9d279cfb7ac1b14accd109231236b@65.108.15.170:26656,788bb7ee73c023f70c41360e9014544b12fe23f9@3.15.209.96:26656,26f0965f8cd53f2b3adc26f8ca5e893929b66c15@52.44.14.245:26656,4a3f59e30cde63d00aed8c3d15bef46b34ec2c7f@50.19.180.153:26656,31d742df5a427e241d1a6b1b22813c9cb4888c07@65.21.181.169:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.sge/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.sge/cosmovisor/genesis/bin
mkdir -p ~/.sge/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/sged ~/.sge/cosmovisor/genesis/bin
```

### Create Service File
Create a `sged.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="sged node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=sged"
Environment="DAEMON_HOME=/home/USER/.sge"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable sged.service

# Start service
sudo service sged start

# Check logs
sudo journalctl -fu sged
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.

> Use Ansible script to automate the node installation process

> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
