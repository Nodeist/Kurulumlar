<p style="font-size:14px" align="right">
 100$ Free VPS for 2 Month <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>

<p align="center">
  <img height="100" src="https://i.hizliresim.com/idr6y7f.png">
</p>

# Kyve Kurulum Rehberi
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

## Kyve Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Kyve fullnode'unuzu birkaç dakika içinde kurabilirsiniz. 
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O KYVE.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Kyve/KYVE && chmod +x KYVE.sh && ./KYVE.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. 
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
kyved status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
kyved keys add $KYVE_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
kyved keys add $KYVE_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
kyved keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
KYVE_WALLET_ADDRESS=$(kyved keys show $KYVE_WALLET -a)
KYVE_VALOPER_ADDRESS=$(kyved keys show $KYVE_WALLET --bech val -a)
echo 'export KYVE_WALLET_ADDRESS='${KYVE_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export KYVE_VALOPER_ADDRESS='${KYVE_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 kyve'ye sahip olduğunuzdan (1 kyve 1000000 tkyve'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
kyved query bank balances $KYVE_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcı Oluşturma:
```
kyved tx staking create-validator \
  --amount 1999000tkyve \
  --from $KYVE_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(kyved tendermint show-validator) \
  --moniker $KYVE_NODENAME \
  --chain-id $KYVE_ID \
  --fees 250tkyve
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu kyved -o cat
```

Servisi Başlat:
```
systemctl start kyved
```

Servisi Durdur:
```
systemctl stop kyved
```

Servisi Yeniden Başlat:
```
systemctl restart kyved
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
kyved status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
kyved status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
kyved status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
kyved tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
kyved keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
kyved keys add $KYVE_WALLET --recover
```

Cüzdan Silme:
```
kyved keys delete $KYVE_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
kyved query bank balances $KYVE_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
kyved tx bank send $KYVE_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000tkyve
```

### Oylama
```
kyved tx gov vote 1 yes --from $KYVE_WALLET --chain-id=$KYVE_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
kyved tx staking delegate $KYVE_VALOPER_ADDRESS 10000000tkyve --from=$KYVE_WALLET --chain-id=$KYVE_ID --gas=auto --fees 250tkyve
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
kyved tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000tkyve --from=$KYVE_WALLET --chain-id=$KYVE_ID --gas=auto --fees 250tkyve
```

Tüm ödülleri çek:
```
kyved tx distribution withdraw-all-rewards --from=$KYVE_WALLET --chain-id=$KYVE_ID --gas=auto --fees 250tkyve
```

Komisyon ile ödülleri geri çekin:
```
kyved tx distribution withdraw-rewards $KYVE_VALOPER_ADDRESS --from=$KYVE_WALLET --commission --chain-id=$KYVE_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
seid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$KYVE_ID \
--from=$KYVE_WALLET
```

Hapisten Kurtul(Unjail): 
```
kyved tx slashing unjail \
  --broadcast-mode=block \
  --from=$KYVE_WALLET \
  --chain-id=$KYVE_ID \
  --gas=auto --fees 250tkyve
```


Node Tamamen Silmek:
```
sudo systemctl stop kyved
sudo systemctl disable kyved
sudo rm /etc/systemd/system/kyved* -rf
sudo rm $(which kyved) -rf
sudo rm $HOME/.kyve* -rf
sudo rm $HOME/kyve -rf
sed -i '/KYVE_/d' ~/.bash_profile
```
