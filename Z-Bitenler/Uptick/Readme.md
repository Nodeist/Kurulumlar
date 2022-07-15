<p style="font-size:14px" align="right">
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>



<p align="center">
  <img height="100" src="https://i.hizliresim.com/nro1l6b.jpeg">
</p>

# Uptick Kurulum Rehberi
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

## Uptick Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Uptick fullnode'unuzu birkaç dakika içinde kurabilirsiniz. 
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O UPTICK.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Z-Bitenler/Uptick/UPTICK && chmod +x UPTICK.sh && ./UPTICK.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. 
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
uptickd status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
uptickd keys add $WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
uptickd keys add $WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
uptickd keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
UPTICK_WALLET_ADDRESS=$(uptickd keys show $WALLET -a)
UPTICK_VALOPER_ADDRESS=$(uptickd keys show $WALLET --bech val -a)
echo 'export UPTICK_WALLET_ADDRESS='${UPTICK_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export UPTICK_VALOPER_ADDRESS='${UPTICK_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 qck'ye sahip olduğunuzdan (1 qck 1000000 auptick'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
uptickd query bank balances $UPTICK_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcı Oluşturma:
```
uptickd tx staking create-validator \
  --amount 1999000auptick \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(uptickd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $UPTICK_ID \
  --fees 250auptick
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu uptickd -o cat
```

Servisi Başlat:
```
systemctl start uptickd
```

Servisi Durdur:
```
systemctl stop uptickd
```

Servisi Yeniden Başlat:
```
systemctl restart uptickd
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
uptickd status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
uptickd status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
uptickd status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
uptickd tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
uptickd keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
uptickd keys add $WALLET --recover
```

Cüzdan Silme:
```
uptickd keys delete $WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
uptickd query bank balances $UPTICK_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
uptickd tx bank send $UPTICK_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000auptick
```

### Oylama
```
uptickd tx gov vote 1 yes --from $WALLET --chain-id=$UPTICK_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
uptickd tx staking delegate $UPTICK_VALOPER_ADDRESS 10000000auptick --from=$WALLET --chain-id=$UPTICK_ID --gas=auto --fees 250auptick
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
uptickd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000auptick --from=$WALLET --chain-id=$UPTICK_ID --gas=auto --fees 250auptick
```

Tüm ödülleri çek:
```
uptickd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$UPTICK_ID --gas=auto --fees 250auptick
```

Komisyon ile ödülleri geri çekin:
```
uptickd tx distribution withdraw-rewards $UPTICK_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$UPTICK_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
seid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$UPTICK_ID \
--from=$WALLET
```

Hapisten Kurtul(Unjail): 
```
uptickd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$UPTICK_ID \
  --gas=auto --fees 250auptick
```


Node Tamamen Silmek:
```
sudo systemctl stop uptickd
sudo systemctl disable uptickd
sudo rm /etc/systemd/system/uptick* -rf
sudo rm $(which uptickd) -rf
sudo rm $HOME/.uptickd* -rf
sudo rm $HOME/uptick -rf
sed -i '/UPTICK_/d' ~/.bash_profile
```
