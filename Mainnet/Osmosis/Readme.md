<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/osmosis.png">
</p>



# Osmosis Node Installation Guide
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
git clone https://github.com/osmosis-labs/osmosis.git
cd osmosis
git checkout v13.1.2
make install
```

## Configure Node
### Initialize Node
Please replace `MONIKERNAME` with your own moniker.

```
osmosisd init MONIKERNAME --chain-id osmosis-1
```

### Download Genesis
The genesis file link below is Nodeist's mirror download. The best practice is to find the official genesis download link.

```
wget -O genesis.json https://snapshots.nodeist.net/osmosis/genesis.json --inet4-only
mv genesis.json ~/.osmosisd/config
```

### Configure Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.
```
PEERS=bfb67b2ae345955d6bc0991450120669c683386e@149.56.25.66:26656,0431022ccc3d354d92518df2d0ab30149a3d5fd7@202.182.116.179:26656,e0fbdbdce6ec8797412751edd00fbaf114c42fad@34.220.226.204:26656,747d01891a83d6f759d88f9be07159c268b584b0@141.95.65.98:26656,569aac51b04607a18696c63035586816dec85511@157.90.213.235:26656,ca0481d7013194692c586eb78081fa4f298c6ccf@15.223.57.204:26656,d2a4b47f8d2f4130943ef7a38c1c1c80ea4d06fd@199.247.29.239:26656,6945be12a7d357a39b9cfbb0018249b234fc4a15@54.241.143.196:26656,2f5e471d41e03da1f0ae62507ec6280872e493fe@162.19.21.28:26656,6313d95a539368410b18da009d3c3248ba61362d@66.172.36.140:36656,5c5b17f3a61816031cbcacdc65f295dcf53e91f2@74.118.139.213:26656,74e8ba742d8312c250f3237c8c8f3f951c01f9df@95.216.4.104:2003,fd0930fea06876e362e0a92046854ed651f27ac2@45.76.13.41:26656,43785e5ffd8783393ea8094f77efcee5bdbcdce3@78.141.244.18:26656,42745690b41f6a7515c4a87d88efda2e82b55b76@78.46.94.183:26656,47e4075978458bfc382630b2a46aabbbbf7977b2@143.198.234.114:26656,10f328a43a1ac7aeeae7ee34c1127ce6839e4265@15.235.13.139:26656,cb0ad76ff7ec6488073a710e528d893892b9fe56@34.211.158.138:26656,7c5459ea4bbc41aa4d86ffe8126f0651155227c8@85.195.102.127:26656,a72323512ddedf580affb0e0ba0bb32218ae8e6d@34.105.148.8:26656,dc230c6475bdbf3ab64058a37a8de2261b6396eb@74.96.207.58:26822,1876eb08c7e93c965a895177f82c8725f89c0f65@54.214.183.228:26656,e81c3c20833cfb5d652a9c842c9f1c8b1835479d@108.61.190.21:26656,120908ac6e79df7ad48b3954474afeca0401682a@141.94.248.63:26656,94a5f37693ba36617029a47d654460d161678af6@128.0.51.4:26656,94b63fddfc78230f51aeb7ac34b9fb86bd042a77@46.4.53.94:30516,724cef11bbe866269b3d67f7dd5ea539cc4096bf@198.244.164.186:26656,7de231d5c75feb810a9196fa2a3e83e0576c88a9@212.95.53.152:26656,797094953d830f8727f3b5175f2b205df16d5867@45.77.212.231:26656,20913e92e8b9ea2d80ad34edd9b52e97886cf616@54.37.30.181:26656,1528ce3b88d859f2f8c4160d9b155ecea5177a2e@142.132.146.105:26656,a3aa1fee4b42a760d428a9b9d419a8208ed16a49@15.235.53.138:26656,63e4dd6530bf4dc4c2202be256b262a27d661106@146.19.24.108:26656,19f75a1aea4cdf8ce987b3d4e1ef6617eb3604b3@95.214.53.217:26716,8e5051244ada217dc580feb774789ad7eb8b357c@34.135.79.149:26656,31d2c86f7957e2db91297e54c3b0456ea06c2250@173.67.177.115:26656,32d59ad7fe73b60720d86c361b196ac6d345c160@222.252.2.167:26656,0660d18b65340a55514f240dd517282ca286f169@176.9.28.62:26656,f4b811759e55f665180545ad5e1b42573f660861@135.181.181.251:26656,b8450ac06ab8ccac21b21bbbba8ea3751a479291@3.91.196.177:26656,3aca1d4aef423f67a03c7e4923e7b845d48100e7@198.244.200.116:16656,30e9432879d5b0976b88e52120dc12338e40fc33@65.108.108.176:26656,b69e57cd6f796ac5d6efb1a834163365c37cbfa8@78.46.69.29:26656,a94725c67de0d56a02efc235cc3d2203c744c7b0@15.235.14.236:26656,6b1dd134b30aeaeb2f21f33bd2cd0370a2275501@138.68.6.165:26656,6fa8dfdfcdb5169cc569d3317091d60a76b07a62@195.201.242.107:26656,2dda2944be6deab37c6ba82b2cd72b067573ba6f@54.38.45.152:26656,f96947493f1edd08058afaeaef8f5830cc70b8f2@15.204.197.10:26656,a6283307952423c1751431c220d11ed36b61ed84@143.110.237.113:26656,2048e1bc1f020fa210fb475e7a0ec0948919609f@185.217.125.64:26656,ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@135.181.5.219:12556
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.osmosisd/config/config.toml
```

## Launch Node
### Configure Cosmovisor Folder
Create Cosmovisor folders and load the node binary.

```
# Create Cosmovisor Folders
mkdir -p ~/.osmosisd/cosmovisor/genesis/bin
mkdir -p ~/.osmosisd/cosmovisor/upgrades

# Load Node Binary into Cosmovisor Folder
cp ~/go/bin/osmosisd ~/.osmosisd/cosmovisor/genesis/bin
```

### Create Service File
Create a `osmosisd.service` file in the `/etc/systemd/system` folder with the following code snippet. Make sure to replace `USER` with your Linux user name. You need `sudo` previlege to do this step.

```
[Unit]
Description="osmosisd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=osmosisd"
Environment="DAEMON_HOME=/home/USER/.osmosisd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start Node Service
```
# Enable service
sudo systemctl enable osmosisd.service

# Start service
sudo service osmosisd start

# Check logs
sudo journalctl -fu osmosisd
```

# Other Considerations
This installation guide is the bare minimum to get a node started. You should consider the following as you become a more experienced node operator.



> Configure firewall to close most ports while only leaving the p2p port (typically 26656) open

> Use custom ports for each node so you can run multiple nodes on the same server

> If you find a bug in this installation guide, please reach out to our [Discord Server](https://discord.gg/yV2nEunsTY) and let us know.
