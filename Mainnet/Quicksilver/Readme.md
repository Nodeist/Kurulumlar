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
git clone https://github.com/ingenuity-build/quicksilver
cd quicksilver
git checkout v1.2.2
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
quicksilverd init MONIKERNAME --chain-id quicksilver-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/quicksilver/genesis.json --inet4-only
mv genesis.json ~/.quicksilverd/config
```

### Configure Seeds
Using a seed node to bootstrap is the best practice in our view.
```
PEERS=e50848e299c7909245a9af690341ff27e21f7b69@65.109.49.111:56656,0f941cf7dd4739264cfe2d39618716f7e63f985c@199.217.117.78:26656,12c30eb58feceb7453569767b8b3fbd3b5918777@85.10.198.171:26601,ebc272824924ea1a27ea3183dd0b9ba713494f83@195.3.220.136:27026,5f0c0411e34e1c7d0b9c53749d90a923b5e8c625@65.21.133.125:35656,b4bcce87121963e1e97619dc135f2eb1a9fd5dfc@88.198.32.17:36656,679f56feb7f4f91d46a92d0eb474d1dc43466d18@213.239.215.59:29986,43b97f492bf47b455b7b275c396b1840f4eb336d@142.132.139.101:26656,b71ddbe0702383c73128f759a910a6d55ccee3b6@46.4.112.18:11656,5fa47201aa5208c30982b6f9d8ca44222d256fc5@51.91.70.90:48656,c8b01e6700d048b1aae34d76f5c56511b2a90ab1@57.128.133.24:26656,e09b47db9c221a9d064069befcc471d949d2c28d@45.14.135.159:15620,f644e9f9229ab7c9c70907b134b3b96b18163935@146.19.24.195:22656,8dde859ce090bc669f028edfc69ccdaa973614ea@35.198.192.234:26656,6f7f00cc445627c68435d0c27394afab5fb41919@65.21.200.224:11156,0d92ed4e041916b60a5a2db934e259447d9a0479@65.108.13.185:27262,2b73e89e8b8ff83271665a9766eba76dcd15735f@52.18.210.112:26656,bbb6a02a90ef98975525d9bd7137511e18edddc1@141.95.99.81:26656,96b7605dbf13dbf0df2c3ac4f076397a9f351c6b@88.98.195.228:26656,fbea255c9ac0234eb6ae598e0eb5d84e669b8ce9@65.109.19.177:26656,28ebd43e8c888ed069165fa035e101ae6fd7955e@139.162.191.246:26656,64112911cda67dd6566763c49bddadfee2631bd1@188.165.205.120:11656,a1688942f8e51e3a372bbf0123d4a0326377e5ba@54.37.129.164:48656,e8f43949897a5453433d411a867c7729d3924719@38.242.216.246:19656,0307e98cceb81b5f075ee69f53c0032940dea98c@65.108.43.113:26656,2c658378f5356e39ecea6947eb312f45a8ccfde1@142.132.199.211:26654,0b9833206c8967ac8ac0e1a407bedfe378b1a5f3@5.135.140.46:26656,83af423a1bc0d6696b831e0c29f3f2a7b25f6ab6@95.214.55.46:21609,063cc6b75194c4f943d32c549667ba210a7f2de1@195.3.222.240:26856,1b648ab6e0416303ab1afbe71108b6c23f00b35c@81.0.218.193:26656,5fe7dc208641e3e730867c49b396cc7e248969fc@88.208.34.134:26656,8afd73dde0c073dd290092d8ffbcc48a61c94525@89.117.58.109:46656,2de4190c0e42a04f4cfb962c76ea90bf179a0b84@95.216.46.251:26656,9bd2b7e39fb0d823402f22c90e3000fdf3cd05bf@88.99.104.180:26656,be4ff5b09936e32d9a4f87f5a5118973160d58f2@78.47.214.204:26656,d35e035d7ddca24c7b83667158457e061ca01852@65.109.88.155:14656,65b1a372b38661db4ff450ed03c195a17bbade08@65.109.27.75:46656,e3dd956ac4081ba42ae3d038edd6d80ddf092751@198.199.90.99:26656,58fe3a7b075e7302f8b46b8171a0aa19ff4a427a@65.108.195.29:31126,4aa307d4ce413837a3da019e966d8115fb4c1467@198.244.229.218:26656,6785dbb8a0138600e0e0faaa77baa375451b38bb@162.55.132.48:15620,51070ba609ede6d7eb334b8cf0ed585f2b1ab66b@135.181.76.99:26656,4aa6607f87ad0b458526d3405731e71553cf275c@219.100.163.35:26656,d9f4546f14e94f81c7766542548ee1776f9f66ce@65.108.238.203:43656,0914b21ef0c3b325a82a37e58107d1271f201258@162.55.194.205:11656,ebafaa0d0087ecfc785b095d6a91a67a12eecd80@5.9.100.25:26656,602700ce2ed57b2176514ec2ecbda079caa7a536@178.170.40.28:15620,c0beca70dbd3ef5bb433f7aa280d56d2a150bbd3@95.214.52.144:26656,93593a7315477ecc0d0d072aac87fa7630ab6b2b@95.217.122.80:22656,46a0c8717148c4a4aa86eaaa9727e7bc6bb8e70c@49.12.7.7:26656,3308d9078fcca016fbd8dc8f3b19666326f41a6f@138.201.121.185:26672,d93d33f89477252e0c31702e308a08914a179be9@51.83.184.168:26656,dacf9b208ba4c2d931f107f05694963889cfca0f@149.102.147.182:26656,61d96fee29a9615c208c4db72526d23b45094cb4@65.108.195.30:36656,4fe29b9b138301ecc0906fe909a833952983d277@65.21.89.54:26654,663134c4999f4f9fc59879eaaebbb332e91e2160@45.34.1.114:33656,e0c595bd21c4f08391b5c2a4736d1be9d907133c@65.108.229.102:35656,ef9c9b1952f245fbb24603d5a1f643041bec7af7@141.95.65.26:29986,4de2811fd20d33110daf62223975beccecbe55a0@15.235.114.195:26656,c5f9bcf2422406ddfdc342cde87af5c94a067ed1@89.117.60.247:36656,f73ee3d2450f41bcf1b2975552cdf60a118a64c9@46.4.50.247:11656,d178ae941508840ef4f1f20f0b844768cd9a530a@65.108.137.39:26656,271419d3eb3878c902ebb0064490ad702d9d067f@144.76.145.150:26656,161f453c9ff27f3120ec5078f56b505316fbc720@65.108.6.45:61156,03f8f542594292401d2378cc8dffb8ec92ab9b07@73.129.182.254:26656,6a50176dceb7dcf376280c7ace671878d473f753@144.91.80.32:11656,ef1cb5bff5b76957f02636a30d5d85d861a35dbe@65.109.92.240:21026,71b753819eb653e99e6a825b80af20ca9bccb087@135.125.163.63:24666,ae353518e6009eb48d80ccf6a006a9644e9dd309@146.19.24.101:26656,05241d21ff9e7c699bbdb4faa73da1860b6d8cd7@128.199.85.168:26656,d833117894c10ec4d79460904ac565b7ccbcfa26@65.109.19.176:26656,c401fba248ab17181eaa917a077e9e4fdeefdbcc@65.108.79.198:26696,06230bbaabb6c9c6223275b57d8e10fc609ae7ba@51.89.7.184:26633,2a223e03987c5e4fd8738006dd69cfd5ff7f4ab8@65.109.59.123:26656,176d56747476b21d30e0b5ed356a5955bc5b9cab@141.95.65.73:11156,ee14b4bbeb436056952c8e4e7c84826dfb92143b@65.109.105.17:26656,c7fca1b4d883e7eabe6b6c87db42c47a74b92244@65.109.21.76:26656,0a3860f9d3c27b34910fe8660240ae55699b55c2@84.244.95.245:26656,ee93bb021a0b3ba92129a95230619490fa12c024@164.68.125.243:36656,33720513faaa039977481782e33ffcb8ef67c4b7@95.217.114.220:11656,443ad7c991b2915b620673b10206c92e2b4040e0@173.67.177.120:26656,4a550b5e8bfa7260e6775ea3ebd61f36f1480fa4@65.109.37.58:12656,1be3e5e90749396a3c2a07584a7c07337983d042@95.214.53.46:56656,3bd708547317e9efd8d63d8a51c5bc32d11f4840@138.201.32.103:26656,e64a4e480a2971c339fa06a58293e8e060082ad5@185.16.36.134:26656,162325861a80df7709aeacb1cbb52e033ba6438e@65.109.82.249:31656,d36921a835076f6d87889793eb05a83099617221@202.61.240.122:26666,908a73baeebf599fad2c8a05a6e025eee2ee9ee0@212.23.222.26:36656,b2de28758ab185f46f3701654fcb31d102c28ac3@65.108.65.36:26656,df8881987bf46b76e3f69158fa7bc3a94ac67325@46.4.121.72:26656,52a5771f5c81c056201bf7498b9c9526e4e7fa7a@5.9.147.210:26656,1b569bf57da79df4f85d207a161a97626988af76@65.109.92.241:20026,9bab3f1a766f00a80256593fb6e94339fadfa5e5@65.108.125.236:26616,c83255ae59dc358a9b2cb908058e8affe46eaaff@65.108.193.249:2390,25cb81b62c562532e20aaddb024afc268127facf@77.37.176.99:26656,f3263230b4bd692de6807a83a31594770433d337@62.171.186.160:26656,d6246909abf0c5e82f48ce6f623cba587b899e15@217.160.246.138:26656,2997545ee6e919aa9a9f7bbb8e1933e4c53b3993@188.40.59.225:26656,74e954fba288f0693efca27147d5c6401f2bec60@65.109.21.74:26656,cbc2c7a7cd39750abee0dcd5dd2832feddbde20e@50.21.173.76:26656,8ebd6e7c74a9c36a175f9a86148354b378a4f387@185.248.24.16:26656,83435bc3cbb0204188c666259ccebcd73ac33ec8@65.109.139.182:11656,09f16a08fb0da3a20a7bc0212e3bc4645b04918c@65.21.142.30:28656,072c61dee7f205b237aae0eca698aa4a0639d93e@95.214.54.28:26356,bcbc620d23148bc8c42bfb21fc8bd6d1e779d83f@34.254.255.57:26656,ae3700d3296524014ab3444767df682b46f0cb9e@51.195.234.250:26656,14644178a863ee4f60e31fa96bbe309b8e625577@65.109.21.75:26656,0a6dc6fce2272eb0728c4b871ab8d6ef3f181953@146.59.0.123:6090
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
