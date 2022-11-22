<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/joe.png">
</p>

# Joe Kurulum Rehberi
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

## Joe Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Joe fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O JOE.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Joe/JOE && chmod +x JOE.sh && ./JOE.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
joed status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
joed keys add $JOE_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
joed keys add $JOE_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
joed keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
JOE_WALLET_ADDRESS=$(joed keys show $JOE_WALLET -a)
JOE_VALOPER_ADDRESS=$(joed keys show $JOE_WALLET --bech val -a)
echo 'export JOE_WALLET_ADDRESS='${JOE_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export JOE_VALOPER_ADDRESS='${JOE_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 joe'ye sahip olduğunuzdan (1 joe 1000000 ujoe'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
joed query bank balances $JOE_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
joed tx staking create-validator \
  --amount 1999000ujoe \
  --from $JOE_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(joed tendermint show-validator) \
  --moniker $JOE_NODENAME \
  --chain-id $JOE_ID \
  --fees 250ujoe
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu joed -o cat
```

Servisi Başlat:
```
systemctl start joed
```

Servisi Durdur:
```
systemctl stop joed
```

Servisi Yeniden Başlat:
```
systemctl restart joed
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
joed status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
joed status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
joed status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
joed tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
joed keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
joed keys add $JOE_WALLET --recover
```

Cüzdan Silme:
```
joed keys delete $JOE_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
joed query bank balances $JOE_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
joed tx bank send $JOE_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ujoe
```

### Oylama
```
joed tx gov vote 1 yes --from $JOE_WALLET --chain-id=$JOE_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
joed tx staking delegate $JOE_VALOPER_ADDRESS 10000000ujoe --from=$JOE_WALLET --chain-id=$JOE_ID --gas=auto --fees 250ujoe
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
joed tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ujoe --from=$JOE_WALLET --chain-id=$JOE_ID --gas=auto --fees 250ujoe
```

Tüm ödülleri çek:
```
joed tx distribution withdraw-all-rewards --from=$JOE_WALLET --chain-id=$JOE_ID --gas=auto --fees 250ujoe
```

Komisyon ile ödülleri geri çekin:
```
joed tx distribution withdraw-rewards $JOE_VALOPER_ADDRESS --from=$JOE_WALLET --commission --chain-id=$JOE_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
joed tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$JOE_ID \
--from=$JOE_WALLET
```

Hapisten Kurtul(Unjail):
```
joed tx slashing unjail \
  --broadcast-mode=block \
  --from=$JOE_WALLET \
  --chain-id=$JOE_ID \
  --gas=auto --fees 250ujoe
```


Node Tamamen Silmek:
```
sudo systemctl stop joed
sudo systemctl disable joed
sudo rm /etc/systemd/system/joed* -rf
sudo rm $(which joed) -rf
sudo rm $HOME/.joed* -rf
sudo rm $HOME/joe -rf
sed -i '/JOE_/d' ~/.bash_profile
```
