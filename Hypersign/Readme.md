&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/itxl39j.png)

# Hypersign Kurulum Rehberi
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

## Hypersign Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Hypersign fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O HS.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Hypersign/HS && chmod +x HS.sh && ./HS.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
hid-noded status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
hid-noded keys add $HS_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
hid-noded keys add $HS_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
hid-noded keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
HS_WALLET_ADDRESS=$(hid-noded keys show $HS_WALLET -a)
HS_VALOPER_ADDRESS=$(hid-noded keys show $HS_WALLET --bech val -a)
echo 'export HS_WALLET_ADDRESS='${HS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export HS_VALOPER_ADDRESS='${HS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 hid'ye sahip olduğunuzdan (1 hid 1000000 uhid'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
hid-noded query bank balances $HS_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
hid-noded tx staking create-validator \
  --amount 1999000uhid \
  --from $HS_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(hid-noded tendermint show-validator) \
  --moniker $HS_NODENAME \
  --chain-id $HS_ID \
  --fees 250uhid
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu hid-noded -o cat
```

Servisi Başlat:
```
systemctl start hid-noded
```

Servisi Durdur:
```
systemctl stop hid-noded
```

Servisi Yeniden Başlat:
```
systemctl restart hid-noded
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
hid-noded status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
hid-noded status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
hid-noded status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
hid-noded tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
hid-noded keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
hid-noded keys add $HS_WALLET --recover
```

Cüzdan Silme:
```
hid-noded keys delete $HS_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
hid-noded query bank balances $HS_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
hid-noded tx bank send $HS_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uhid
```

### Oylama
```
hid-noded tx gov vote 1 yes --from $HS_WALLET --chain-id=$HS_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
hid-noded tx staking delegate $HS_VALOPER_ADDRESS 10000000uhid --from=$HS_WALLET --chain-id=$HS_ID --gas=auto --fees 250uhid
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
hid-noded tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uhid --from=$HS_WALLET --chain-id=$HS_ID --gas=auto --fees 250uhid
```

Tüm ödülleri çek:
```
hid-noded tx distribution withdraw-all-rewards --from=$HS_WALLET --chain-id=$HS_ID --gas=auto --fees 250uhid
```

Komisyon ile ödülleri geri çekin:
```
hid-noded tx distribution withdraw-rewards $HS_VALOPER_ADDRESS --from=$HS_WALLET --commission --chain-id=$HS_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
hid-noded tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$HS_ID \
--from=$HS_WALLET
```

Hapisten Kurtul(Unjail):
```
hid-noded tx slashing unjail \
  --broadcast-mode=block \
  --from=$HS_WALLET \
  --chain-id=$HS_ID \
  --gas=auto --fees 250uhid
```


Node Tamamen Silmek:
```
sudo systemctl stop hid-noded
sudo systemctl disable hid-noded
sudo rm /etc/systemd/system/hid-node* -rf
sudo rm $(which hid-noded) -rf
sudo rm $HOME/.hid-node* -rf
sudo rm $HOME/hid-node -rf
sed -i '/HS_/d' ~/.bash_profile
```
