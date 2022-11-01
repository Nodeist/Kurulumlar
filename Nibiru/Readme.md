&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/5fsknku.png)

# Nibiru Kurulum Rehberi
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

## Nibiru Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Nibiru fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O NBR.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Nibiru/NBR && chmod +x NBR.sh && ./NBR.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
nibid status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
nibid keys add $NBR_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
nibid keys add $NBR_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
nibid keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
NBR_WALLET_ADDRESS=$(nibid keys show $NBR_WALLET -a)
NBR_VALOPER_ADDRESS=$(nibid keys show $NBR_WALLET --bech val -a)
echo 'export NBR_WALLET_ADDRESS='${NBR_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export NBR_VALOPER_ADDRESS='${NBR_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 nibi'ye sahip olduğunuzdan (1 nibi 1000000 unibi'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
nibid query bank balances $NBR_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
nibid tx staking create-validator \
  --amount 1999000unibi \
  --from $NBR_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(nibid tendermint show-validator) \
  --moniker $NBR_NODENAME \
  --chain-id $NBR_ID \
  --fees 250unibi
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu nibid -o cat
```

Servisi Başlat:
```
systemctl start nibid
```

Servisi Durdur:
```
systemctl stop nibid
```

Servisi Yeniden Başlat:
```
systemctl restart nibid
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
nibid status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
nibid status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
nibid status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
nibid tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
nibid keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
nibid keys add $NBR_WALLET --recover
```

Cüzdan Silme:
```
nibid keys delete $NBR_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
nibid query bank balances $NBR_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
nibid tx bank send $NBR_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000unibi
```

### Oylama
```
nibid tx gov vote 1 yes --from $NBR_WALLET --chain-id=$NBR_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
nibid tx staking delegate $NBR_VALOPER_ADDRESS 10000000unibi --from=$NBR_WALLET --chain-id=$NBR_ID --gas=auto --fees 250unibi
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
nibid tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000unibi --from=$NBR_WALLET --chain-id=$NBR_ID --gas=auto --fees 250unibi
```

Tüm ödülleri çek:
```
nibid tx distribution withdraw-all-rewards --from=$NBR_WALLET --chain-id=$NBR_ID --gas=auto --fees 250unibi
```

Komisyon ile ödülleri geri çekin:
```
nibid tx distribution withdraw-rewards $NBR_VALOPER_ADDRESS --from=$NBR_WALLET --commission --chain-id=$NBR_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
nibid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$NBR_ID \
--from=$NBR_WALLET
```

Hapisten Kurtul(Unjail):
```
nibid tx slashing unjail \
  --broadcast-mode=block \
  --from=$NBR_WALLET \
  --chain-id=$NBR_ID \
  --gas=auto --fees 250unibi
```


Node Tamamen Silmek:
```
sudo systemctl stop nibid
sudo systemctl disable nibid
sudo rm /etc/systemd/system/nibi* -rf
sudo rm $(which nibid) -rf
sudo rm $HOME/.nibid* -rf
sudo rm $HOME/nibiru -rf
sed -i '/NBR_/d' ~/.bash_profile
```
