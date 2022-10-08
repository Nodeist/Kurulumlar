&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/fxu8jxr.png)

# Realio Kurulum Rehberi
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

## Realio Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Realio fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O RLO.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Realio/RLO && chmod +x RLO.sh && ./RLO.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
realio-networkd status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
realio-networkd keys add $RLO_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
realio-networkd keys add $RLO_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
realio-networkd keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
RLO_WALLET_ADDRESS=$(realio-networkd keys show $RLO_WALLET -a)
RLO_VALOPER_ADDRESS=$(realio-networkd keys show $RLO_WALLET --bech val -a)
echo 'export RLO_WALLET_ADDRESS='${RLO_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export RLO_VALOPER_ADDRESS='${RLO_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 rio'ye sahip olduğunuzdan (1 rio 1000000 ario'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
realio-networkd query bank balances $RLO_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
realio-networkd tx staking create-validator \
  --amount 1999000ario \
  --from $RLO_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(realio-networkd tendermint show-validator) \
  --moniker $RLO_NODENAME \
  --chain-id $RLO_ID \
  --fees 250ario
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu realio-networkd -o cat
```

Servisi Başlat:
```
systemctl start realio-networkd
```

Servisi Durdur:
```
systemctl stop realio-networkd
```

Servisi Yeniden Başlat:
```
systemctl restart realio-networkd
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
realio-networkd status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
realio-networkd status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
realio-networkd status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
realio-networkd tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
realio-networkd keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
realio-networkd keys add $RLO_WALLET --recover
```

Cüzdan Silme:
```
realio-networkd keys delete $RLO_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
realio-networkd query bank balances $RLO_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
realio-networkd tx bank send $RLO_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ario
```

### Oylama
```
realio-networkd tx gov vote 1 yes --from $RLO_WALLET --chain-id=$RLO_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
realio-networkd tx staking delegate $RLO_VALOPER_ADDRESS 10000000ario --from=$RLO_WALLET --chain-id=$RLO_ID --gas=auto --fees 250ario
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
realio-networkd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ario --from=$RLO_WALLET --chain-id=$RLO_ID --gas=auto --fees 250ario
```

Tüm ödülleri çek:
```
realio-networkd tx distribution withdraw-all-rewards --from=$RLO_WALLET --chain-id=$RLO_ID --gas=auto --fees 250ario
```

Komisyon ile ödülleri geri çekin:
```
realio-networkd tx distribution withdraw-rewards $RLO_VALOPER_ADDRESS --from=$RLO_WALLET --commission --chain-id=$RLO_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
realio-networkd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$RLO_ID \
--from=$RLO_WALLET
```

Hapisten Kurtul(Unjail):
```
realio-networkd tx slashing unjail \
  --broadcast-mode=block \
  --from=$RLO_WALLET \
  --chain-id=$RLO_ID \
  --gas=auto --fees 250ario
```


Node Tamamen Silmek:
```
sudo systemctl stop realio-networkd
sudo systemctl disable realio-networkd
sudo rm /etc/systemd/system/realio-network* -rf
sudo rm $(which realio-networkd) -rf
sudo rm $HOME/.realio-network* -rf
sudo rm $HOME/realio-network -rf
sed -i '/RLO_/d' ~/.bash_profile
```
