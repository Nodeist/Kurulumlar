<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/rebus.png">
</p>



# Rebus Node Installation Guide
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
git clone https://github.com/rebuschain/rebus.core.git
cd rebus
git checkout v0.2.3
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
rebusd init MONIKERNAME --chain-id reb_1111-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/rebus/genesis.json --inet4-only
mv genesis.json ~/.rebusd/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=12e6bea6650a53150c01ca3897e4a0b94d6e9d4e@135.181.141.47:26656,275d2614d24c8ac015a7712702fcb99cef67ef67@65.108.124.219:29656,4e3e545e85000045ef44905ab683a5db6f87cdbe@88.198.32.17:37656,05483a7ec0160b17de1ad8e7793c7502e70e5525@146.59.85.223:17256,1fe32d8f09b8715b1e626da17b3ecfe26623b371@176.9.22.117:27656,056d6a61c8a4c5ccb02123d67a013434423f155a@149.102.142.57:26656,69e27ab9b46350654805df3ea8d9ac2f00af4e4c@38.242.244.85:26656,6d8c83cc702365363b829a14efdd414401da369b@23.88.69.167:27565,34e3178b6e0f25451fd690c15fc199d5a9bdfb9b@15.204.197.11:26656,07b84cf4b47a2e5ad251267716fe05bcf30330cd@65.21.170.3:29656,237bfc05da5f8cabee00f148995333f37186d232@164.68.121.101:26656,a3d975c913570ad217d9a3de01a8616ad5ce20f8@142.132.128.137:26656,fa292bfad37826c9da43894b349b1480dff516b5@65.108.99.254:31656,ff7621be29e39e9fdf07f2501e1a217201ca29ee@213.239.207.175:39656,eeca453e3a1cf670c78e2255b8f0bd5a9443c30b@65.108.225.71:26656,e6f1684ed8ed5c586b188bf7088026da4ffdaff6@134.65.193.78:26656,f546370843f92e2415524a7b18f9cd528e2fd706@65.109.55.186:26656,b8137c688096d1abcf56942d335d061f212e6629@62.212.65.138:34656,12703ce9efe6c1171c193dae2e2041a2be610852@65.108.44.149:29656,1fcb45323f9045707c0c344a60d7cb906008cfaf@65.109.80.176:26656,256d9790bf186f5a275790f7fe01e1b8800dcaaf@65.21.88.78:26656,2f6b34ad97c4827dace87436f0299cf89fe0c056@136.243.95.80:46656,b570827e4397512e077028ea7121d3e19eb25bab@85.10.200.221:26656,b5bf2242c981371224e5e9e89d6c265d554c8989@65.21.202.154:21656,a35d28e111c1dcc1e5f3203627b449adfb4425f2@65.109.29.150:21656,c88a9a3d3a41a164f8c1537514665e77ea0b54ac@[2a01:4f9:6b:2e5b::9]:26656,b1b08fe470551dca6d6631fb1bfabb814f6c1aec@54.37.129.164:54556,8f023504e27873141164b6fbf1c4b788ff8d533b@159.69.200.24:26656,5f29f14fe3dd7e1d86caa4d344e67ee81c32255f@65.109.37.228:26656,ae67d4c37632435e0d5f27041f50af20d227bdc2@93.170.72.118:21656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.rebusd/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.rebusd/cosmovisor/genesis/bin
mkdir -p ~/.rebusd/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/rebusd ~/.rebusd/cosmovisor/genesis/bin
```

### Create Service File
Create a `rebusd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="rebusd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=rebusd"
Environment="DAEMON_HOME=/home/USER/.rebusd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable rebusd.service

# Start service
sudo service rebusd start

# Check logs
sudo journalctl -fu rebusd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
