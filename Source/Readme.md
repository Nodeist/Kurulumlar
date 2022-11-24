<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/source.png">
</p>

# Source Kurulum Rehberi
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

## Source Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Source fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O SRC.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Source/SRC && chmod +x SRC.sh && ./SRC.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
sourced status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
sourced keys add $SRC_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
sourced keys add $SRC_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
sourced keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
SRC_WALLET_ADDRESS=$(sourced keys show $SRC_WALLET -a)
SRC_VALOPER_ADDRESS=$(sourced keys show $SRC_WALLET --bech val -a)
echo 'export SRC_WALLET_ADDRESS='${SRC_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export SRC_VALOPER_ADDRESS='${SRC_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 source'ye sahip olduğunuzdan (1 source 1000000 usource'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
sourced query bank balances $SRC_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
sourced tx staking create-validator \
  --amount 999750usource \
  --from $SRC_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(sourced tendermint show-validator) \
  --moniker $SRC_NODENAME \
  --chain-id $SRC_ID \
  --fees 250usource
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu sourced -o cat
```

Servisi Başlat:
```
systemctl start sourced
```

Servisi Durdur:
```
systemctl stop sourced
```

Servisi Yeniden Başlat:
```
systemctl restart sourced
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
sourced status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
sourced status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
sourced status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
sourced tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
sourced keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
sourced keys add $SRC_WALLET --recover
```

Cüzdan Silme:
```
sourced keys delete $SRC_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
sourced query bank balances $SRC_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
sourced tx bank send $SRC_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000usource
```

### Oylama
```
sourced tx gov vote 1 yes --from $SRC_WALLET --chain-id=$SRC_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
sourced tx staking delegate $SRC_VALOPER_ADDRESS 10000000usource --from=$SRC_WALLET --chain-id=$SRC_ID --gas=auto --fees 250usource
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
sourced tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000usource --from=$SRC_WALLET --chain-id=$SRC_ID --gas=auto --fees 250usource
```

Tüm ödülleri çek:
```
sourced tx distribution withdraw-all-rewards --from=$SRC_WALLET --chain-id=$SRC_ID --gas=auto --fees 250usource
```

Komisyon ile ödülleri geri çekin:
```
sourced tx distribution withdraw-rewards $SRC_VALOPER_ADDRESS --from=$SRC_WALLET --commission --chain-id=$SRC_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
sourced tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$SRC_ID \
--from=$SRC_WALLET
```

Hapisten Kurtul(Unjail):
```
sourced tx slashing unjail \
  --broadcast-mode=block \
  --from=$SRC_WALLET \
  --chain-id=$SRC_ID \
  --gas=auto --fees 250usource
```


Node Tamamen Silmek:
```
sudo systemctl stop sourced
sudo systemctl disable sourced
sudo rm /etc/systemd/system/sourced* -rf
sudo rm $(which sourced) -rf
sudo rm $HOME/.source* -rf
sudo rm $HOME/source -rf
sed -i '/SRC_/d' ~/.bash_profile
```
