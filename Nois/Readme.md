&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/jtwg72s.jpg)

# Nois Kurulum Rehberi
## Donanım Gereksinimleri
Herhangi bir Cosmos-SDK zinciri gibi, donanım gereksinimleri de oldukça mütevazı.

### Minimum Donanım Gereksinimleri
 - 3x CPU; saat hızı ne kadar yüksek olursa o kadar iyi
 - 4GB RAM
 - 80GB Disk
 - Kalıcı İnternet bağlantısı (testnet sırasında trafik minimum 10Mbps olacak - üretim için en az 100Mbps bekleniyor)

### Önerilen Donanım Gereksinimleri
 - 4x CPU; saat hızı ne kadar yüksek olursa o kadar iyi
 - 8GB RAM
 - 200 GB depolama (SSD veya NVME)
 - Kalıcı İnternet bağlantısı (testnet sırasında trafik minimum 10Mbps olacak - üretim için en az 100Mbps bekleniyor)

## Nois Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Nois fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O NOIS.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Nois/NOIS && chmod +x NOIS.sh && ./NOIS.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
noisd status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
noisd keys add $NOIS_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
noisd keys add $NOIS_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
noisd keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
NOIS_WALLET_ADDRESS=$(noisd keys show $NOIS_WALLET -a)
NOIS_VALOPER_ADDRESS=$(noisd keys show $NOIS_WALLET --bech val -a)
echo 'export NOIS_WALLET_ADDRESS='${NOIS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export NOIS_VALOPER_ADDRESS='${NOIS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 nois'ye sahip olduğunuzdan (1 nois 1000000 unois'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
noisd query bank balances $NOIS_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
noisd tx staking create-validator \
  --amount 1999000unois \
  --from $NOIS_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(noisd tendermint show-validator) \
  --moniker $NOIS_NODENAME \
  --chain-id $NOIS_ID \
  --fees 250unois
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu noisd -o cat
```

Servisi Başlat:
```
systemctl start noisd
```

Servisi Durdur:
```
systemctl stop noisd
```

Servisi Yeniden Başlat:
```
systemctl restart noisd
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
noisd status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
noisd status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
noisd status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
noisd tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
noisd keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
noisd keys add $NOIS_WALLET --recover
```

Cüzdan Silme:
```
noisd keys delete $NOIS_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
noisd query bank balances $NOIS_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
noisd tx bank send $NOIS_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000unois
```

### Oylama
```
noisd tx gov vote 1 yes --from $NOIS_WALLET --chain-id=$NOIS_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
noisd tx staking delegate $NOIS_VALOPER_ADDRESS 10000000unois --from=$NOIS_WALLET --chain-id=$NOIS_ID --gas=auto --fees 250unois
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
noisd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000unois --from=$NOIS_WALLET --chain-id=$NOIS_ID --gas=auto --fees 250unois
```

Tüm ödülleri çek:
```
noisd tx distribution withdraw-all-rewards --from=$NOIS_WALLET --chain-id=$NOIS_ID --gas=auto --fees 250unois
```

Komisyon ile ödülleri geri çekin:
```
noisd tx distribution withdraw-rewards $NOIS_VALOPER_ADDRESS --from=$NOIS_WALLET --commission --chain-id=$NOIS_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
noisd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$NOIS_ID \
--from=$NOIS_WALLET
```

Hapisten Kurtul(Unjail):
```
noisd tx slashing unjail \
  --broadcast-mode=block \
  --from=$NOIS_WALLET \
  --chain-id=$NOIS_ID \
  --gas=auto --fees 250unois
```


Node Tamamen Silmek:
```
sudo systemctl stop noisd
sudo systemctl disable noisd
sudo rm /etc/systemd/system/celesnois-app* -rf
sudo rm $(which noisd) -rf
sudo rm $HOME/.celesnois-app* -rf
sudo rm $HOME/core -rf
sed -i '/NOIS_/d' ~/.bash_profile
```
