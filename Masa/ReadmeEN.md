&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>





## Hardware Requirements
### Minimum Hardware Requirements
- CPU: 1 core
- Memory: 2GB RAM
- Disk: 20GB


# Node Installation
Follow the steps below

## Set Variable
```
MASA_NODENAME=<YOUR_NODE_NAME>
```

Save the variable
```
echo "export MASA_NODENAME=$MASA_NODENAME" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Update Packages
```
sudo apt update && sudo apt upgrade -y
```

## Install the requirements
```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu net-tools -y
```

## Go setup
```
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```

## Download and install the library
```
cd $HOME && rm -rf masa-node-v1.0
git clone https://github.com/masa-finance/masa-node-v1.0
cd masa-node-v1.0/src
make all
cp $HOME/masa-node-v1.0/src/build/bin/* /usr/local/bin
```

## Launch the application
```
cd $HOME/masa-node-v1.0
geth --datadir data init ./network/testnet/genesis.json
```

## Add bootnodes
```
cd $HOME
wget https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Masa/bootnodes.txt
MASA_BOOTNODES=$(sed ':a; N; $!ba; s/\n/,/g' bootnodes.txt)
```

## Create Service
```
tee /etc/systemd/system/masad.service > /dev/null <<EOF
[Unit]
Description=MASA
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which geth) \
  --identity ${MASA_NODENAME} \
  --datadir $HOME/masa-node-v1.0/data \
  --bootnodes ${MASA_BOOTNODES} \
  --emitcheckpoints \
  --istanbul.blockperiod 10 \
  --mine \
  --miner.threads 1 \
  --syncmode full \
  --verbosity 5 \
  --networkid 190260 \
  --rpc \
  --rpccorsdomain "*" \
  --rpcvhosts "*" \
  --rpcaddr 127.0.0.1 \
  --rpcport 8545 \
  --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul \
  --port 30300 \
  --maxpeers 50
Restart=on-failure
RestartSec=10
LimitNOFILE=4096
Environment="PRIVATE_CONFIG=ignore"
[Install]
WantedBy=multi-user.target
EOF
```


### Restore Node key (Node Migration... Skip this step if you are installing for the first time)
To restore the table node key put it in _$HOME/table-node-v1.0/data/geth/nodekey_ then restart the service\
Replace "<YOUR_NODE_KEY>" with your node key and run the following command
```
echo <YOUR_NODE_KEY> > $HOME/masa-node-v1.0/data/geth/nodekey
```

## Registration and Getting Started
```
sudo systemctl daemon-reload
sudo systemctl enable masad
sudo systemctl restart masad
```


## Useful commands

### Check the table node logs
Check the status of the blocks:
```
journalctl -u masad -f | grep "new block"
```

### Get table node key
!Please make sure to backup your `nodekey` to a safe place. This is the only way to restore your node!
```
cat $HOME/masa-node-v1.0/data/geth/nodekey
```

### Get table enode id
```
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.nodeInfo.enode | sed 's/^.//;s/.$//'
```

### Restart the service
```
systemctl restart masad.service
```

### Check eth node status
To check the eth node sync status, you must first turn on geth.
```
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc
```

After that you can use below commands in geth (must be from eth.syncing = false and net.peerCount > 0)
```
# node data directory with configurations and switches
admin.datadir
# check if node is connected
net.listening
# show sync status
eth.syncing
# node state (difficulty must equal current block height)
admin.nodeInfo
# show sync percentage
eth.syncing.currentBlock * 100 / eth.syncing.highestBlock
# list of all connected peers (shortlist)
admin.peers.forEach(function(value){console.log(value.network.remoteAddress+"\t"+value.name)})
# list of all connected peers (long list)
admin.peers
# show number of connected peers
net.peerCount
```

_Press CTRL+D to exit_

