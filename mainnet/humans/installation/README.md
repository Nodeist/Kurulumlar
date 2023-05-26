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
git clone https://github.com/humansdotai/humans.git
cd humans && git checkout tags/v1.0.0
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
humansd init MONIKERNAME --chain-id humans_1089-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/humans/genesis.json --inet4-only
mv genesis.json ~/.humansd/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=6d10dcac248d28e8c445841db51f34f9c26442c2@88.217.142.187:29001,81e49a66b928e3a8ba4ce61e959603b1ecd36d96@89.40.71.226:26656,c28ca17b1bad34a3ee5f0fde7568c73b49741479@65.108.108.54:8888,fbfcef080c6c631b03c6bb2832ae608931b1ce41@136.243.55.237:26656,dbf538cdb0f4d5ae4bd90fe2724b95d75b364ce7@138.3.43.147:26656,f7c4bde2eaeab04aff9872d50d5174472b087114@91.194.30.201:26656,37f2636e526869522131c74f098d507000c71aa0@167.235.115.119:26656,aaf071233f5481d50f20cff0bd0a55e6b3aef948@46.4.112.18:26656,dfccfc9156758de072e7287d442a2d3f00770a98@89.39.106.78:26656,91f91757091dab73f39f32f4502f94408fa79ec7@85.10.211.246:26656,2b882f794ed974031b5b435fbf1a755b668d7529@178.23.126.79:26656,f9344349e8435362bc7f21f67b9b61d2f1d6891b@152.32.174.173:26656,8204f0ddbb462749703a58ad6e4e57c5ea5a3379@193.34.212.99:26656,98274e2dcc6b5520c9818a6fdfcf6bde347f1d70@172.0.1.31:26656,a1ad90f3abf8e2875fb8c11f43498a7a8f63c9ad@139.59.6.61:26656,dc4c999d252b1cf99a341b3e6e752bd173c0fabf@51.89.195.66:28656,1d9face4d74f4d65142fa966b8cd4bb6cb4e8a37@148.113.9.36:26656,025cdc1186815f3f28567b30a1667130f0f6c863@212.47.234.245:26656,f0944423224746e56e51d8761893d20a1b335a79@172.104.108.55:26656,524d635a8b60111ba5e44ca9bea4948d84b5a937@65.109.154.185:30656,521ee99723e7edd9b9b14ada1ed382a14a82b69a@65.109.106.211:26656,f9a289d71b2325ee87e9a358540e64fe97c3cf36@148.113.143.77:26656,c138c2f5362be412ae93b59dd2f529df773fd1a1@116.202.85.52:26656,b05e9018dbe13d5706a6eba13050890865dbe1c2@135.181.208.166:28656,adb426cf95737cd79650749cddd8c881adeeabca@135.181.44.81:26656,32793227512886818e6c13a928ccfd675c0030c3@51.79.82.138:26656,88f612bd4f3f57e3b4b6d9b5ad2bebe69d57450b@77.246.159.0:26656,497886715ac23475f7428bd177b9fa53ff886a8d@167.235.2.246:43957,1f16fe691763a62f262c0d149fae57e22bd2fb47@65.108.126.21:26656,02778d5301e5054ec0ee213902a2ae6f16d03ac8@45.79.208.135:26656,44deaab1264724b6e98ee3882dc2fe19defe033c@135.181.156.110:26656,f913050241ce5fd49ea3783ed21724ad05db7291@65.109.125.235:26656,d48d615723693de93148dd3ef16bbb000a3022cb@44.232.147.30:26656,7fe9fed5e1e07692c332ea38ff4ef5ad2ee0248c@138.201.121.185:26690,20f95f8b8dd32b94b593dc3e8fcf0b0aeb74b85d@94.237.93.65:26656,aad2aadbe97cca1079d983f213ea90805e9fe765@162.55.145.72:46656,9193e655f0581b4acf2e87976ac0b55795359742@167.235.177.226:26656,78040907fb2391c958ffbb5fb170c0c48499da62@10.10.1.135:26656,7ea40560ffd03cfd1fde044427e3410a2aa7a839@65.21.132.27:26656,abd78601b249e56a0d88d8ea361bae8e36cbf804@103.180.28.92:26656,e538c77720999c6d21a2789aebfbffe6e5464d86@104.244.208.243:18456,7d8eea3d6d60c3e60e51b8f55db37e62dc0ec8b4@51.79.77.103:26656,4fc061477e0e08190137145ca8f6629a2564a347@65.108.244.5:12256,2628d82e90f0b58b823fdbc42a1a1629645e2293@51.89.98.102:55686,7889ee17b291451155190d40426e6154be4e1abc@135.181.142.60:15608,9a4c00c2d3bb30204561dbe7d6cb7d1a7ff9880b@65.108.213.235:26656,33f4d6b3a09e5ee651b49b2f6e0eb3294a3adb86@135.181.133.120:26656,250d5926777e735519813157e444f84212fc8290@5.161.216.102:26656,e29d6dab79b5801029bde71d90ffe5d35c7b7424@185.246.87.48:26656,7e0bdd0459f29183c9ec1e62f31f7b678d639452@69.197.23.33:26656
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
