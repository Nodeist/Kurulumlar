<p style="font-size:14px" align="right">
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>



<p align="center">
  <img height="100" src="https://i.hizliresim.com/hb4a5iv.png">
</p>

# Kujira Kurulum Rehberi
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

## Kujira Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Kujira fullnode'unuzu birkaç dakika içinde kurabilirsiniz. 
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O KUJI.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Z-Bitenler/Kujira-Mainnet/KUJI && chmod +x KUJI.sh && ./KUJI.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. 
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
kujirad status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
kujirad keys add $WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
kujirad keys add $WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
kujirad keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
KUJI_WALLET_ADDRESS=$(kujirad keys show $WALLET -a)
KUJI_VALOPER_ADDRESS=$(kujirad keys show $WALLET --bech val -a)
echo 'export KUJI_WALLET_ADDRESS='${KUJI_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export KUJI_VALOPER_ADDRESS='${KUJI_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 kuji'ye sahip olduğunuzdan (1 kuji 1000000 ukuji'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
kujirad query bank balances $KUJI_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcı Oluşturma:
```
kujirad tx staking create-validator \
  --amount 1999000ukuji \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(kujirad tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $KUJI_ID \
  --fees 250ukuji
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu kujirad -o cat
```

Servisi Başlat:
```
systemctl start kujirad
```

Servisi Durdur:
```
systemctl stop kujirad
```

Servisi Yeniden Başlat:
```
systemctl restart kujirad
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
kujirad status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
kujirad status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
kujirad status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
kujirad tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
kujirad keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
kujirad keys add $WALLET --recover
```

Cüzdan Silme:
```
kujirad keys delete $WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
kujirad query bank balances $KUJI_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
kujirad tx bank send $KUJI_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ukuji
```

### Oylama
```
kujirad tx gov vote 1 yes --from $WALLET --chain-id=$KUJI_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
kujirad tx staking delegate $KUJI_VALOPER_ADDRESS 10000000ukuji --from=$WALLET --chain-id=$KUJI_ID --gas=auto --fees 250ukuji
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
kujirad tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ukuji --from=$WALLET --chain-id=$KUJI_ID --gas=auto --fees 250ukuji
```

Tüm ödülleri çek:
```
kujirad tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$KUJI_ID --gas=auto --fees 250ukuji
```

Komisyon ile ödülleri geri çekin:
```
kujirad tx distribution withdraw-rewards $KUJI_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$KUJI_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
seid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$KUJI_ID \
--from=$WALLET
```

Hapisten Kurtul(Unjail): 
```
kujirad tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$KUJI_ID \
  --gas=auto --fees 250ukuji
```


Node Tamamen Silmek:
```
sudo systemctl stop kujirad
sudo systemctl disable kujirad
sudo rm /etc/systemd/system/kujira* -rf
sudo rm $(which kujirad) -rf
sudo rm $HOME/.kujira* -rf
sudo rm $HOME/core -rf
sed -i '/KUJI_/d' ~/.bash_profile
```
