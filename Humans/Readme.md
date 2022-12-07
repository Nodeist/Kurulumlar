<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/humans.png">
</p>

# Humans Kurulum Rehberi
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

## Humans Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Humans fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O HMN.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Humans/HMN && chmod +x HMN.sh && ./HMN.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
humansd status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
humansd keys add $HMN_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
humansd keys add $HMN_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
humansd keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
HMN_WALLET_ADDRESS=$(humansd keys show $HMN_WALLET -a)
HMN_VALOPER_ADDRESS=$(humansd keys show $HMN_WALLET --bech val -a)
echo 'export HMN_WALLET_ADDRESS='${HMN_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export HMN_VALOPER_ADDRESS='${HMN_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 heart'ye sahip olduğunuzdan (1 heart 1000000 uheart'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
humansd query bank balances $HMN_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
humansd tx staking create-validator \
  --amount 1999000uheart \
  --from $HMN_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(humansd tendermint show-validator) \
  --moniker $HMN_NODENAME \
  --chain-id $HMN_ID \
  --fees 250uheart
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu humansd -o cat
```

Servisi Başlat:
```
systemctl start humansd
```

Servisi Durdur:
```
systemctl stop humansd
```

Servisi Yeniden Başlat:
```
systemctl restart humansd
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
humansd status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
humansd status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
humansd status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
humansd tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
humansd keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
humansd keys add $HMN_WALLET --recover
```

Cüzdan Silme:
```
humansd keys delete $HMN_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
humansd query bank balances $HMN_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
humansd tx bank send $HMN_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uheart
```

### Oylama
```
humansd tx gov vote 1 yes --from $HMN_WALLET --chain-id=$HMN_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
humansd tx staking delegate $HMN_VALOPER_ADDRESS 10000000uheart --from=$HMN_WALLET --chain-id=$HMN_ID --gas=auto --fees 250uheart
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
humansd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uheart --from=$HMN_WALLET --chain-id=$HMN_ID --gas=auto --fees 250uheart
```

Tüm ödülleri çek:
```
humansd tx distribution withdraw-all-rewards --from=$HMN_WALLET --chain-id=$HMN_ID --gas=auto --fees 250uheart
```

Komisyon ile ödülleri geri çekin:
```
humansd tx distribution withdraw-rewards $HMN_VALOPER_ADDRESS --from=$HMN_WALLET --commission --chain-id=$HMN_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
seid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$HMN_ID \
--from=$HMN_WALLET
```

Hapisten Kurtul(Unjail):
```
humansd tx slashing unjail \
  --broadcast-mode=block \
  --from=$HMN_WALLET \
  --chain-id=$HMN_ID \
  --gas=auto --fees 250uheart
```


Node Tamamen Silmek:
```
sudo systemctl stop humansd
sudo systemctl disable humansd
sudo rm /etc/systemd/system/humans* -rf
sudo rm $(which humansd) -rf
sudo rm $HOME/.humans* -rf
sudo rm $HOME/humans -rf
sed -i '/HMN_/d' ~/.bash_profile
```
