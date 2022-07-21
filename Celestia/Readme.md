&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>

![](https://i.hizliresim.com/5oh0erz.png)

# Celestia Kurulum Rehberi
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

## Celestia Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Celestia fullnode'unuzu birkaç dakika içinde kurabilirsiniz. 
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O TIA.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Celestia/TIA && chmod +x TIA.sh && ./TIA.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. 
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
celestia-appd status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
celestia-appd keys add $TIA_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
celestia-appd keys add $TIA_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
celestia-appd keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
TIA_WALLET_ADDRESS=$(celestia-appd keys show $TIA_WALLET -a)
TIA_VALOPER_ADDRESS=$(celestia-appd keys show $TIA_WALLET --bech val -a)
echo 'export TIA_WALLET_ADDRESS='${TIA_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export TIA_VALOPER_ADDRESS='${TIA_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 tia'ye sahip olduğunuzdan (1 tia 1000000 utia'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
celestia-appd query bank balances $TIA_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcı Oluşturma:
```
celestia-appd tx staking create-validator \
  --amount 1999000utia \
  --from $TIA_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(celestia-appd tendermint show-validator) \
  --moniker $TIA_NODENAME \
  --chain-id $TIA_ID \
  --fees 250utia
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu celestia-appd -o cat
```

Servisi Başlat:
```
systemctl start celestia-appd
```

Servisi Durdur:
```
systemctl stop celestia-appd
```

Servisi Yeniden Başlat:
```
systemctl restart celestia-appd
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
celestia-appd status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
celestia-appd status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
celestia-appd status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
celestia-appd tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
celestia-appd keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
celestia-appd keys add $TIA_WALLET --recover
```

Cüzdan Silme:
```
celestia-appd keys delete $TIA_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
celestia-appd query bank balances $TIA_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
celestia-appd tx bank send $TIA_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000utia
```

### Oylama
```
celestia-appd tx gov vote 1 yes --from $TIA_WALLET --chain-id=$TIA_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
celestia-appd tx staking delegate $TIA_VALOPER_ADDRESS 10000000utia --from=$TIA_WALLET --chain-id=$TIA_ID --gas=auto --fees 250utia
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
celestia-appd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utia --from=$TIA_WALLET --chain-id=$TIA_ID --gas=auto --fees 250utia
```

Tüm ödülleri çek:
```
celestia-appd tx distribution withdraw-all-rewards --from=$TIA_WALLET --chain-id=$TIA_ID --gas=auto --fees 250utia
```

Komisyon ile ödülleri geri çekin:
```
celestia-appd tx distribution withdraw-rewards $TIA_VALOPER_ADDRESS --from=$TIA_WALLET --commission --chain-id=$TIA_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
celestia-appd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$TIA_ID \
--from=$TIA_WALLET
```

Hapisten Kurtul(Unjail): 
```
celestia-appd tx slashing unjail \
  --broadcast-mode=block \
  --from=$TIA_WALLET \
  --chain-id=$TIA_ID \
  --gas=auto --fees 250utia
```


Node Tamamen Silmek:
```
sudo systemctl stop celestia-appd
sudo systemctl disable celestia-appd
sudo rm /etc/systemd/system/celestia-app* -rf
sudo rm $(which celestia-appd) -rf
sudo rm $HOME/.celestia-app* -rf
sudo rm $HOME/core -rf
sed -i '/TIA_/d' ~/.bash_profile
```
