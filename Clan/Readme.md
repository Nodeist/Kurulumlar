&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/7wxdkbj.jpeg)


# ClanNetwork Kurulum Rehberi
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

## Clan Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Clan fullnode'unuzu birkaç dakika içinde kurabilirsiniz. 
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O CLAN.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Clan/CLAN && chmod +x CLAN.sh && ./CLAN.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. 
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
cland status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
cland keys add $CLAN_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
cland keys add $CLAN_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
cland keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
CLAN_WALLET_ADDRESS=$(cland keys show $CLAN_WALLET -a)
CLAN_VALOPER_ADDRESS=$(cland keys show $CLAN_WALLET --bech val -a)
echo 'export CLAN_WALLET_ADDRESS='${CLAN_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export CLAN_VALOPER_ADDRESS='${CLAN_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 clan'ye sahip olduğunuzdan (1 clan 1000000 uclan'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
cland query bank balances $CLAN_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcı Oluşturma:
```
cland tx staking create-validator \
  --amount 1000000uclan \
  --from $CLAN_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(cland tendermint show-validator) \
  --moniker $CLAN_NODENAME \
  --chain-id $CLAN_ID \
  --fees 250uclan
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu cland -o cat
```

Servisi Başlat:
```
systemctl start cland
```

Servisi Durdur:
```
systemctl stop cland
```

Servisi Yeniden Başlat:
```
systemctl restart cland
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
cland status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
cland status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
cland status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
cland tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
cland keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
cland keys add $CLAN_WALLET --recover
```

Cüzdan Silme:
```
cland keys delete $CLAN_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
cland query bank balances $CLAN_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
cland tx bank send $CLAN_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uclan
```

### Oylama
```
cland tx gov vote 1 yes --from $CLAN_WALLET --chain-id=$CLAN_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
cland tx staking delegate $CLAN_VALOPER_ADDRESS 10000000uclan --from=$CLAN_WALLET --chain-id=$CLAN_ID --gas=auto --fees 250uclan
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
cland tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uclan --from=$CLAN_WALLET --chain-id=$CLAN_ID --gas=auto --fees 250uclan
```

Tüm ödülleri çek:
```
cland tx distribution withdraw-all-rewards --from=$CLAN_WALLET --chain-id=$CLAN_ID --gas=auto --fees 250uclan
```

Komisyon ile ödülleri geri çekin:
```
cland tx distribution withdraw-rewards $CLAN_VALOPER_ADDRESS --from=$CLAN_WALLET --commission --chain-id=$CLAN_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
cland tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$CLAN_ID \
--from=$CLAN_WALLET
```

Hapisten Kurtul(Unjail): 
```
cland tx slashing unjail \
  --broadcast-mode=block \
  --from=$CLAN_WALLET \
  --chain-id=$CLAN_ID \
  --gas=auto --fees 250uclan
```


Node Tamamen Silmek:
```
sudo systemctl stop cland
sudo systemctl disable cland
sudo rm /etc/systemd/system/clan* -rf
sudo rm $(which cland) -rf
sudo rm $HOME/.clan* -rf
sudo rm $HOME/clan-network -rf
sed -i '/CLAN_/d' ~/.bash_profile
```
  