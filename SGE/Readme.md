<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/sge.png">
</p>

# SGE Kurulum Rehberi
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

## SGE Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak SGE fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O SGE.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/SGE/SGE && chmod +x SGE.sh && ./SGE.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
sged status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
sged keys add $SGE_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
sged keys add $SGE_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
sged keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
SGE_WALLET_ADDRESS=$(sged keys show $SGE_WALLET -a)
SGE_VALOPER_ADDRESS=$(sged keys show $SGE_WALLET --bech val -a)
echo 'export SGE_WALLET_ADDRESS='${SGE_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export SGE_VALOPER_ADDRESS='${SGE_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 sge'ye sahip olduğunuzdan (1 sge 1000000 usge'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
sged query bank balances $SGE_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
sged tx staking create-validator \
  --amount 1999000usge \
  --from $SGE_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(sged tendermint show-validator) \
  --moniker $SGE_NODENAME \
  --chain-id $SGE_ID \
  --fees 250usge
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu sged -o cat
```

Servisi Başlat:
```
systemctl start sged
```

Servisi Durdur:
```
systemctl stop sged
```

Servisi Yeniden Başlat:
```
systemctl restart sged
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
sged status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
sged status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
sged status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
sged tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
sged keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
sged keys add $SGE_WALLET --recover
```

Cüzdan Silme:
```
sged keys delete $SGE_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
sged query bank balances $SGE_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
sged tx bank send $SGE_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000usge
```

### Oylama
```
sged tx gov vote 1 yes --from $SGE_WALLET --chain-id=$SGE_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
sged tx staking delegate $SGE_VALOPER_ADDRESS 10000000usge --from=$SGE_WALLET --chain-id=$SGE_ID --gas=auto --fees 250usge
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
sged tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000usge --from=$SGE_WALLET --chain-id=$SGE_ID --gas=auto --fees 250usge
```

Tüm ödülleri çek:
```
sged tx distribution withdraw-all-rewards --from=$SGE_WALLET --chain-id=$SGE_ID --gas=auto --fees 250usge
```

Komisyon ile ödülleri geri çekin:
```
sged tx distribution withdraw-rewards $SGE_VALOPER_ADDRESS --from=$SGE_WALLET --commission --chain-id=$SGE_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
sged tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$SGE_ID \
--from=$SGE_WALLET
```

Hapisten Kurtul(Unjail):
```
sged tx slashing unjail \
  --broadcast-mode=block \
  --from=$SGE_WALLET \
  --chain-id=$SGE_ID \
  --gas=auto --fees 250usge
```


Node Tamamen Silmek:
```
sudo systemctl stop sged
sudo systemctl disable sged
sudo rm /etc/systemd/system/sge* -rf
sudo rm $(which sged) -rf
sudo rm $HOME/.sge* -rf
sudo rm $HOME/sge -rf
sed -i '/SGE_/d' ~/.bash_profile
```
