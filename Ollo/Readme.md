&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/98sn6te.png)

# Ollo Kurulum Rehberi
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

## Ollo Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Ollo fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O OLLO.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Ollo/OLLO && chmod +x OLLO.sh && ./OLLO.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
ollod status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
ollod keys add $OLLO_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
ollod keys add $OLLO_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
ollod keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
OLLO_WALLET_ADDRESS=$(ollod keys show $OLLO_WALLET -a)
OLLO_VALOPER_ADDRESS=$(ollod keys show $OLLO_WALLET --bech val -a)
echo 'export OLLO_WALLET_ADDRESS='${OLLO_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export OLLO_VALOPER_ADDRESS='${OLLO_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 tollo'ye sahip olduğunuzdan (1 tollo 1000000 utollo'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
ollod query bank balances $OLLO_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
ollod tx staking create-validator \
  --amount 1999000utollo \
  --from $OLLO_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(ollod tendermint show-validator) \
  --moniker $OLLO_NODENAME \
  --chain-id $OLLO_ID \
  --fees 250utollo
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu ollod -o cat
```

Servisi Başlat:
```
systemctl start ollod
```

Servisi Durdur:
```
systemctl stop ollod
```

Servisi Yeniden Başlat:
```
systemctl restart ollod
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
ollod status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
ollod status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
ollod status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
ollod tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
ollod keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
ollod keys add $OLLO_WALLET --recover
```

Cüzdan Silme:
```
ollod keys delete $OLLO_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
ollod query bank balances $OLLO_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
ollod tx bank send $OLLO_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000utollo
```

### Oylama
```
ollod tx gov vote 1 yes --from $OLLO_WALLET --chain-id=$OLLO_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
ollod tx staking delegate $OLLO_VALOPER_ADDRESS 10000000utollo --from=$OLLO_WALLET --chain-id=$OLLO_ID --gas=auto --fees 250utollo
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
ollod tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utollo --from=$OLLO_WALLET --chain-id=$OLLO_ID --gas=auto --fees 250utollo
```

Tüm ödülleri çek:
```
ollod tx distribution withdraw-all-rewards --from=$OLLO_WALLET --chain-id=$OLLO_ID --gas=auto --fees 250utollo
```

Komisyon ile ödülleri geri çekin:
```
ollod tx distribution withdraw-rewards $OLLO_VALOPER_ADDRESS --from=$OLLO_WALLET --commission --chain-id=$OLLO_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
ollod tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$OLLO_ID \
--from=$OLLO_WALLET
```

Hapisten Kurtul(Unjail):
```
ollod tx slashing unjail \
  --broadcast-mode=block \
  --from=$OLLO_WALLET \
  --chain-id=$OLLO_ID \
  --gas=auto --fees 250utollo
```


Node Tamamen Silmek:
```
sudo systemctl stop ollod
sudo systemctl disable ollod
sudo rm /etc/systemd/system/ollo* -rf
sudo rm $(which ollod) -rf
sudo rm $HOME/.ollo* -rf
sudo rm $HOME/ollo -rf
sed -i '/OLLO_/d' ~/.bash_profile
```
