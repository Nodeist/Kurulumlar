<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/terp.png">
</p>

# Terp Kurulum Rehberi
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

## Terp Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Terp fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O TERP.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Terp/TERP && chmod +x TERP.sh && ./TERP.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
terpd status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
terpd keys add $TERP_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
terpd keys add $TERP_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
terpd keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
TERP_WALLET_ADDRESS=$(terpd keys show $TERP_WALLET -a)
TERP_VALOPER_ADDRESS=$(terpd keys show $TERP_WALLET --bech val -a)
echo 'export TERP_WALLET_ADDRESS='${TERP_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export TERP_VALOPER_ADDRESS='${TERP_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 terpx'ye sahip olduğunuzdan (1 terpx 1000000 uterpx'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
terpd query bank balances $TERP_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
terpd tx staking create-validator \
  --amount 1999000uterpx \
  --from $TERP_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(terpd tendermint show-validator) \
  --moniker $TERP_NODENAME \
  --chain-id $TERP_ID \
  --fees 250uterpx
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu terpd -o cat
```

Servisi Başlat:
```
systemctl start terpd
```

Servisi Durdur:
```
systemctl stop terpd
```

Servisi Yeniden Başlat:
```
systemctl restart terpd
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
terpd status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
terpd status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
terpd status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
terpd tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
terpd keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
terpd keys add $TERP_WALLET --recover
```

Cüzdan Silme:
```
terpd keys delete $TERP_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
terpd query bank balances $TERP_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
terpd tx bank send $TERP_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uterpx
```

### Oylama
```
terpd tx gov vote 1 yes --from $TERP_WALLET --chain-id=$TERP_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
terpd tx staking delegate $TERP_VALOPER_ADDRESS 10000000uterpx --from=$TERP_WALLET --chain-id=$TERP_ID --gas=auto --fees 250uterpx
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
terpd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uterpx --from=$TERP_WALLET --chain-id=$TERP_ID --gas=auto --fees 250uterpx
```

Tüm ödülleri çek:
```
terpd tx distribution withdraw-all-rewards --from=$TERP_WALLET --chain-id=$TERP_ID --gas=auto --fees 250uterpx
```

Komisyon ile ödülleri geri çekin:
```
terpd tx distribution withdraw-rewards $TERP_VALOPER_ADDRESS --from=$TERP_WALLET --commission --chain-id=$TERP_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
terpd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$TERP_ID \
--from=$TERP_WALLET
```

Hapisten Kurtul(Unjail):
```
terpd tx slashing unjail \
  --broadcast-mode=block \
  --from=$TERP_WALLET \
  --chain-id=$TERP_ID \
  --gas=auto --fees 250uterpx
```


Node Tamamen Silmek:
```
sudo systemctl stop terpd
sudo systemctl disable terpd
sudo rm /etc/systemd/system/terp* -rf
sudo rm $(which terpd) -rf
sudo rm $HOME/.terp* -rf
sudo rm $HOME/terp-core -rf
sed -i '/TERP_/d' ~/.bash_profile
```
