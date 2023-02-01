<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/hypersign.png">
</p>



# Hypersign Node Installation Guide
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
git clone https://github.com/hypersign-protocol/hid-node.git
cd hid-node
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
hypersignd init MONIKERNAME --chain-id hypersign-testnet-sirius
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/hypersign/genesis.json --inet4-only
mv genesis.json ~/.hid-node/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=a4656584cc9f7db480c0595c7be95cd012a7c90d@212.23.222.28:26656,15d2f1bc2bfaa143388465ea115c59e5ce6e77dc@65.109.39.223:26656,d92268c246e02a54103f7098b901b876c88f006e@5.161.130.108:26656,56615e02aa90e35a20a1fc4c46e78bb00956f07b@192.118.76.199:26681,f1e8d741d7437d62c15337e5f7475e139119cf8b@65.108.229.233:31656,17cf1e62f61a01cbbced9985e988e8798f5f0e58@23.121.249.57:26656,0188d0143ea4311923a809bb07ee9ebf13c0c63b@94.130.16.254:60656,bd2ae9f1c42183104719f7c44be078bb7d282a61@65.109.92.241:11056,de1f980cc59bdb2457202768d4b4d964d783789e@167.235.21.165:36656,2aee63582cc0030e444c2c20f3260bfa18cea341@194.146.13.58:26656,d72875380d7b0b68f071623996bd5a86b7491287@116.202.227.117:31656,3990d5a402ca8f9e53441b02e22f4558c5c85fc5@65.108.44.149:27756,70f00c612c1d681a04244749a56f3a35e9be1420@65.108.194.40:28765,a275d8018f683f279bf5167a72d294bfacafa839@178.63.102.172:41656,e7bb31c8fdd8d26a739bfd87cdf3ba7a8f90406e@65.21.145.228:31656,fbc7ce82f02e24257395dc0310ad2921ea61e199@65.109.92.148:61156,1380864bb38481fef4b2358026a5ed53fc027679@95.214.52.206:26656,5c2a752c9b1952dbed075c56c600c3a79b58c395@95.214.52.139:26926,610843eda2f0388cb8e75917e8c1f63350bd3bd1@154.26.131.130:16656,c20f2216b56cb24921b688a6cffc7fe09799a069@162.55.103.44:26656,23eff008c88dcc60ef9a71f2fb469c472679c35e@136.243.88.91:5040,ce6686036f6554deb0490103dcc201172e7c3f2f@81.0.220.131:26656,d7c9b9a3c3a6c5f4ccdfb37a8358755b277271c1@3.110.226.164:26656,2641ddcf28d8adf448edb573de1efba0b6971d9e@178.154.222.128:26656,8e4938aa6561695326f61f432ea2b2a53a428205@95.217.118.96:27161,4e08d5b0cb43c8d5ffc42987a5166bab2a04a93b@65.109.92.240:21066,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:31656,52eee2c34150d621312087e49f118969472ba55f@149.102.137.192:26656,c1b6d86f46eab9d0aa2e4399cddb9cf05d13621a@65.108.206.118:60556,e9bf8e034cfb29658d252f81633ab91e9f28df26@65.109.89.5:27656,d5f7dfff307cefb8e960000caf53b92dd9c58a1d@65.109.28.177:29226,ac25bdc230944cc20f03913a8dae881c9b5f9c18@3.239.45.125:26656,ed12770cba24bfc5ea73d470115067bde00d8291@162.19.70.128:26656,1de2abae74a4c5fd7d96d9869ef02187f81498f0@134.209.238.66:26656,aa8c0064e866dc57b341a389006df8925a0718fe@5.161.55.130:31656,5e4fc955b23ab00f6a07cb6d56e89aafac0c85ff@167.86.85.122:26656,0c6758a3f4554bbc67da73993bbb697764c5c534@38.242.142.227:26656,91089c0911b59f59fe2ec79fdae017f9beefbbfd@65.108.101.158:26656,84408be4e3f13dcd976568d6370e1c50e9eb614d@185.252.232.110:46656,2c0379f78b655e8a386cb477e3cf3cae700c4a7f@213.239.207.175:34656,7ac746f53266043a92a05db06d1306b4e5f7e7c8@65.109.112.20:11014,7d85caec437cc8c0a504d6ab3b18fd07c173b2fb@94.130.219.37:26001,3a9defcd334cefd6b8143ec1ecd8be5e51f1c1c5@95.214.53.46:46656,5a09c55dbbb32b870645f56993e87403dfd17467@162.55.194.205:31656,620478e35ba6740f0afb2a0dd6ca9b34765bc60e@65.109.30.12:60856,7b67ef0b793f09bc1bc76d29aa1503aab8a224ad@88.99.161.162:15656,ec5127072c252f7246fb66f7e7762423a23ff6bd@154.12.228.93:31656,5b4482bfe02384184470070c3d3a4465cf0c18d4@144.91.82.61:31656,5f708c16d745b30a839c9f5b4d378fa10a76edd0@3.145.187.21:26656,55b3cf307182091e60b774712733231a8cc7f448@89.163.132.156:31656,12a8e151b366a5cfe055440e6c2e44236b1c5a38@185.249.227.6:36656,1dae68f061204fe2c10e9476239c0333258889e7@65.109.31.114:2460,f277d5a80e789ce69bb3318dfd5efea45986c073@176.9.22.117:31656,efcb16ec33d8e6233d1068fff679c6fd64bf5802@65.108.225.158:10956,ca474a224fe7eaaefa6d336a205459b33fb30654@3.90.236.173:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.hid-node/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.hid-node/cosmovisor/genesis/bin
mkdir -p ~/.hid-node/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/hid-noded ~/.hid-node/cosmovisor/genesis/bin
```

### Create Service File
Create a `hid-noded.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="hid-noded node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=hid-noded"
Environment="DAEMON_HOME=/home/USER/.hid-node"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable hid-noded.service

# Start service
sudo service hid-noded start

# Check logs
sudo journalctl -fu hid-noded
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
