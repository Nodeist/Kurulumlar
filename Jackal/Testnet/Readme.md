<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/jackal.png">
</p>

# Jackal Kurulum Rehberi
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

## Jackal Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Jackal fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O JKL.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Jackal/Testnet/JKL && chmod +x JKL.sh && ./JKL.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
canined status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
canined keys add $JKL_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
canined keys add $JKL_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
canined keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
JKL_WALLET_ADDRESS=$(canined keys show $JKL_WALLET -a)
JKL_VALOPER_ADDRESS=$(canined keys show $JKL_WALLET --bech val -a)
echo 'export JKL_WALLET_ADDRESS='${JKL_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export JKL_VALOPER_ADDRESS='${JKL_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 jkl'ye sahip olduğunuzdan (1 jkl 1000000 ujkl'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
canined query bank balances $JKL_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
canined tx staking create-validator \
  --amount 1999000ujkl \
  --from $JKL_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(canined tendermint show-validator) \
  --moniker $JKL_NODENAME \
  --chain-id $JKL_ID \
  --fees 250ujkl
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu canined -o cat
```

Servisi Başlat:
```
systemctl start canined
```

Servisi Durdur:
```
systemctl stop canined
```

Servisi Yeniden Başlat:
```
systemctl restart canined
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
canined status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
canined status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
canined status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
canined tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
canined keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
canined keys add $JKL_WALLET --recover
```

Cüzdan Silme:
```
canined keys delete $JKL_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
canined query bank balances $JKL_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
canined tx bank send $JKL_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ujkl
```

### Oylama
```
canined tx gov vote 1 yes --from $JKL_WALLET --chain-id=$JKL_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
canined tx staking delegate $JKL_VALOPER_ADDRESS 10000000ujkl --from=$JKL_WALLET --chain-id=$JKL_ID --gas=auto --fees 250ujkl
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
canined tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ujkl --from=$JKL_WALLET --chain-id=$JKL_ID --gas=auto --fees 250ujkl
```

Tüm ödülleri çek:
```
canined tx distribution withdraw-all-rewards --from=$JKL_WALLET --chain-id=$JKL_ID --gas=auto --fees 250ujkl
```

Komisyon ile ödülleri geri çekin:
```
canined tx distribution withdraw-rewards $JKL_VALOPER_ADDRESS --from=$JKL_WALLET --commission --chain-id=$JKL_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
canined tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$JKL_ID \
--from=$JKL_WALLET
```

Hapisten Kurtul(Unjail):
```
canined tx slashing unjail \
  --broadcast-mode=block \
  --from=$JKL_WALLET \
  --chain-id=$JKL_ID \
  --gas=auto --fees 250ujkl
```


Node Tamamen Silmek:
```
sudo systemctl stop canined
sudo systemctl disable canined
sudo rm /etc/systemd/system/canined* -rf
sudo rm $(which canined) -rf
sudo rm $HOME/.canine* -rf
sudo rm $HOME/canine-chain -rf
sed -i '/JKL_/d' ~/.bash_profile
```
