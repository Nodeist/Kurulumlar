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
rm -rf composable-testnet
git clone https://github.com/notional-labs/composable-testnet.git
cd composable-testnet
git checkout v2.3.2
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
banksyd init MONIKERNAME --chain-id banksy-testnet-2
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/composable/genesis.json --inet4-only
mv genesis.json ~/.banksy/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=a8da45683cc35c4743e27eac5e2d33498b7a700d@65.108.225.126:56656,06206d0f5afb5b6d9d1c4efdd9b753da2553fa4f@96.234.160.22:30456,c4c51318e4d9a863c019fb277e5ed6748590e5c6@66.45.233.110:26657,7a4247261bad16289428543538d8e7b0c785b42c@135.181.22.94:26656,1d1b341ee37434cbcf23231d89fa410aeb970341@65.108.206.74:36656,73190b1ec85654eeb7ccdc42538a2bb4a98b2802@194.163.165.176:46656,a03d37eb137b4825da89183c3a1cc85b30541040@195.3.220.169:26656,837d9bf9a4ce4d8fd0e7b0cbe51870a2fa29526a@65.109.85.170:58656,f9cf7b4b1df105e67c632364847a4a00f86aa5c8@93.115.28.169:36656,55809d43e11bd97904a24c380968b414243fa247@65.109.154.182:47656,829fe9bab86000a420d00292c5e83fc1c3961d94@65.108.206.118:60756,085e6b4cf1f1d6f7e2c0b9d06d476d070cbd7929@banksy.sergo.dev:11813,a2041248892180f37fd8e8fe21d7d6b1972efa41@65.21.139.155:32656,b3df58870bc6ff98a88cae66f6eb616198c3b118@144.76.45.59:26656,3c091edbe051f9b0e1bcf46200db163e667a114a@65.108.129.94:26656,d9b5a5910c1cf6b52f79aae4cf97dd83086dfc25@65.108.229.93:27656,8ef48cb0abd32aba27e0b7dea59d625afae99028@65.21.5.205:26656,f42036053761675bc7ad48c4b1510e67254d9e24@65.109.28.226:20656,561b5acc7d6ae8994442855aac6b9a2ea94970d1@5.161.97.184:26656,a117b8ea8b909cb9a62ac0734e0e83787939a298@178.63.52.213:26656,81a92793f2e3266e45d304d5325905e0e587e0b7@65.109.61.113:26656,d0f54e60e10ca4d657b48c9cfc5549fb2a8c7a96@65.109.31.55:26656,18f86a7b2b8233e340b85733b77c649daa2533dc@138.201.59.93:26656,7b8f4a6d2aedf1d300edd447b5020ea174376f03@65.108.231.238:26677,32dfb88dbfae25475202c20adcdcca720f7268c9@65.21.200.161:15956,b3c715e6d140ea5de371db8bab081cb9923f45b2@65.108.78.107:26656,e8ff96b052acfc2cc10458fa163dc733a8328ae1@109.236.86.96:15956,ca63700c8a456548ebeb9859e73e7fc03cfa273b@peer1.apeironnodes.com:44003
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.banksy/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.banksy/cosmovisor/genesis/bin
mkdir -p ~/.banksy/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/banksyd ~/.banksy/cosmovisor/genesis/bin
```

### Create Service File
Create a `banksyd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="banksyd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=banksyd"
Environment="DAEMON_HOME=/home/USER/.banksy"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable banksyd.service

# Start service
sudo service banksyd start

# Check logs
sudo journalctl -fu banksyd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
