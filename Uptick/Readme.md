<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/uptick.png">
</p>



# Uptick Node Installation Guide
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
rm -rf uptick
git clone https://github.com/UptickNetwork/uptick.git
cd uptick
git checkout v0.2.4
make build
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
uptickd init MONIKERNAME --chain-id uptick_7000-2
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/uptick/genesis.json --inet4-only
mv genesis.json ~/.uptickd/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=06a01cf2b117792feee0923a6314662c4e407d2b@65.109.68.51:26656,726826d6b019bcf097a53a43a6f9db2a4b01e511@185.252.233.153:26656,6d52facb4924cff15ad42ee6453b1375e4176d15@65.109.104.118:10856,e235147df1089a6d2bec6132af6512cfc859791e@65.21.225.58:27656,86f50af23369997882ca3988eabeba998b4f07cc@65.109.92.79:10656,db09e85b73c4be1cab07f41422912ccad2aa5744@185.198.27.109:15656,b483acbcae7ccd1244f588144245e9d1124c3de5@88.99.56.200:26666,d2787914515fa3aa87847c87d8701c764a73e965@199.175.98.112:26656,d8777278648d8fc93800692a8b96a7f104df4f9a@194.163.135.127:26656,eb5a3112a64944e2bd701ff8aa99ab95209c6310@185.198.27.110:26656,1266d32b49d7472934028ed09454ebae1c7ce09e@65.108.71.80:26656,21ff36b28e4ecf2eee49a711a2ddc8d83e863841@209.126.4.134:31656,7831b5c5cc90fa95ea99a0cea5d1ad07dfcc7b9c@185.245.183.187:26656,34d28eeb7be1b245fd64ba2df4cdf62b5eb60dd3@202.61.240.155:30001,402b733d4d328973670b2a80f83be9c98d2e5568@75.119.130.24:26656,a3b3712dfd366c5c39f6a6b3265c88c4166da86a@161.97.93.245:26661,70c19420bb2d40c5a6c3466c69ead6e0877b9cc7@45.85.250.108:26656,56695e3cbe13a41c03c67670810552d5564a4b30@75.119.130.26:26656,5031d02dd9804714e3055a3eb7d91d18d533783f@194.163.172.19:26656,e5da7ceb59b783f7368743a8913171e263baac57@199.175.98.113:26656,d0938452e1d0fd039232c4247076634a01f601e5@83.171.249.159:31656,07df6fd3f41c4bda761931831439ab248eb3dae4@91.223.3.190:55056,5badbf826e75a2afc216023dd2e7b8ad0eeb9fa6@136.243.88.91:7060,75aa14851ff12bd4825fe5679958dc278086e2b9@95.216.14.72:34656,fb344eb9e5ed4b0dc663a6bc03281a4731489a0a@185.197.194.39:26656,f06b6a57001440bf3507ba2f09a3010f6d50080b@135.181.133.37:29656,9dd656b612b8e6bf15410185414f517ae521c0d6@64.227.112.132:15656,e213d0a9c203c45e8bf89bd2247b1ba1d2b3691b@185.239.208.131:31656,7a4f1c0baa2ff31c02163fb658c4eb8d119193c7@95.214.52.173:26656,61fc7df6cfcbe1403405a8ffe5b48f9b6ee75f28@213.136.86.80:46656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.uptickd/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.uptickd/cosmovisor/genesis/bin
mkdir -p ~/.uptickd/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/uptickd ~/.uptickd/cosmovisor/genesis/bin
```

### Create Service File
Create a `uptickd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="uptickd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=uptickd"
Environment="DAEMON_HOME=/home/USER/.uptickd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable uptickd.service

# Start service
sudo service uptickd start

# Check logs
sudo journalctl -fu uptickd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
