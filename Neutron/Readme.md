<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/neutron.png">
</p>

# Neutron Kurulum Rehberi
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

## Neutron Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Neutron fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O NTRN.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Neutron/NTRN && chmod +x NTRN.sh && ./NTRN.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
neutrond status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
neutrond keys add $NTRN_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
neutrond keys add $NTRN_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
neutrond keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
NTRN_WALLET_ADDRESS=$(neutrond keys show $NTRN_WALLET -a)
NTRN_VALOPER_ADDRESS=$(neutrond keys show $NTRN_WALLET --bech val -a)
echo 'export NTRN_WALLET_ADDRESS='${NTRN_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export NTRN_VALOPER_ADDRESS='${NTRN_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 ntrn'ye sahip olduğunuzdan (1 ntrn 1000000 untrn'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
neutrond query bank balances $NTRN_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
neutrond tx staking create-validator \
  --amount 1999000untrn \
  --from $NTRN_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(neutrond tendermint show-validator) \
  --moniker $NTRN_NODENAME \
  --chain-id $NTRN_ID \
  --fees 250untrn
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu neutrond -o cat
```

Servisi Başlat:
```
systemctl start neutrond
```

Servisi Durdur:
```
systemctl stop neutrond
```

Servisi Yeniden Başlat:
```
systemctl restart neutrond
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
neutrond status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
neutrond status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
neutrond status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
neutrond tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
neutrond keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
neutrond keys add $NTRN_WALLET --recover
```

Cüzdan Silme:
```
neutrond keys delete $NTRN_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
neutrond query bank balances $NTRN_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
neutrond tx bank send $NTRN_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000untrn
```

### Oylama
```
neutrond tx gov vote 1 yes --from $NTRN_WALLET --chain-id=$NTRN_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
neutrond tx staking delegate $NTRN_VALOPER_ADDRESS 10000000untrn --from=$NTRN_WALLET --chain-id=$NTRN_ID --gas=auto --fees 250untrn
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
neutrond tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000untrn --from=$NTRN_WALLET --chain-id=$NTRN_ID --gas=auto --fees 250untrn
```

Tüm ödülleri çek:
```
neutrond tx distribution withdraw-all-rewards --from=$NTRN_WALLET --chain-id=$NTRN_ID --gas=auto --fees 250untrn
```

Komisyon ile ödülleri geri çekin:
```
neutrond tx distribution withdraw-rewards $NTRN_VALOPER_ADDRESS --from=$NTRN_WALLET --commission --chain-id=$NTRN_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
neutrond tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$NTRN_ID \
--from=$NTRN_WALLET
```

Hapisten Kurtul(Unjail):
```
neutrond tx slashing unjail \
  --broadcast-mode=block \
  --from=$NTRN_WALLET \
  --chain-id=$NTRN_ID \
  --gas=auto --fees 250untrn
```


Node Tamamen Silmek:
```
sudo systemctl stop neutrond
sudo systemctl disable neutrond
sudo rm /etc/systemd/system/neutron* -rf
sudo rm $(which neutrond) -rf
sudo rm $HOME/.neutrond* -rf
sudo rm $HOME/neutron -rf
sed -i '/NTRN_/d' ~/.bash_profile
```
