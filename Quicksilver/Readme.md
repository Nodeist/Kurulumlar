<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/quicksilver.png">
</p>



# Quicksilver Node Installation Guide
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
rm quicksilver -rf
sudo wget -O quicksilverd https://github.com/ingenuity-build/quicksilver/releases/download/v1.1.0-innuendo/quicksilverd-v1.1.0-innuendo-amd64
mv quicksilverd /usr/local/bin/quicksilverd
sudo chmod +x /usr/local/bin/quicksilverd
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
quicksilverd init MONIKERNAME --chain-id innuendo-5
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/t/quicksilver/genesis.json --inet4-only
mv genesis.json ~/.quicksilverd/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=a37474c1f254cd4b16d924327a755c914e8e7d86@65.109.30.53:26656,74abcb5243d4ffc43de6ad1a288d8e50adcd467e@65.109.80.176:20656,03332cdbc3d354846a18992effbb8c20aa28f52a@65.21.133.125:28656,ca1dc45c25919c5b945f4c52c1e8470755a01225@65.108.44.149:20656,5844010472bac487748336616d450bc9f0cbc57c@65.108.72.175:29656,46f97e49a49694aead28c27be2c19300f509e273@65.108.129.94:26656,e0f0703e9ce343c46e0ec01b19216715e817b358@65.109.85.170:28656,f0621c59ca7cfba98015ae2a47886fc3d9c0020c@94.130.132.227:4020,af8cfa944802a9bd510fc3407950a15e8be86c31@213.239.217.52:30656,8ff8a186fe9cbc70d0f34891fa051f87e561a48b@158.160.0.93:26656,22a393fe9174c29081ad8aeaf14ce01b9a79d8c6@159.203.28.113:26656,4ccdccd18a480f13af85aa798356c1bf856f5c20@88.208.57.200:11656,858ba6bc33a6d13fdd9ddad344d788dcf91cf565@142.132.151.99:15651,0a3ac40a7a4ce35978c4da97be2eb6974bc3c58b@185.252.233.217:46656,3519e61e653db97f5d1c7f1bec9b0072bca4d5fe@144.76.45.59:16656,13564ca7ffcc8fa6bcc6d405c96fe8c724ec17da@88.99.213.25:11656,78acdbabc08231765444b3143a222d433a5157e1@142.132.205.94:15651,bdb93c655989b2c1882339fabb013317066dda56@95.214.52.138:26676,a49d8d304e96350272dca24934b8295bc81d75d2@23.227.200.10:26656,796e72ffc343c187cd5e8397c0c09c0671d228e0@185.16.39.51:26656,6c31ea769b18d7b20b2d738df7778fb9fc3fc380@18.236.225.32:26656,97377c16946f8e1fa69e7c2c6b7feb32c2090f09@116.202.227.117:11656,d4d83e209a2b096859821228ea17475f9a487a48@23.88.0.170:15651,a1ef7f2e44f4be8e041f3a9e58cf58cd24b97e26@51.89.7.235:26650,67224ac7f52eac4db6bb0a8de0bf8fbc5e7e0069@199.204.45.23:10656,e25a748120c9608c1d2a70fafa75178d862b3463@178.18.254.211:10656,9e0604571aa20314c2261d70b7d8823414702715@51.159.141.209:26656,cfbf02b41e7fe78d51abfa93f342afd0687203c0@212.227.151.143:36656,c133c4c0c7034c8c345330f394984ad08092fc14@138.201.17.11:27656,9434d151be05e013cb0f20d27b699c8272ec4c89@65.109.82.111:29656,b06ee574cf0b8641611c709a36b21c103d968c18@162.55.245.219:11656,ee6bae1a6d4a1e07f1e4bc7963cabedc6b73426e@94.130.137.119:26656,cc745e98b4dc9b83c5a74d41f576feda73902dfd@65.109.38.54:20026,2096650d8586b858d3369205f3b46ac4c765bc8e@65.109.53.155:26656,d160a8908b44f2a44ce17e0be1f9056b58993b9c@65.21.139.170:21026,479f22d28d830b4baafc0a25084cd7d4ef014a2e@65.108.71.202:26656,301c795b14f8988d33ec4e602b575a16a0585212@195.14.6.141:26656,7fe3007cba4de49584cbdad9489ffecfc9651c57@65.108.79.246:26673,70c7663dba3b5181f1c3b8c92824dad070771ac6@217.13.223.167:56656,3da9fbcb9ec210ec1c94ebc49f46fad3d3721e77@65.108.136.39:26651,4c24df4acfbaaf22e5f6f3c4d11ecf02e8cc343f@195.3.220.48:26656,ac0c6a8e9e700044226e9ff16b68ab4cbae6fb06@84.46.246.109:2366,2be586e675b0f55c96905cc83496861c64112f44@65.108.99.224:56656,25b8b792bb14e8bfdcdfa163a14710d5645a4eba@148.251.91.77:20656,68dfe1fa8a8c1fb16393e8faa1267adf2ec4573a@51.83.238.159:46656,d40a714c11ea3040495246fa0ba8439fcff8a139@176.9.146.72:11656,025e1a9ba7e536e1db47569b55081f7adf6d2f9e@95.217.83.28:26636,7781c28c240e85474425040f744b501d99120d1d@195.201.108.152:11656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:11656,b9b8bb23e61d53ff3b293485d04ea567ebcd7933@65.108.65.94:26656,a94cf3e93cec8eef6d67c2972e4af5eae1a118b2@65.108.2.27:26656,1c1ca90d704c22844570d57039ccf2e8f58e475d@80.64.208.123:26656,926ce3f8ce4cda6f1a5ee97a937a44f59ff28fbf@65.108.13.176:26656,5c2a752c9b1952dbed075c56c600c3a79b58c395@95.214.55.232:27026,b7ef6800c9ea10adcbff28f5c87d6811b353bbaf@51.195.234.240:26656,dc88be3a0075ce429a423237abe223a9528ce0df@65.108.204.119:31656,343fb9338453c58dbacf722e383cc67f0fdd994a@198.244.203.181:26656,3c48a780b85d248e34e63eca5d44c624f93d09d5@135.181.59.162:11156,a288baa951cbe92b253c01c3936d930af1d56424@5.161.142.236:26656,466d02a6524afcd34eb34000c4575aa45aa73f00@18.220.184.171:26656,1c4274460224753e8080d0efd16c0ed88fe27fc0@51.195.145.103:26656,0551eaa0db7097274410ee27a71672817e314b83@167.235.245.191:26656,87d4e2b90141d5d52ed04387db4a46408c3fd66c@35.228.160.230:26656,e77887903bcfc96612177d342a9ca274897bad3c@51.195.234.250:26656,392a7ec2683e288866c353b7a8ac9ecc4e7b4bfc@142.165.207.19:16656,f6f1e4a0baf856ff7d7f6d12868a201282914314@65.109.89.5:26656,6dac642874132fcb34a67778fa883db973055140@74.96.207.62:26656,66f9d8f52a4637dc9215cdaa8dc2977633e52bbf@157.90.176.184:16656,be637bd74973424c825c14c99b71f652fbabb48e@65.21.123.172:22656,42f87cb55d5fdd222da28023613c66857398c4b8@5.22.223.252:26656,41f7d7004cace7bd1760a5f980a86123700c8f1d@185.146.148.116:26656,1bb8de1360e51ed35f7c9a39d4039bfc51900730@5.9.61.120:11656,c896ef12812a82eea865111c49f226849ad077db@144.76.236.90:26656,c4489720ba051c79f5bb16ae5d81341b0f248e19@34.240.190.194:26656,c9a74cdd754a8ccc9243ac2b245e4caaa78695aa@45.85.147.96:26656,532625a997a6f891405202968607f72afe004f15@202.61.225.157:26666,4097143450786750475dfff254265c064dd3718b@190.15.196.193:11656,a98484ac9cb8235bd6a65cdf7648107e3d14dab4@116.202.231.58:11656,1a178dec165fad14ab1b2fb6832dd092f6ab7a5b@65.109.23.182:21026
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.quicksilverd/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.quicksilverd/cosmovisor/genesis/bin
mkdir -p ~/.quicksilverd/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/quicksilverd ~/.quicksilverd/cosmovisor/genesis/bin
```

### Create Service File
Create a `quicksilverd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="quicksilverd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=quicksilverd"
Environment="DAEMON_HOME=/home/USER/.quicksilverd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable quicksilverd.service

# Start service
sudo service quicksilverd start

# Check logs
sudo journalctl -fu quicksilverd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
