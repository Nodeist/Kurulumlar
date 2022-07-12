<p style="font-size:14px" align="right">
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/nnooddeeiisstt/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/nnooddeeiisstt/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>


<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Massa/1_PPZ1JUC1SIQ6S77Rqb2-Qg.png">
</p>

### Minimum Donanım Gereksinimleri
 - 3x CPU; saat hızı ne kadar yüksek olursa o kadar iyi
 - 4GB RAM
 - 100GB Disk
  
  
### İpuçları
  - Düğümünüzü evde veya diğer Massa düğümlerinin yoğun olmadığı bir lokasyonda çalıştırdığınızda maksimum puana ulaşırsınız.
  - Paylaşımlı bir sunucu kullanıyor iseniz (VPS) internet kullanımı rulo satışına neden olabilir.

## Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak defund node'unuzu birkaç dakika içinde kurabilirsiniz.

```
wget -O Nodeistanone.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Anone/Nodeistanone.sh && chmod +x Nodeistanone.sh && ./Nodeistanone.sh
```

## Kurulum Sonrası Adımlar

Screen oluşturun 
```
screen -S massa
```


Düğümü Çalıştırın. `SIFRE` yazan yere bir şifre belirleyin.
```
cd massa/massa-node

RUST_BACKTRACE=full cargo run --release -- -p SIFRE |& tee logs.txt
```


Screen içinde yeni bir pencere oluşturun.
```
CTRL + A + C 
```


İstemciyi çalıştırın. `SIFRE` yazan yere bir şifre belirleyin.
```
cd massa/massa-client/

cargo run --release -- -p SIFRE
```
*Mantık olarak bir pencerede düğüm diğer pencerede istemci çalıştırıyoruz.*



İstemcinin çalıştığı pencereye gidin ve cüzdan oluşturun. Çıktıda verilen keyleri kaydedin.
```
wallet_generate_secret_key
```


Cüzdanı kontrol edin, cüzdan adresi ve secret keyi yedekleyin.
```
wallet_info
```


Massa discord sunucusundaki testnet-faucet kanalına cüzdan adresinizi yapıştırın.
Bakiyenizi kontrol edin. `Final Balance 100` olmalı.
```
wallet_info
```


Eğer her şey doğruysa roll oluşturun. `cüzdanadresi` kısmını düzenleyin
```
buy_rolls cüzdanadresi 1 0
```


Node'unuzu ağa ekleyin. `secretkey` kısmına az önce wallet info yazarak yedeklediğimiz secretkeyi yazın.
```
node_add_staking_secret_keys secretkey

#örnek
#node_add_staking_secret_keys qwoıeq123981239asdasd
```


Massa discord sunucusuna katılın. testnet-rewards-registration kanalındaki 👍 emojisine tıklayın ve ya kanala bir şeyler yazın.
Bot size özel mesaj gönderecek, bu mesajdan discord id bilginize ulaşacaksınız.

![Nodeist](https://i.hizliresim.com/7w3sntd.png)



Discord id öğrendikten sonra node'unuzun istemci ekranına gelin ve aşağıdaki kodu çalıştırın.
`cüzdanadresi` ve `discordid` kısımlarını düzenleyin.

```
node_testnet_rewards_program_ownership_proof cüzdanadresi discordid
```


Yanıt olarak uzunca bir kod alacaksınız. bu kodu kopyalayın ve az önce size discord'dan özel mesaj atan massa bota gönderin.
Ardından aynı massa bota sunucunuzun ip adresini gönderin. 



Bir kaç saat sonra cüzdanınızı kontrol edin. 
```
wallet_info
```

eğer aşağıdaki resimdeki gibi bir çıktı varsa hazırsınız. 

![Nodeist](https://i.hizliresim.com/tc4s31r.png)



### Faydalı bilgiler
Screenden çıkmak için:
```
ctrl+a+d
```

Screene girmek için:
```
screen -r massa
```

Screende düğüm ve istemci pencereleri arasında gezinmek için:
```
ctrl+a+p

#Alternatif ctrl+a+a
```

Sunucu bağlantınız kesildi ve tekrar bağlandınız. Screene girmek istiyorsunuz ama screen zaten `Attached` gözüküyor. 
Bu durumda sunucunuzu önce `Detached` yapmanız gerekir. Bunun için:
```
screen -d massa
```

Hepsi Bu Kadar!
