&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>

![](https://i.hizliresim.com/4mmj0u4.png)



# Defund Kurulum Rehberi
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

## Defund Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Defund fullnode'unuzu birkaç dakika içinde kurabilirsiniz. 
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O FETF.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Defund/FETF && chmod +x FETF.sh && ./FETF.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. 
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
defundd status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
defundd keys add $FETF_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
defundd keys add $FETF_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
defundd keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
FETF_WALLET_ADDRESS=$(defundd keys show $FETF_WALLET -a)
FETF_VALOPER_ADDRESS=$(defundd keys show $FETF_WALLET --bech val -a)
echo 'export FETF_WALLET_ADDRESS='${FETF_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export FETF_VALOPER_ADDRESS='${FETF_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 fetf'ye sahip olduğunuzdan (1 fetf 1000000 ufetf'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
defundd query bank balances $FETF_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcı Oluşturma:
```
defundd tx staking create-validator \
  --amount 1000000ufetf \
  --from $FETF_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(defundd tendermint show-validator) \
  --moniker $FETF_NODENAME \
  --chain-id $FETF_ID \
  --fees 250ufetf
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu defundd -o cat
```

Servisi Başlat:
```
systemctl start defundd
```

Servisi Durdur:
```
systemctl stop defundd
```

Servisi Yeniden Başlat:
```
systemctl restart defundd
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
defundd status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
defundd status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
defundd status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
defundd tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
defundd keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
defundd keys add $FETF_WALLET --recover
```

Cüzdan Silme:
```
defundd keys delete $FETF_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
defundd query bank balances $FETF_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
defundd tx bank send $FETF_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ufetf
```

### Oylama
```
defundd tx gov vote 1 yes --from $FETF_WALLET --chain-id=$FETF_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
defundd tx staking delegate $FETF_VALOPER_ADDRESS 10000000ufetf --from=$FETF_WALLET --chain-id=$FETF_ID --gas=auto --fees 250ufetf
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
defundd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ufetf --from=$FETF_WALLET --chain-id=$FETF_ID --gas=auto --fees 250ufetf
```

Tüm ödülleri çek:
```
defundd tx distribution withdraw-all-rewards --from=$FETF_WALLET --chain-id=$FETF_ID --gas=auto --fees 250ufetf
```

Komisyon ile ödülleri geri çekin:
```
defundd tx distribution withdraw-rewards $FETF_VALOPER_ADDRESS --from=$FETF_WALLET --commission --chain-id=$FETF_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
defundd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$FETF_ID \
--from=$FETF_WALLET
```

Hapisten Kurtul(Unjail): 
```
defundd tx slashing unjail \
  --broadcast-mode=block \
  --from=$FETF_WALLET \
  --chain-id=$FETF_ID \
  --gas=auto --fees 250ufetf
```


Node Tamamen Silmek:
```
sudo systemctl stop defundd
sudo systemctl disable defundd
sudo rm /etc/systemd/system/defund* -rf
sudo rm $(which defundd) -rf
sudo rm $HOME/.defund* -rf
sudo rm $HOME/defund -rf
sed -i '/FETF_/d' ~/.bash_profile
```
  