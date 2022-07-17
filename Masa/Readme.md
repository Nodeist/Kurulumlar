<p style="font-size:14px" align="right">
 100$ Free VPS for 2 Month <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
<a href="https://discord.gg/ypx7mJ6Zzb" target="_blank"><img src="https://cdn.logojoy.com/wp-content/uploads/20210422095037/discord-mascot.png" width="30"/></a><br> Discord'a Katıl <br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et <br>
</p>


## Donanım Gereksinimleri
### Minimum Donanım Gereksinimleri
- CPU: 1 çekirdek
- Bellek: 2 GB RAM
- Disk: 20 GB


# Node Kurulumu
Aşağıdaki adımları takip edin 

## Değişken Ayarlayın
```
MASA_NODENAME=<YOUR_NODE_NAME>
```

Değişkeni kaydedin
```
echo "export MASA_NODENAME=$MASA_NODENAME" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Paketleri Güncelleyin
```
sudo apt update && sudo apt upgrade -y
```

## Gereklilikleri yükleyin
```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu net-tools -y
```

## Go kurulumu
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

## Kütüphaneyi indirin ve yükleyin
```
cd $HOME && rm -rf masa-node-v1.0
git clone https://github.com/masa-finance/masa-node-v1.0
cd masa-node-v1.0/src
make all
cp $HOME/masa-node-v1.0/src/build/bin/* /usr/local/bin
```

## Uygulamayı başlat
```
cd $HOME/masa-node-v1.0
geth --datadir data init ./network/testnet/genesis.json
```

## Bootnodes ekle
```
cd $HOME
wget https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Masa/bootnodes.txt
MASA_BOOTNODES=$(sed ':a; N; $!ba; s/\n/,/g' bootnodes.txt)
```

## Servis Oluştur
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


### Düğüm anahtarını geri yükle (Node Taşıma işlemi... İlk defa kuruyorsanız bu adımı atlayın)
Masa düğüm anahtarını geri yüklemek için onu _$HOME/masa-node-v1.0/data/geth/nodekey_ içine yerleştirin ve ardından hizmeti yeniden başlatın\
"<YOUR_NODE_KEY>" öğesini düğüm anahtarınızla değiştirin ve aşağıdaki komutu çalıştırın
```
echo <YOUR_NODE_KEY> > $HOME/masa-node-v1.0/data/geth/nodekey
```

## Kayıt ve Başlama
```
sudo systemctl daemon-reload
sudo systemctl enable masad
sudo systemctl restart masad
```


## Kullanışlı komutlar

### Masa düğüm günlüklerini kontrol edin
Blokların durumunu kontrol et:
```
journalctl -u masad -f | grep "new block"
```

### Masa düğüm anahtarını alın
!Lütfen `düğüm anahtarınızı(Nodekey)` güvenli bir yere yedeklediğinizden emin olun. Düğümünüzü geri yüklemenin tek yolu bu!
```
cat $HOME/masa-node-v1.0/data/geth/nodekey
```

### Masa enode kimliğini alın
```
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.nodeInfo.enode | sed 's/^.//;s/.$//'
```

### Servisi yeniden başlat
```
systemctl restart masad.service
```

### Eth düğüm durumunu kontrol edin
Eth node senkronizasyon durumunu kontrol etmek için öncelikle geth'i açmanız gerekir.
```
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc
```

Bundan sonra geth içinde aşağıdaki komutları kullanabilirsiniz (eth.syncing = false ve net.peerCount > 0'dan olmalıdır)
```
# yapılandırmalar ve anahtarlar içeren düğüm veri dizini
admin.datadir
# düğümün bağlı olup olmadığını kontrol edin
net.listening
# senkronizasyon durumunu göster
eth.syncing
# düğüm durumu (zorluk, mevcut blok yüksekliğine eşit olmalıdır)
admin.nodeInfo
# senkronizasyon yüzdesini göster
eth.syncing.currentBlock * 100 / eth.syncing.highestBlock
# bağlı tüm eşlerin listesi (kısa liste)
admin.peers.forEach(function(value){console.log(value.network.remoteAddress+"\t"+value.name)})
# bağlı tüm eşlerin listesi (uzun liste)
admin.peers
# bağlı eş sayısını göster
net.peerCount
```

_Çıkmak için CTRL+D'ye basın_

