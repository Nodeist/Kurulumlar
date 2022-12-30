<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/terp.png">
</p>



# Terp Node Installation Guide
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
git clone https://github.com/terpnetwork/terp-core.git
cd terp-core
git checkout v0.2.0
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
terpd init MONIKERNAME --chain-id athena-3
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/terp/genesis.json --inet4-only
mv genesis.json ~/.terp/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=5baf972a3c97f9fd7eae5790e72cefeab37509b3@176.126.87.225:26656,43935601c07194c34cd2d0c5f024ebd46e98a67b@65.108.72.233:26356,1207664dbe37130582ab4c3dd65664a25489b42e@161.97.99.134:33656,4d8d1daecd27999d282172de6a008d1af6d636cb@74.119.192.99:26656,c989593c89b511318aa6a0c0d361a7a7f4271f28@65.108.124.172:26656,360c7c554ba16333b5901a2a341e466ad2c1db37@146.19.24.52:33656,e746a1aeee12ba57c72ade8d4ecf4543406dd5a7@65.109.92.241:21316,8441f75ff50ccd2a892e5eafb65e4c2ea34aeac3@95.217.118.96:26757,c88a36db47a5f8dded9cd1eb5a7b1af75e5d9294@217.13.223.167:60656,d2af3d86ee5698037d802567ed930f8d58d89c25@38.242.199.93:16656,c2a177164098b317261d55fb1c946a97e5e35adb@75.119.134.69:30656,58e0efd5dc55d262491d4cb612cb9c1a8bd5fb24@185.229.119.29:26656,5e76a43265dad6321d7b67423792c847edfa5a1a@38.242.202.174:26656,19a2f912fd1e87bba8d5daf7578d438ce17d0f7f@195.201.197.4:33656,72a94e30c526c8664189001b679f5bf68bd996b4@65.108.76.44:11623,da54b5db359447a3b0c649815d5a3fe6a229497e@159.69.155.107:24656,012dbc19c31c99c8a6a074868d5b6e9f57f8e100@67.205.150.113:26656,a35d972b7fdb964e922c4df42befdb0fa8ae2679@185.214.134.154:36656,711df41d7a2e4563590b97d3a562d9eeef648eeb@162.55.194.205:33656,08a0f07da691a2d18d26e35eaa22ec784d1440cd@194.163.164.52:56656,2e4e0f43100b424dc4b27e478acc39bebe32344d@77.37.176.99:55656,9b0c5af3f13fe8ca3d0a89d5752e8f5f9062ce7c@95.216.168.99:60656,ba849fa0a0a77212869b8d166c46543459f212b9@157.90.208.222:26656,2f0f98eb3965cc9949073b1f0e75a5e55be44ed2@65.109.28.177:21856,2708d36546019f74fd7aeb5720ad9cbb409d20ed@164.92.78.170:26656,e343bd1d153fe8aa97383b74f00d5de23768aad3@65.108.131.190:27456,1d482773adfdebe19ee7f96d8950fca9dab2300b@135.181.116.109:36656,4b65472bdc979a4c216620772d5195fdd11ced2f@65.108.238.217:11154,f9d7b883594e651a45e91c49712151bf93322c08@141.95.65.26:29456,394b18ba322e80876824463be71ed21a6878308c@38.242.203.139:26656,daadbd8d2a477071d58874432c368a0f1a740129@38.242.202.234:26656,dd7ce08ca73b46172141894ab535b84af8152c56@38.242.202.200:26656,5d5bdd20b2bb2e4fc844b15ff8f5d640583b8ec8@78.46.23.227:11656,b6b9707de0431e1bec3f7b11e082b1e144c7d792@144.91.82.61:33656,10a6803dc146bdb8eb8e9746f32f6d9ecc15a6e4@91.230.111.209:26656,7e5c0b9384a1b9636f1c670d5dc91ba4721ab1ca@195.201.218.107:36656,51d48be3809bb8907c1ef5f747e53cdd0c9ded1b@65.109.92.79:13656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.terp/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.terp/cosmovisor/genesis/bin
mkdir -p ~/.terp/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/terpd ~/.terp/cosmovisor/genesis/bin
```

### Create Service File
Create a `terpd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="terpd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=terpd"
Environment="DAEMON_HOME=/home/USER/.terp"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable terpd.service

# Start service
sudo service terpd start

# Check logs
sudo journalctl -fu terpd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.

> Use Ansible script to automate the node installation process

> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
