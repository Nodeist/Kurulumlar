<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/mars.png">
</p>



# Mars Node Installation Guide
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
git clone https://github.com/mars-protocol/hub.git
cd hub
git checkout v1.0.0
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
marsd init MONIKERNAME --chain-id mars-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/mars/genesis.json --inet4-only
mv genesis.json ~/.mars/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=c46be592341987eae20ac681cb08d2abcc02ab9a@137.74.4.20:2000,e61f11c5b03400d3a99c066f951ed0888a2b64af@65.108.238.103:18556,5759fc5bb262806e619ef017e24c8443218afe92@195.201.83.242:45656,969af6a39a0f7e8a17b92d90888360ad92248626@65.108.132.107:2000,8bb6ec79bc116c36c1271a2f5c14cd6c1e1b812f@65.109.92.240:26656,1616af7456f519a0f2360adcad45d4bb9d39c92d@146.59.85.222:26656,1892755333d2cc6f7ba97bda1b1c709ad4ab69cd@50.21.173.82:26656,463f8be52fc3e0f1fe28cd0ec95bd726d85682ec@135.181.18.112:55556,be494851610016cff8853796a99c3ad46d8d1b5b@65.108.76.242:36095,d0dbb50a474888b8bed04bf8a23ac6b8bae443ee@5.79.79.80:18095,76969af1bccdd4dcc511741b171c3d4ccb837ba6@146.59.85.223:18556,59bb909c57664fafe88bf1b6924769c15a769ba4@65.108.125.236:3000,41caa4106f68977e3a5123e56f57934a2d34a1c1@95.214.53.233:27056,c0e6bf4193accabc14171ce163e704dcec5ea5df@51.91.215.170:36095,271593a440c65d6f224e852cb7ae65dd6863bc3a@74.50.94.66:56656,5ffee90e41903f6fba29dc75446d536a02d626fe@65.108.232.150:18095,7f4be5f7db9b920e965197b65974f0e1e64749e4@144.126.128.128:26656,be7d56127ef887d095b2f55f09be5fee1969d922@146.59.52.48:18095,b88814bddfccd85289d7201bfd6fc6c4b3342ab2@178.162.165.193:36095,2707fa9064faa355fc98795361c2d9a3fa7514fc@185.232.69.25:26656,7fa2f4bdbacaf4569621dc76b3e4df4c13b8710e@65.109.71.250:22656,386920074c1f2f14899106b4678b4b4617074033@51.79.72.176:26656,34d071205daccd65787b7346694d7acc671a88c8@146.59.81.92:42656,d2a2c21754be65ad4a4f1de1f6163f681a6e8af8@192.99.44.79:18556,4db44ebd58fed67d2a22ce06a395ce489415f498@5.75.197.137:26650,ebc272824924ea1a27ea3183dd0b9ba713494f83@185.16.39.137:27056,750935ac3bd1fda19f5bc3783d8108c27ceb10b9@66.85.151.226:36656,07dd4b754950bb6c5bf4f5c63d288eea3ef3d982@194.113.106.81:26656,376de67ee4184eb4c35e5024a0a093cf3e6eaf09@93.115.25.106:42656,63f6703a58ee4d9235e78d961408869af25a8f83@65.109.31.114:2500,ead869bce5e03c5512ceb99540e445e0bc639019@65.108.231.83:51656,120a44a50f702717c259319caa2447c77621865f@3.39.103.198:26656,cc4c66d271f9ba9b8d22f8cd22da648f48280748@176.9.76.180:26656,2a82b9592fc5d54d99999e58a2ab1592ce29cbcc@80.254.8.54:26656,c16d8f6760aa4b9a09ce4dcbd74482e80e87de84@65.108.97.58:2866,c06b9689397667fa060d8c3458dd391962d89be2@116.202.36.240:18556,3e3f68fdd8a290345e07cb95479c9a510be5d72f@65.109.35.42:38656,38edf28452ebc41f661d91b6613563c864f4c72e@35.228.114.46:26656,6cbdee8a3fd9dc83b8296275c96e5372dbc3b143@148.113.159.123:26656,7b4b8cf9ddce15e7648de0c3253d728120c9c183@159.65.124.206:26656,52de8a7e2ad3da459961f633e50f64bf597c7585@167.99.133.187:443,575b6dc8a57d4a742bb0ed77934203f1b347f3f1@185.246.84.42:7240,04c687dea43de3f30df5672b30b061789a0cf8e8@144.202.72.17:26606,905157b5cc774bb0ebbc79c040bead1adf5df58b@131.153.203.225:26656,d9bfa29e0cf9c4ce0cc9c26d98e5d97228f93b0b@65.109.88.38:45656,0c7a6911cfa419fd32c203551ea9d69f6f6fe332@51.91.144.243:26656,694e1c11d773a5505fb01daa16a48ddfa27be9ff@5.199.170.92:42656,9c0c747a44919d645f74354fbe095337630b9eee@37.252.184.228:26656,9ab42d56b7cfd78eeed997b276dc7aec27374e42@65.109.52.156:10656,1450c401a8536b1064e1e1e244706399c1858f35@208.102.87.76:26656,2a66b2b518d908c91b734ac6bad07ae68e1553ba@141.94.171.61:26656,ce27e5731b1f79e6c04457b2f59202ad600204ab@3.131.44.92:26656,7a9560de3e7df9d4e193d512b3a9e23e13f18e4a@141.95.154.21:26656,50bd832d75f943767fd1d8309c136df2b4c65207@185.182.184.200:56656,22610d69d1fd5e40c8eed7e7eb3ba9872f1c4502@161.97.64.180:27656,9110db7a7bc670e132e22217fda9a6832edd98d5@23.88.5.169:37656,d524ab7c11a8704b0084a92ab8ed1abba1333d80@141.95.33.158:26650,14528e72319ffb16ab8d945308f688ce03a93e53@216.151.183.112:26656,4903220ef96de95b98badaa0755d60b777a75c8a@144.76.175.189:18556,bd2b7d058dc608328f821ef1ad2b8442d6763376@81.0.220.94:24656,f70ee212c0b3b60e0e8411ec1b978c7826f220a2@85.190.254.14:27656,58854afdcf953f0317d3e120331eff23c2264fbb@178.208.86.48:12656,530b1964bc17bca6457311f1c2d5a2f3d25b297a@51.81.155.97:18556,e32d9d4c09332266eeaa299774dc1f57836d33b9@65.108.135.212:58656,782305759c4ce42f4a22ba9cea6b3c2bbbe5c6b7@65.108.78.29:26656,081effcdbd305b7b9b87b33462fa1204ae607c96@148.251.53.110:7240,8253a88226cb44161f0f7eddb8aa0f022a0cf861@65.108.109.240:3000,230c8b615ab3d0a92c88c765cded171338199edd@51.210.240.201:18556,ced9f0d84104ce5fad53e91548ed9f7f16599d10@176.9.22.117:54656,e26ac62d4b4339bd8863c59027583c1f9a085675@185.225.232.196:22656,7a6e1490d4b2d32b7e37d1e1cb35e143d2492517@51.79.159.79:16656,5bc312415704f3d57bc2a1856c736668737dfb5e@164.92.192.38:26656,f301f4ba2c863573c093bcd9fa68f2b1060bcae3@142.44.240.156:26656,93d3f6f319ea5feac947e1b0886c2756223f9b9d@162.19.57.180:26776,908c3aed1c30c72c760e3ed717b1099fd1e82dbb@103.180.28.216:26656,8fd890ffe05fd220c2fbacce374413b0f5ea23f5@157.245.193.9:20656,4bb23cd7c856f8e92c52f1ab38ab05c4bc24529f@87.106.112.86:26656,f7126202172055ff4440e53c468146d3589c37ac@162.55.245.219:45656,000f20c009ef4fbae24cde350340c66d203d3fee@65.109.92.148:61356,47585f7012cfbc2ed4ea2cf4bbae5123942ccfa6@164.92.128.39:26656,1193253f91a64aa3980df627d20f620c4cbb5ec5@34.83.213.40:26656,055b1458344b74e1705812e23af570d41e1e4bdf@80.64.208.175:26656,84f821d36d45cc0cdaa4ff05297e888bb0d9de8f@85.237.193.111:26656,66fbae56ce70f466194883bb4962a5778916439a@185.188.250.24:45656,305d93229a89ae46265ef08536aa962d4a0dee67@65.108.131.18:26656,d933a425e567c28b4695acbbf0d6cfa6c68cf0c5@65.108.72.156:26656,931f46cc338f59222c22565e216a16f57bbb9782@95.217.164.44:26656,0110304370d093657ac121ea86b7c31eff81f4cc@144.76.97.251:33656,49ab32e3917a2bd99888e74ddf814b255c68b8f1@143.198.107.196:45656,894d4d9dd0df037afaef0f871ad14cd2dced2d33@65.108.238.61:23656,e37baa8dbea5676d4c7f0064c5fb5f0b45780c3a@51.81.107.95:18556,6bdc1a9e0ee642b6559c41371d4fbb5c403857d7@34.223.131.56:26656,9088bab4c4afb96f624fb42ba2ebd963aa4c34a1@15.235.115.147:10004,d10e5704f3c8e9dd6ef42445e4b88bb57d0a8289@65.108.8.247:18556,ca5a76c51bbbc57f839e6ed08953d3926eaa6e5b@34.159.53.53:26656,eebeaed5f9c4dea4b9ec653f895324899cab5715@35.196.35.236:51656,fc6878d5e076fd7baa6c444f7642e011e79d3571@65.108.201.167:38656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.mars/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.mars/cosmovisor/genesis/bin
mkdir -p ~/.mars/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/marsd ~/.mars/cosmovisor/genesis/bin
```

### Create Service File
Create a `marsd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="marsd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=marsd"
Environment="DAEMON_HOME=/home/USER/.mars"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable marsd.service

# Start service
sudo service marsd start

# Check logs
sudo journalctl -fu marsd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
