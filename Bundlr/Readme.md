<p style="font-size:14px" align="right">
 100$ Free VPS for 2 Month <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>

# Bundlr ekibinden uzun zamandır beklenen test ağı başladı.

![resim](https://img2.teletype.in/files/92/35/92352e64-ee62-4cb0-a078-349ecad2b296.jpeg)


Gezgin:
>-  https://bundlr.network/explorer

## Donanım Gereksinimleri
- Bellek: 8 GB RAM
- CPU: 2 Çekirdekli
- Disk: 250 GB SSD Depolama
- Bant Genişliği: İndirme için 1 Gbps/Yükleme için 100 Mbps

## Kurulum adımları: 
Aşağıdaki otomatik komut dosyasını kullanarak Bundlr Node'unuzu birkaç dakika içinde kurabilirsiniz. 
```
wget -O NodeistBundlr.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Bundlr/NodeistBundlr.sh && chmod +x NodeistBundlr.sh && ./NodeistBundlr.sh
```

### Kurulum Sonrası Adımlar
Arweave sitesine gidin ve bir cüzdan oluşturun:
https://faucet.arweave.net/

Siteyi açtığınızda resimdeki gibi bir ekran gelecek onay kutucuğunu işaretleyin ve `Continue` butonuna tıklayın.

![resim](https://i.hizliresim.com/dcsodu9.png)

İkinci ekranda yine onay kutucuğunu işaretleyin ve `Download Wallet` butonuna tıklayın.

![resim](https://i.hizliresim.com/mmypjxp.png)

Sonraki ekranda `Open Tweet Pop-up` butonuna tıklayın twit atmanız için bir pencere açılacak, cüzdan adresiniz orada yazıyor olacak. 
Cüzdan adresinizi kopyalayın. twit atmayın.

![resim](https://i.hizliresim.com/a7tw0uu.png)

Kopyaladığınız cüzdan adresini https://bundlr.network/faucet sitesine giderek yapıştırın. ardından bu siteden twit atın.
Attığınız twitin linkini siteye gelip yapıştırın.

Cüzdanımızı başarıyla bilgisayarımıza indirdik ve musluktan coin'imizi aldık. 

Şimdi yapmamız gereken şey indirdiğimiz cüzdan ismini düzenlemek. 

- indirdiğiniz dosyanın ismi şuna benzer: 
`arweave-key-QeKJ_HaxE....................ejQ.json`

Bu dosyanın ismini `wallet.json` olarak güncelleyin. `VE MUTLAKA YEDEKLEYİN` 

Ardından bu cüzdanı sunucumuzda `validator-rust` klasörünün içine atıyoruz.

Servis dosyamızı oluşturuyoruz 
```
tee $HOME/validator-rust/.env > /dev/null <<EOF
PORT=80
BUNDLER_URL="https://testnet1.bundlr.network"
GW_CONTRACT="RkinCLBlY4L5GZFv8gCFcrygTyd5Xm91CzKlR6qxhKA"
GW_ARWEAVE="https://arweave.testnet1.bundlr.network"
EOF
```


Dockeri Başlat:

Kurulum yaklaşık 10 dakika sürüyor. bu yüzden bağlantı kesintilerine karşı önlem almak adına öncesinde screen oluşturmanız önerilir.
```
cd ~/validator-rust && docker-compose up -d
```

Günlükleri Kontrol et:
```
cd ~/validator-rust && docker-compose logs --tail=100 -f
```

Günlüklerin Görüntüsü Şu Şekilde Olmalı:

![resim](https://i.hizliresim.com/cyq2y47.png)

Doğrulayıcıyı Başlatın:
```
npm i -g @bundlr-network/testnet-cli
```

Doğrulayıcınızı ağa katın. `ipadresiniz` kısmını düzenleyin:
```
testnet-cli join RkinCLBlY4L5GZFv8gCFcrygTyd5Xm91CzKlR6qxhKA -w wallet.json -u "http://ipadresiniz:80" -s 25000000000000
```

Bütün işlemler başarılı şekilde gerçekleştiğinde aşağıdakine benzer bir mesaj alacaksınız.

![resim](https://i.hizliresim.com/9a8uzrb.png)

*Verdiği keyi yedekleyin...

**Bu kadar...**

Explorer'dan cüzdan adresinizi kontrol edebilirsiniz.
- https://bundlr.network/explorer
