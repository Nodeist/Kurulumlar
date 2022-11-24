<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/androma.png">
</p>

# Androma Kurulum Rehberi
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

## Androma Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Androma fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O AM.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Andromeda/AM && chmod +x AM.sh && ./AM.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
andromad status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
andromad keys add $AM_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
andromad keys add $AM_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
andromad keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
AM_WALLET_ADDRESS=$(andromad keys show $AM_WALLET -a)
AM_VALOPER_ADDRESS=$(andromad keys show $AM_WALLET --bech val -a)
echo 'export AM_WALLET_ADDRESS='${AM_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export AM_VALOPER_ADDRESS='${AM_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 andr'ye sahip olduğunuzdan (1 andr 1000000 uandr'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
andromad query bank balances $AM_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
andromad tx staking create-validator \
  --amount 1999000uandr \
  --from $AM_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(andromad tendermint show-validator) \
  --moniker $AM_NODENAME \
  --chain-id $AM_ID \
  --fees 250uandr
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu andromad -o cat
```

Servisi Başlat:
```
systemctl start andromad
```

Servisi Durdur:
```
systemctl stop andromad
```

Servisi Yeniden Başlat:
```
systemctl restart andromad
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
andromad status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
andromad status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
andromad status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
andromad tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
andromad keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
andromad keys add $AM_WALLET --recover
```

Cüzdan Silme:
```
andromad keys delete $AM_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
andromad query bank balances $AM_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
andromad tx bank send $AM_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uandr
```

### Oylama
```
andromad tx gov vote 1 yes --from $AM_WALLET --chain-id=$AM_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
andromad tx staking delegate $AM_VALOPER_ADDRESS 10000000uandr --from=$AM_WALLET --chain-id=$AM_ID --gas=auto --fees 250uandr
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
andromad tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uandr --from=$AM_WALLET --chain-id=$AM_ID --gas=auto --fees 250uandr
```

Tüm ödülleri çek:
```
andromad tx distribution withdraw-all-rewards --from=$AM_WALLET --chain-id=$AM_ID --gas=auto --fees 250uandr
```

Komisyon ile ödülleri geri çekin:
```
andromad tx distribution withdraw-rewards $AM_VALOPER_ADDRESS --from=$AM_WALLET --commission --chain-id=$AM_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
andromad tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$AM_ID \
--from=$AM_WALLET
```

Hapisten Kurtul(Unjail):
```
andromad tx slashing unjail \
  --broadcast-mode=block \
  --from=$AM_WALLET \
  --chain-id=$AM_ID \
  --gas=auto --fees 250uandr
```


Node Tamamen Silmek:
```
sudo systemctl stop andromad
sudo systemctl disable andromad
sudo rm /etc/systemd/system/androma* -rf
sudo rm $(which andromad) -rf
sudo rm $HOME/.androma* -rf
sudo rm $HOME/testnet -rf
sed -i '/AM_/d' ~/.bash_profile
```
