&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/qtutnf0.png)

# Gitopia Kurulum Rehberi
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

## Gitopia Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Gitopia fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O GTP.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Gitopia/GTP && chmod +x GTP.sh && ./GTP.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
gitopiad status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
gitopiad keys add $GTP_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
gitopiad keys add $GTP_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
gitopiad keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
GTP_WALLET_ADDRESS=$(gitopiad keys show $GTP_WALLET -a)
GTP_VALOPER_ADDRESS=$(gitopiad keys show $GTP_WALLET --bech val -a)
echo 'export GTP_WALLET_ADDRESS='${GTP_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export GTP_VALOPER_ADDRESS='${GTP_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 tlore'ye sahip olduğunuzdan (1 tlore 1000000 utlore'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
gitopiad query bank balances $GTP_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
gitopiad tx staking create-validator \
  --amount 1999000utlore \
  --from $GTP_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(gitopiad tendermint show-validator) \
  --moniker $GTP_NODENAME \
  --chain-id $GTP_ID \
  --fees 250utlore
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu gitopiad -o cat
```

Servisi Başlat:
```
systemctl start gitopiad
```

Servisi Durdur:
```
systemctl stop gitopiad
```

Servisi Yeniden Başlat:
```
systemctl restart gitopiad
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
gitopiad status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
gitopiad status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
gitopiad status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
gitopiad tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
gitopiad keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
gitopiad keys add $GTP_WALLET --recover
```

Cüzdan Silme:
```
gitopiad keys delete $GTP_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
gitopiad query bank balances $GTP_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
gitopiad tx bank send $GTP_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000utlore
```

### Oylama
```
gitopiad tx gov vote 1 yes --from $GTP_WALLET --chain-id=$GTP_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
gitopiad tx staking delegate $GTP_VALOPER_ADDRESS 10000000utlore --from=$GTP_WALLET --chain-id=$GTP_ID --gas=auto --fees 250utlore
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
gitopiad tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utlore --from=$GTP_WALLET --chain-id=$GTP_ID --gas=auto --fees 250utlore
```

Tüm ödülleri çek:
```
gitopiad tx distribution withdraw-all-rewards --from=$GTP_WALLET --chain-id=$GTP_ID --gas=auto --fees 250utlore
```

Komisyon ile ödülleri geri çekin:
```
gitopiad tx distribution withdraw-rewards $GTP_VALOPER_ADDRESS --from=$GTP_WALLET --commission --chain-id=$GTP_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
gitopiad tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$GTP_ID \
--from=$GTP_WALLET
```

Hapisten Kurtul(Unjail):
```
gitopiad tx slashing unjail \
  --broadcast-mode=block \
  --from=$GTP_WALLET \
  --chain-id=$GTP_ID \
  --gas=auto --fees 250utlore
```


Node Tamamen Silmek:
```
sudo systemctl stop gitopiad
sudo systemctl disable gitopiad
sudo rm /etc/systemd/system/gitopia* -rf
sudo rm $(which gitopiad) -rf
sudo rm $HOME/.gitopia* -rf
sudo rm $HOME/gitopiad -rf
sed -i '/GTP_/d' ~/.bash_profile
```
