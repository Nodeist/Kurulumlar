&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/n5iirpq.png)

# Mande Kurulum Rehberi
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

## Mande Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Mande fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O MND.sh https://raw.githubusercontent.com/Nodeist/testler/main/Mande/MND?token=GHSAT0AAAAAABZ3DVP4U4KQSGF47O7NBGOOY2KU74A && chmod +x MND.sh && ./MND.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
mande-chaind status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
mande-chaind keys add $MND_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
mande-chaind keys add $MND_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
mande-chaind keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
MND_WALLET_ADDRESS=$(mande-chaind keys show $MND_WALLET -a)
MND_VALOPER_ADDRESS=$(mande-chaind keys show $MND_WALLET --bech val -a)
echo 'export MND_WALLET_ADDRESS='${MND_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export MND_VALOPER_ADDRESS='${MND_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 mand'ye sahip olduğunuzdan (1 mand 1000000 umand'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
mande-chaind query bank balances $MND_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
mande-chaind tx staking create-validator \
  --amount 0cred \
  --from $MND_WALLET \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --pubkey  $(mande-chaind tendermint show-validator) \
  --moniker $MND_NODENAME \
  --chain-id $MND_ID
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu mande-chaind -o cat
```

Servisi Başlat:
```
systemctl start mande-chaind
```

Servisi Durdur:
```
systemctl stop mande-chaind
```

Servisi Yeniden Başlat:
```
systemctl restart mande-chaind
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
mande-chaind status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
mande-chaind status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
mande-chaind status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
mande-chaind tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
mande-chaind keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
mande-chaind keys add $MND_WALLET --recover
```

Cüzdan Silme:
```
mande-chaind keys delete $MND_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
mande-chaind query bank balances $MND_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
mande-chaind tx bank send $MND_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000umand
```

### Oylama
```
mande-chaind tx gov vote 1 yes --from $MND_WALLET --chain-id=$MND_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
mande-chaind tx staking delegate $MND_VALOPER_ADDRESS 10000000umand --from=$MND_WALLET --chain-id=$MND_ID --gas=auto --fees 250umand
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
mande-chaind tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000umand --from=$MND_WALLET --chain-id=$MND_ID --gas=auto --fees 250umand
```

Tüm ödülleri çek:
```
mande-chaind tx distribution withdraw-all-rewards --from=$MND_WALLET --chain-id=$MND_ID --gas=auto --fees 250umand
```

Komisyon ile ödülleri geri çekin:
```
mande-chaind tx distribution withdraw-rewards $MND_VALOPER_ADDRESS --from=$MND_WALLET --commission --chain-id=$MND_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
mande-chaind tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$MND_ID \
--from=$MND_WALLET
```

Hapisten Kurtul(Unjail):
```
mande-chaind tx slashing unjail \
  --broadcast-mode=block \
  --from=$MND_WALLET \
  --chain-id=$MND_ID \
  --gas=auto --fees 250umand
```


Node Tamamen Silmek:
```
sudo systemctl stop mande-chaind
sudo systemctl disable mande-chaind
sudo rm /etc/systemd/system/mande-chaind* -rf
sudo rm $(which mande-chaind) -rf
sudo rm $HOME/.mande-chain* -rf
sed -i '/MND_/d' ~/.bash_profile
```
