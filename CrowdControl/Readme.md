<p style="font-size:14px" align="right">
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>



<p align="center">
  <img height="100" src="https://i.hizliresim.com/qii2z30.jpeg">
</p>

# CrowdControl Kurulum Rehberi
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

## CrowdControl Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak CrowdControl fullnode'unuzu birkaç dakika içinde kurabilirsiniz. 
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O CC.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/CrowdControl/CC && chmod +x CC.sh && ./CC.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. 
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
Cardchain status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
Cardchain keys add $CC_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
Cardchain keys add $CC_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
Cardchain keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
CC_WALLET_ADDRESS=$(Cardchain keys show $CC_WALLET -a)
CC_VALOPER_ADDRESS=$(Cardchain keys show $CC_WALLET --bech val -a)
echo 'export CC_WALLET_ADDRESS='${CC_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export CC_VALOPER_ADDRESS='${CC_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 bpf'ye sahip olduğunuzdan (1 bpf 1000000 ubpf'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
Cardchain query bank balances $CC_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcı Oluşturma:
```
Cardchain tx staking create-validator \
  --amount 1000000ubpf \
  --from $CC_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(Cardchain tendermint show-validator) \
  --moniker $CC_NODENAME \
  --chain-id $CC_ID \
  --fees 250ubpf
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu Cardchain -o cat
```

Servisi Başlat:
```
systemctl start Cardchain
```

Servisi Durdur:
```
systemctl stop Cardchain
```

Servisi Yeniden Başlat:
```
systemctl restart Cardchain
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
Cardchain status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
Cardchain status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
Cardchain status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
Cardchain tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
Cardchain keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
Cardchain keys add $CC_WALLET --recover
```

Cüzdan Silme:
```
Cardchain keys delete $CC_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
Cardchain query bank balances $CC_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
Cardchain tx bank send $CC_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ubpf
```

### Oylama
```
Cardchain tx gov vote 1 yes --from $CC_WALLET --chain-id=$CC_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
Cardchain tx staking delegate $CC_VALOPER_ADDRESS 10000000ubpf --from=$CC_WALLET --chain-id=$CC_ID --gas=auto --fees 250ubpf
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
Cardchain tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ubpf --from=$CC_WALLET --chain-id=$CC_ID --gas=auto --fees 250ubpf
```

Tüm ödülleri çek:
```
Cardchain tx distribution withdraw-all-rewards --from=$CC_WALLET --chain-id=$CC_ID --gas=auto --fees 250ubpf
```

Komisyon ile ödülleri geri çekin:
```
Cardchain tx distribution withdraw-rewards $CC_VALOPER_ADDRESS --from=$CC_WALLET --commission --chain-id=$CC_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
Cardchain tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$CC_ID \
--from=$CC_WALLET
```

Hapisten Kurtul(Unjail): 
```
Cardchain tx slashing unjail \
  --broadcast-mode=block \
  --from=$CC_WALLET \
  --chain-id=$CC_ID \
  --gas=auto --fees 250ubpf
```


Node Tamamen Silmek:
```
sudo systemctl stop Cardchain
sudo systemctl disable Cardchain
sudo rm /etc/systemd/system/Cardchain* -rf
sudo rm $(which Cardchain) -rf
sudo rm $HOME/.Cardchain* -rf
sudo rm $HOME/Cardchain -rf
sed -i '/CC_/d' ~/.bash_profile
```
