&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/vedwvya.png)

# Haqq Kurulum Rehberi
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

## Haqq Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Haqq fullnode'unuzu birkaç dakika içinde kurabilirsiniz. 
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O HAQ.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Haqq/HAQQ && chmod +x HAQ.sh && ./HAQ.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. 
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
haqqd status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
haqqd keys add $HAQQ_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
haqqd keys add $HAQQ_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
haqqd keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
HAQQ_WALLET_ADDRESS=$(haqqd keys show $HAQQ_WALLET -a)
HAQQ_VALOPER_ADDRESS=$(haqqd keys show $HAQQ_WALLET --bech val -a)
echo 'export HAQQ_WALLET_ADDRESS='${HAQQ_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export HAQQ_VALOPER_ADDRESS='${HAQQ_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 ISLM'ye sahip olduğunuzdan (1 ISLM 1000000 aISLM'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
haqqd query bank balances $HAQQ_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcı Oluşturma:
```
haqqd tx staking create-validator \
  --amount 999968499995832000aISLM \
  --from $HAQQ_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(haqqd tendermint show-validator) \
  --moniker $HAQQ_NODENAME \
  --chain-id $HAQQ_ID \
  --fees 250aISLM
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu haqqd -o cat
```

Servisi Başlat:
```
systemctl start haqqd
```

Servisi Durdur:
```
systemctl stop haqqd
```

Servisi Yeniden Başlat:
```
systemctl restart haqqd
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
haqqd status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
haqqd status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
haqqd status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
haqqd tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
haqqd keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
haqqd keys add $HAQQ_WALLET --recover
```

Cüzdan Silme:
```
haqqd keys delete $HAQQ_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
haqqd query bank balances $HAQQ_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
haqqd tx bank send $HAQQ_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000aISLM
```

### Oylama
```
haqqd tx gov vote 1 yes --from $HAQQ_WALLET --chain-id=$HAQQ_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
haqqd tx staking delegate $HAQQ_VALOPER_ADDRESS 10000000aISLM --from=$HAQQ_WALLET --chain-id=$HAQQ_ID --gas=auto --fees 250aISLM
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
haqqd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000aISLM --from=$HAQQ_WALLET --chain-id=$HAQQ_ID --gas=auto --fees 250aISLM
```

Tüm ödülleri çek:
```
haqqd tx distribution withdraw-all-rewards --from=$HAQQ_WALLET --chain-id=$HAQQ_ID --gas=auto --fees 250aISLM
```

Komisyon ile ödülleri geri çekin:
```
haqqd tx distribution withdraw-rewards $HAQQ_VALOPER_ADDRESS --from=$HAQQ_WALLET --commission --chain-id=$HAQQ_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
haqqd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$HAQQ_ID \
--from=$HAQQ_WALLET
```

Hapisten Kurtul(Unjail): 
```
haqqd tx slashing unjail \
  --broadcast-mode=block \
  --from=$HAQQ_WALLET \
  --chain-id=$HAQQ_ID \
  --gas=auto --fees 250aISLM
```


Node Tamamen Silmek:
```
sudo systemctl stop haqqd
sudo systemctl disable haqqd
sudo rm /etc/systemd/system/haqqd* -rf
sudo rm $(which haqqd) -rf
sudo rm $HOME/.haqqd* -rf
sudo rm $HOME/haqq -rf
sed -i '/HAQQ_/d' ~/.bash_profile
```
