&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/mrg089n.jpg)

# Okp4 Kurulum Rehberi
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

## Okp4 Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Okp4 fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O OKP.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Okp4/OKP && chmod +x OKP.sh && ./OKP.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
okp4d status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
okp4d keys add $OKP_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
okp4d keys add $OKP_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
okp4d keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
OKP_WALLET_ADDRESS=$(okp4d keys show $OKP_WALLET -a)
OKP_VALOPER_ADDRESS=$(okp4d keys show $OKP_WALLET --bech val -a)
echo 'export OKP_WALLET_ADDRESS='${OKP_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export OKP_VALOPER_ADDRESS='${OKP_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 know'ye sahip olduğunuzdan (1 know 1000000 uknow'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
okp4d query bank balances $OKP_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
okp4d tx staking create-validator \
  --amount 1999000uknow \
  --from $OKP_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(okp4d tendermint show-validator) \
  --moniker $OKP_NODENAME \
  --chain-id $OKP_ID \
  --fees 250uknow
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu okp4d -o cat
```

Servisi Başlat:
```
systemctl start okp4d
```

Servisi Durdur:
```
systemctl stop okp4d
```

Servisi Yeniden Başlat:
```
systemctl restart okp4d
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
okp4d status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
okp4d status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
okp4d status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
okp4d tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
okp4d keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
okp4d keys add $OKP_WALLET --recover
```

Cüzdan Silme:
```
okp4d keys delete $OKP_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
okp4d query bank balances $OKP_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
okp4d tx bank send $OKP_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uknow
```

### Oylama
```
okp4d tx gov vote 1 yes --from $OKP_WALLET --chain-id=$OKP_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
okp4d tx staking delegate $OKP_VALOPER_ADDRESS 10000000uknow --from=$OKP_WALLET --chain-id=$OKP_ID --gas=auto --fees 250uknow
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
okp4d tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uknow --from=$OKP_WALLET --chain-id=$OKP_ID --gas=auto --fees 250uknow
```

Tüm ödülleri çek:
```
okp4d tx distribution withdraw-all-rewards --from=$OKP_WALLET --chain-id=$OKP_ID --gas=auto --fees 250uknow
```

Komisyon ile ödülleri geri çekin:
```
okp4d tx distribution withdraw-rewards $OKP_VALOPER_ADDRESS --from=$OKP_WALLET --commission --chain-id=$OKP_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
okp4d tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$OKP_ID \
--from=$OKP_WALLET
```

Hapisten Kurtul(Unjail):
```
okp4d tx slashing unjail \
  --broadcast-mode=block \
  --from=$OKP_WALLET \
  --chain-id=$OKP_ID \
  --gas=auto --fees 250uknow
```


Node Tamamen Silmek:
```
sudo systemctl stop okp4d
sudo systemctl disable okp4d
sudo rm /etc/systemd/system/okp4* -rf
sudo rm $(which okp4d) -rf
sudo rm $HOME/.okp4d* -rf
sudo rm $HOME/okp4d -rf
sed -i '/OKP_/d' ~/.bash_profile
```
