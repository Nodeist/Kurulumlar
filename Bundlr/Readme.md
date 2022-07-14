<p style="font-size:14px" align="right">
Sağ üst köşeden forklamayı ve yıldız vermeyi unutmayın ;) <br> <img src="https://i.hizliresim.com/njbmdlb.png"/></p>
<p style="font-size:14px" align="center">
<b>Bu sayfa, çeşitli kripto proje sunucularının nasıl çalıştırılacağına ilişkin eğitimler içerir. </b><br><br>
<a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="64"/></a> <br>Telegrama Katıl. <br>
<a href="https://nodeist.net/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="64"/></a> <br>Websitemizi Ziyaret et. 
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
Kurulum yaklaşık 10 dakika sürüyor. bu yüzden bağlantı kesintilerine karşı önlem almak adına öncesinde screen oluşturmanız önerilir.
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

Sonraki ekranda `Open Tweet Pop-up` butonuna tıklayarak bir twit atın ve cüzdanınıza musluktan token alın.

![resim](https://i.hizliresim.com/a7tw0uu.png)

Arweave sitesi musluk konusunda çok titiz ve biraz gıcık. bu yüzden bazen hata verebilir ve token vermeyebilir. 
bu durumda bir hata mesajı alırsınız. 

Böyle bir durum ile karşılaşırsanız attığınız twitteki cüzdan adresinizi kopyalayın ve 
https://bundlr.network/faucet sitesine giderek yapıştırın. ardından tekrar bu siteden twit atın. 

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
```
cd ~/validator-rust && docker-compose up -d
```

Günlükleri Kontrol et:
```
cd ~/validator-rust && docker-compose logs --tail=100 -f
```

Günlüklerin Görüntüsü Şu Şekilde Olmalı:

![resim](https://i.hizliresim.com/cyq2y47.png)

Doğrulayıcıyı ağa kaydedin:
```
npm i -g @bundlr-network/testnet-cli
```

Doğrulayıcıyı Başlatın `ipadresiniz` kısmını düzenleyin:
```
testnet-cli join RkinCLBlY4L5GZFv8gCFcrygTyd5Xm91CzKlR6qxhKA -w wallet.json -u "http://ipadresiniz:80" -s 25000000000000
```

Bütün işlemler başarılı şekilde gerçekleştiğinde aşağıdakine benzer bir mesaj alacaksınız.

![resim](https://i.hizliresim.com/9a8uzrb.png)

*Verdiği keyi yedekleyin...

**Bu kadar...**

Explorer'dan cüzdan adresinizi kontrol edebilirsiniz.
- https://bundlr.network/explorer
