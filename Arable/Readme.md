&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/5yr9202.png)

# Arable Protocol Kurulum Rehberi
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

## Arable Protocol Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Arable Protocol fullnode'unuzu birkaç dakika içinde kurabilirsiniz. 
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O ARB.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Arable/ARB && chmod +x ARB.sh && ./ARB.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. 
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
acred status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
acred keys add $ARB_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
acred keys add $ARB_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
acred keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
ARB_WALLET_ADDRESS=$(acred keys show $ARB_WALLET -a)
ARB_VALOPER_ADDRESS=$(acred keys show $ARB_WALLET --bech val -a)
echo 'export ARB_WALLET_ADDRESS='${ARB_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export ARB_VALOPER_ADDRESS='${ARB_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 acre'ye sahip olduğunuzdan (1 acre 1000000 uacre'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
acred query bank balances $ARB_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcı Oluşturma:
```
acred tx staking create-validator \
  --amount 1999000uacre \
  --from $ARB_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(acred tendermint show-validator) \
  --moniker $ARB_NODENAME \
  --chain-id $ARB_ID \
  --fees 250uacre
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu acred -o cat
```

Servisi Başlat:
```
systemctl start acred
```

Servisi Durdur:
```
systemctl stop acred
```

Servisi Yeniden Başlat:
```
systemctl restart acred
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
acred status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
acred status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
acred status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
acred tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
acred keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
acred keys add $ARB_WALLET --recover
```

Cüzdan Silme:
```
acred keys delete $ARB_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
acred query bank balances $ARB_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
acred tx bank send $ARB_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uacre
```

### Oylama
```
acred tx gov vote 1 yes --from $ARB_WALLET --chain-id=$ARB_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
acred tx staking delegate $ARB_VALOPER_ADDRESS 10000000uacre --from=$ARB_WALLET --chain-id=$ARB_ID --gas=auto --fees 250uacre
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
acred tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uacre --from=$ARB_WALLET --chain-id=$ARB_ID --gas=auto --fees 250uacre
```

Tüm ödülleri çek:
```
acred tx distribution withdraw-all-rewards --from=$ARB_WALLET --chain-id=$ARB_ID --gas=auto --fees 250uacre
```

Komisyon ile ödülleri geri çekin:
```
acred tx distribution withdraw-rewards $ARB_VALOPER_ADDRESS --from=$ARB_WALLET --commission --chain-id=$ARB_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
acred tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$ARB_ID \
--from=$ARB_WALLET
```

Hapisten Kurtul(Unjail): 
```
acred tx slashing unjail \
  --broadcast-mode=block \
  --from=$ARB_WALLET \
  --chain-id=$ARB_ID \
  --gas=auto --fees 250uacre
```


Node Tamamen Silmek:
```
sudo systemctl stop acred
sudo systemctl disable acred
sudo rm /etc/systemd/system/acre* -rf
sudo rm $(which acred) -rf
sudo rm $HOME/.acred* -rf
sudo rm $HOME/acrechain -rf
sed -i '/ARB_/d' ~/.bash_profile
```
