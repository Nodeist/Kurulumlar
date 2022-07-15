<p style="font-size:14px" align="right">
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>
<p align="center">
  <img height="100" src="https://i.hizliresim.com/k3u6tzn.jpeg">
</p>

# Quicksilver Kurulum Rehberi
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

## Quicksilver Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Quicksilver fullnode'unuzu birkaç dakika içinde kurabilirsiniz. 
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O QCK.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Z-Bitenler/Quicksilver/QCK && chmod +x QCK.sh && ./QCK.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. 
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
quicksilverd status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
quicksilverd keys add $WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
quicksilverd keys add $WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
quicksilverd keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
QCK_WALLET_ADDRESS=$(quicksilverd keys show $WALLET -a)
QCK_VALOPER_ADDRESS=$(quicksilverd keys show $WALLET --bech val -a)
echo 'export QCK_WALLET_ADDRESS='${QCK_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export QCK_VALOPER_ADDRESS='${QCK_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 qck'ye sahip olduğunuzdan (1 qck 1000000 uqck'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
quicksilverd query bank balances $QCK_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 
Doğrulayıcı Oluşturma:
```
quicksilverd tx staking create-validator \
  --amount 1999000uqck \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(quicksilverd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $QCK_ID \
  --fees 250uqck
```

  
## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu quicksilverd -o cat
```

Servisi Başlat:
```
systemctl start quicksilverd
```

Servisi Durdur:
```
systemctl stop quicksilverd
```

Servisi Yeniden Başlat:
```
systemctl restart quicksilverd
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
quicksilverd status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
quicksilverd status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
quicksilverd status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
quicksilverd tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
quicksilverd keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
quicksilverd keys add $WALLET --recover
```

Cüzdan Silme:
```
quicksilverd keys delete $WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
quicksilverd query bank balances $QCK_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
quicksilverd tx bank send $QCK_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uqck
```

### Oylama
```
quicksilverd tx gov vote 1 yes --from $WALLET --chain-id=$QCK_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
quicksilverd tx staking delegate $QCK_VALOPER_ADDRESS 10000000uqck --from=$WALLET --chain-id=$QCK_ID --gas=auto --fees 250uqck
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
quicksilverd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uqck --from=$WALLET --chain-id=$QCK_ID --gas=auto --fees 250uqck
```

Tüm ödülleri çek:
```
quicksilverd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$QCK_ID --gas=auto --fees 250uqck
```

Komisyon ile ödülleri geri çekin:
```
quicksilverd tx distribution withdraw-rewards $QCK_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$QCK_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
seid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$QCK_ID \
--from=$WALLET
```

Hapisten Kurtul(Unjail): 
```
quicksilverd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$QCK_ID \
  --gas=auto --fees 250uqck
```


Node Tamamen Silmek:
```
sudo systemctl stop quicksilverd
sudo systemctl disable quicksilverd
sudo rm /etc/systemd/system/quicksilver* -rf
sudo rm $(which quicksilverd) -rf
sudo rm $HOME/.quicksilverd* -rf
sudo rm $HOME/quicksilver -rf
sed -i '/QCK_/d' ~/.bash_profile
```
