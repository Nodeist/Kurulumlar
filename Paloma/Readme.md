&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>

![](https://i.hizliresim.com/iz7y3vs.png)


# Paloma Kurulum Rehberi
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

## Paloma Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Paloma fullnode'unuzu birkaç dakika içinde kurabilirsiniz. 
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O PLM.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Paloma/PLM && chmod +x PLM.sh && ./PLM.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. 
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
palomad status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
palomad keys add $PLM_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
palomad keys add $PLM_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
palomad keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
PLM_WALLET_ADDRESS=$(palomad keys show $PLM_WALLET -a)
PLM_VALOPER_ADDRESS=$(palomad keys show $PLM_WALLET --bech val -a)
echo 'export PLM_WALLET_ADDRESS='${PLM_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export PLM_VALOPER_ADDRESS='${PLM_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 grain'ye sahip olduğunuzdan (1 grain 1000000 ugrain'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
palomad query bank balances $PLM_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcı Oluşturma:
```
palomad tx staking create-validator \
  --amount 10000000ugrain \
  --from $PLM_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(palomad tendermint show-validator) \
  --moniker $PLM_NODENAME \
  --chain-id $PLM_ID \
  --fees 250ugrain
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu palomad -o cat
```

Servisi Başlat:
```
systemctl start palomad
```

Servisi Durdur:
```
systemctl stop palomad
```

Servisi Yeniden Başlat:
```
systemctl restart palomad
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
palomad status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
palomad status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
palomad status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
palomad tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
palomad keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
palomad keys add $PLM_WALLET --recover
```

Cüzdan Silme:
```
palomad keys delete $PLM_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
palomad query bank balances $PLM_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
palomad tx bank send $PLM_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ugrain
```

### Oylama
```
palomad tx gov vote 1 yes --from $PLM_WALLET --chain-id=$PLM_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
palomad tx staking delegate $PLM_VALOPER_ADDRESS 10000000ugrain --from=$PLM_WALLET --chain-id=$PLM_ID --gas=auto --fees 250ugrain
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
palomad tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ugrain --from=$PLM_WALLET --chain-id=$PLM_ID --gas=auto --fees 250ugrain
```

Tüm ödülleri çek:
```
palomad tx distribution withdraw-all-rewards --from=$PLM_WALLET --chain-id=$PLM_ID --gas=auto --fees 250ugrain
```

Komisyon ile ödülleri geri çekin:
```
palomad tx distribution withdraw-rewards $PLM_VALOPER_ADDRESS --from=$PLM_WALLET --commission --chain-id=$PLM_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
seid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$PLM_ID \
--from=$PLM_WALLET
```

Hapisten Kurtul(Unjail): 
```
palomad tx slashing unjail \
  --broadcast-mode=block \
  --from=$PLM_WALLET \
  --chain-id=$PLM_ID \
  --gas=auto --fees 250ugrain
```


Node Tamamen Silmek:
```
sudo systemctl stop palomad
sudo systemctl disable palomad
sudo rm /etc/systemd/system/paloma* -rf
sudo rm $(which palomad) -rf
sudo rm $HOME/.paloma* -rf
sudo rm $HOME/paloma -rf
sed -i '/PLM_/d' ~/.bash_profile
```
