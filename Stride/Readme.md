&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/qa5txaz.png)


# Stride Kurulum Rehberi
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

## Stride Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Stride fullnode'unuzu birkaç dakika içinde kurabilirsiniz. 
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O STRD.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Stride/STRD && chmod +x STRD.sh && ./STRD.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. 
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
strided status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
strided keys add $STRD_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
strided keys add $STRD_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
strided keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
STRD_WALLET_ADDRESS=$(strided keys show $STRD_WALLET -a)
STRD_VALOPER_ADDRESS=$(strided keys show $STRD_WALLET --bech val -a)
echo 'export STRD_WALLET_ADDRESS='${STRD_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export STRD_VALOPER_ADDRESS='${STRD_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 strd'ye sahip olduğunuzdan (1 strd 1000000 ustrd'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
strided query bank balances $STRD_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcı Oluşturma:
```
strided tx staking create-validator \
  --amount 1999000ustrd \
  --from $STRD_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(strided tendermint show-validator) \
  --moniker $STRD_NODENAME \
  --chain-id $STRD_ID \
  --fees 250ustrd
```

## Likit hisseli işlemler
### Likidite stake edin
Likidite, ATOM'unuzu stATOM için Stride'da stake edin:
```
strided tx stakeibc liquid-stake 1000 uatom --from $WALLET --chain-id $STRD_ID
```

> Not: 1000 uatom likit stake yaparsanız, karşılığında sadece 990 (az ya da çok olabilir) stATOM alabilirsiniz! Bunun nedeni döviz kurumuzun çalışma şeklidir. 990 stATOM'unuz hala 1000 uatom değerindedir (veya stake ödülleri kazandıkça daha fazla!)
### Redeem işlemi
Bazı staking ödüllerini topladıktan sonra, jetonlarınızı geri alabilirsiniz. Şu anda Gaia (Cosmos Hub) test ağımızdaki bağlanma süresi yaklaşık 30 dakikadır.
```
strided tx stakeibc redeem-stake 999 GAIA <cosmos_address_you_want_to_redeem_to> --chain-id $STRD_ID --from $STRD_WALLET
```

### Jetonların talep edilebilir olup olmadığını kontrol edin
Belirteçlerinizin talep edilmeye hazır olup olmadığını görmek istiyorsanız, "<your_stride_account>" ile anahtarlanmış "UserRedemptionRecord"unuzu arayın.
```
strided q records list-user-redemption-record --output json | jq --arg WALLET_ADDRESS "$STRD_WALLET_ADDRESS" '.UserRedemptionRecord | map(select(.sender == $STRD_WALLET_ADDRESS))'
```
Kaydınız "isClaimable=true" özelliğine sahipse, hak talebinde bulunulmaya hazırdır!

### Talep belirteçleri
Belirteçlerinizin bağı çözüldükten sonra, talep sürecini tetikleyerek talep edilebilirler.
```
strided tx stakeibc claim-undelegated-tokens GAIA 5 --chain-id $STRD_ID --from $STRD_WALLET
```
> Not: Bu işlev, bir FIFO kuyruğundaki talepleri tetikler, yani talebiniz 20. sıradaysa, jetonlarınızın hesabınızda görünmesini görmeden önce diğer talepleri işleme koymuş olursunuz.


## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu strided -o cat
```

Servisi Başlat:
```
systemctl start strided
```

Servisi Durdur:
```
systemctl stop strided
```

Servisi Yeniden Başlat:
```
systemctl restart strided
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
strided status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
strided status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
strided status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
strided tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
strided keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
strided keys add $STRD_WALLET --recover
```

Cüzdan Silme:
```
strided keys delete $STRD_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
strided query bank balances $STRD_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
strided tx bank send $STRD_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ustrd
```

### Oylama
```
strided tx gov vote 1 yes --from $STRD_WALLET --chain-id=$STRD_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
strided tx staking delegate $STRD_VALOPER_ADDRESS 10000000ustrd --from=$STRD_WALLET --chain-id=$STRD_ID --gas=auto --fees 250ustrd
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
strided tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ustrd --from=$STRD_WALLET --chain-id=$STRD_ID --gas=auto --fees 250ustrd
```

Tüm ödülleri çek:
```
strided tx distribution withdraw-all-rewards --from=$STRD_WALLET --chain-id=$STRD_ID --gas=auto --fees 250ustrd
```

Komisyon ile ödülleri geri çekin:
```
strided tx distribution withdraw-rewards $STRD_VALOPER_ADDRESS --from=$STRD_WALLET --commission --chain-id=$STRD_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
strided tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$STRD_ID \
--from=$STRD_WALLET
```

Hapisten Kurtul(Unjail): 
```
strided tx slashing unjail \
  --broadcast-mode=block \
  --from=$STRD_WALLET \
  --chain-id=$STRD_ID \
  --gas=auto --fees 250ustrd
```


Node Tamamen Silmek:
```
sudo systemctl stop strided
sudo systemctl disable strided
sudo rm /etc/systemd/system/stride* -rf
sudo rm $(which strided) -rf
sudo rm $HOME/.stride* -rf
sudo rm $HOME/stride -rf
sed -i '/STRD_/d' ~/.bash_profile
```
