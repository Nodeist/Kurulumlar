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
rm -rf babylon
git clone https://github.com/babylonchain/babylon
cd babylon
git checkout v0.5.0
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
babylond init MONIKERNAME --chain-id bbn-test1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://ss.nodeist.net/t/babylon/genesis.json --inet4-only
mv genesis.json ~/.babylond/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=3118e751541323b0136b8ce6bcae80947d318d27@65.109.92.235:11046,ed9df3c70f5905307867d4817b95a1839fdf1655@154.53.56.176:27656,07d1b69e4dc56d46dabe8f5eb277fcde0c6c9d1e@23.88.5.169:17656,df2d4b4d8f63f690951d0c04c10847065cf2bf8a@194.163.179.176:56656,b531acac8945962606025db892d86bb0bf0872af@3.93.71.208:26656,ae5b89a8f1934e45ad3698671005a56623f04111@213.239.207.165:29056,49cdcda3061fd1b467c6a5c29f56b85653e807f2@94.131.106.139:26656,73dd905cd059cb0057baa6d39876caa079a18d82@5.161.58.198:27656,c2abdd62b87e83d4ca9cf5427e3d9dd71f53cc6d@148.113.159.123:36656,b53302c8887d4bd57799992592a2280987d3f213@95.217.144.107:20656,03ce5e1b5be3c9a81517d415f65378943996c864@18.207.168.204:26656,01ef803d2d738567de7dd67b9b6d965b1d886a1d@65.109.90.171:32656,7d0d910af252f6b1b9e20b5a2a8dfb4c3fed17ef@185.155.97.74:26656,02e343a8fc8ce01c8c71b30a384216151d5fa094@65.109.65.248:32656,5d0bfba725cd3e5c2c77a51ecc191193523b3765@65.108.232.182:14656,2d2f5aaa779adac3b0a77006c883edba7462b90d@51.222.44.116:25656,8092b6641a0e195fe70d890459bafae26988708a@95.216.217.29:26656,561bdb0fa6908e810ecf7a0e52267941420958f4@94.130.55.76:26656,75005719480485c7fc5b22c43606770f251ffffc@188.40.109.171:26656,503bbb5a059465d22fcd4706609f5fd72e69dba3@65.109.70.45:17656,2082756ec14fb59d54893b2ca83f1846996b0989@65.108.66.34:29056,3913a271b4f3ead770f6f5a04b6d1696842662de@107.21.137.127:26656,65a96cc8a0a886ba1741db2c090e95ec159a9e61@95.217.4.153:30656,f4dac6d4da289901dd1747a0ac84c1cf4372c387@185.245.182.152:26656,0059ae5bec12686533c626ba63e17dc366d5ce41@65.21.147.116:26656,7e161f08d04f8b56b405a0b6c2cb8a370ff0f76b@65.108.220.199:26656,1e123b3712346bf8c1db808f7081e2137e420b35@65.108.108.52:27656,f5b7ba66ec45e5f9b136dbb5579e1de871dc6903@80.65.211.160:26656,85526334d76309076bba01f32bd9bd1fddd6b5bd@62.171.184.57:27656,313a058becbacc26b5db08558a5bd3add7dff884@62.171.184.75:27656,adff495feca4c21e33d30e469ea5d88c314ff91e@89.117.56.177:26656,2213579f1af1e3eb653727e0a27a22a0341b5d9e@45.10.154.8:26656,999dbd2c06da98b0f4d5a7e7efa59d6c2ef0d187@34.80.188.152:26656,f8c767fe15270e47b5a609345f51e56c8f82fb4d@46.4.5.45:20656,28fb564ad11fbf41bf9c4ad0cc54bb8a605c82c9@75.119.130.205:26656,42dd05c43fa9e51cfabc6a2ab0afa9044b123cc6@34.201.34.29:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.babylond/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.babylond/cosmovisor/genesis/bin
mkdir -p ~/.babylond/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/babylond ~/.babylond/cosmovisor/genesis/bin
```

### Create Service File
Create a `babylond.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="babylond node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=babylond"
Environment="DAEMON_HOME=/home/USER/.babylond"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable babylond.service

# Start service
sudo service babylond start

# Check logs
sudo journalctl -fu babylond
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://dc.nodeist.net) and let us know.
