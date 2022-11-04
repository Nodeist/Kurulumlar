&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/odbvf0a.png)

# Loyal Kurulum Rehberi
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

## Loyal Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Loyal fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O LYL.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Loyal/LYL && chmod +x LYL.sh && ./LYL.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
loyald status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
loyald keys add $LYL_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
loyald keys add $LYL_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
loyald keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
LYL_WALLET_ADDRESS=$(loyald keys show $LYL_WALLET -a)
LYL_VALOPER_ADDRESS=$(loyald keys show $LYL_WALLET --bech val -a)
echo 'export LYL_WALLET_ADDRESS='${LYL_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export LYL_VALOPER_ADDRESS='${LYL_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 lyl'ye sahip olduğunuzdan (1 lyl 1000000 ulyl'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
loyald query bank balances $LYL_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
loyald tx staking create-validator \
  --amount 10000000ulyl \
  --from $LYL_WALLET \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --pubkey  $(loyald tendermint show-validator) \
  --moniker $LYL_NODENAME \
  --chain-id $LYL_ID
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu loyald -o cat
```

Servisi Başlat:
```
systemctl start loyald
```

Servisi Durdur:
```
systemctl stop loyald
```

Servisi Yeniden Başlat:
```
systemctl restart loyald
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
loyald status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
loyald status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
loyald status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
loyald tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
loyald keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
loyald keys add $LYL_WALLET --recover
```

Cüzdan Silme:
```
loyald keys delete $LYL_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
loyald query bank balances $LYL_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
loyald tx bank send $LYL_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ulyl
```

### Oylama
```
loyald tx gov vote 1 yes --from $LYL_WALLET --chain-id=$LYL_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
loyald tx staking delegate $LYL_VALOPER_ADDRESS 10000000ulyl --from=$LYL_WALLET --chain-id=$LYL_ID --gas=auto --fees 250ulyl
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
loyald tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ulyl --from=$LYL_WALLET --chain-id=$LYL_ID --gas=auto --fees 250ulyl
```

Tüm ödülleri çek:
```
loyald tx distribution withdraw-all-rewards --from=$LYL_WALLET --chain-id=$LYL_ID --gas=auto --fees 250ulyl
```

Komisyon ile ödülleri geri çekin:
```
loyald tx distribution withdraw-rewards $LYL_VALOPER_ADDRESS --from=$LYL_WALLET --commission --chain-id=$LYL_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
loyald tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$LYL_ID \
--from=$LYL_WALLET
```

Hapisten Kurtul(Unjail):
```
loyald tx slashing unjail \
  --broadcast-mode=block \
  --from=$LYL_WALLET \
  --chain-id=$LYL_ID \
  --gas=auto --fees 250ulyl
```


Node Tamamen Silmek:
```
sudo systemctl stop loyald
sudo systemctl disable loyald
sudo rm /etc/systemd/system/loyald* -rf
sudo rm $(which loyald) -rf
sudo rm $HOME/.loyal* -rf
sudo rm $HOME/loyal* -rf
sed -i '/LYL_/d' ~/.bash_profile
```
