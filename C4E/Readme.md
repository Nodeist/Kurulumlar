<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/c4e.png">
</p>

# C4E Kurulum Rehberi
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

## C4E Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak C4E fullnode'unuzu birkaç dakika içinde kurabilirsiniz.
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O C4E.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/C4E/C4E && chmod +x C4E.sh && ./C4E.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız.
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
c4ed status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
c4ed keys add $C4E_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
c4ed keys add $C4E_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
c4ed keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
C4E_WALLET_ADDRESS=$(c4ed keys show $C4E_WALLET -a)
C4E_VALOPER_ADDRESS=$(c4ed keys show $C4E_WALLET --bech val -a)
echo 'export C4E_WALLET_ADDRESS='${C4E_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export C4E_VALOPER_ADDRESS='${C4E_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 c4e'ye sahip olduğunuzdan (1 c4e 1000000 uc4e'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
c4ed query bank balances $C4E_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:
```
c4ed tx staking create-validator \
  --amount 1999000uc4e \
  --from $C4E_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(c4ed tendermint show-validator) \
  --moniker $C4E_NODENAME \
  --chain-id $C4E_ID \
  --fees 250uc4e
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu c4ed -o cat
```

Servisi Başlat:
```
systemctl start c4ed
```

Servisi Durdur:
```
systemctl stop c4ed
```

Servisi Yeniden Başlat:
```
systemctl restart c4ed
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
c4ed status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
c4ed status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
c4ed status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
c4ed tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
c4ed keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
c4ed keys add $C4E_WALLET --recover
```

Cüzdan Silme:
```
c4ed keys delete $C4E_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
c4ed query bank balances $C4E_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
c4ed tx bank send $C4E_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uc4e
```

### Oylama
```
c4ed tx gov vote 1 yes --from $C4E_WALLET --chain-id=$C4E_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
c4ed tx staking delegate $C4E_VALOPER_ADDRESS 10000000uc4e --from=$C4E_WALLET --chain-id=$C4E_ID --gas=auto --fees 250uc4e
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
c4ed tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uc4e --from=$C4E_WALLET --chain-id=$C4E_ID --gas=auto --fees 250uc4e
```

Tüm ödülleri çek:
```
c4ed tx distribution withdraw-all-rewards --from=$C4E_WALLET --chain-id=$C4E_ID --gas=auto --fees 250uc4e
```

Komisyon ile ödülleri geri çekin:
```
c4ed tx distribution withdraw-rewards $C4E_VALOPER_ADDRESS --from=$C4E_WALLET --commission --chain-id=$C4E_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
c4ed tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$C4E_ID \
--from=$C4E_WALLET
```

Hapisten Kurtul(Unjail):
```
c4ed tx slashing unjail \
  --broadcast-mode=block \
  --from=$C4E_WALLET \
  --chain-id=$C4E_ID \
  --gas=auto --fees 250uc4e
```


Node Tamamen Silmek:
```
sudo systemctl stop c4ed
sudo systemctl disable c4ed
sudo rm /etc/systemd/system/c4ed* -rf
sudo rm $(which c4ed) -rf
sudo rm $HOME/c4e-chain* -rf
sudo rm $HOME/.c4e -rf
sed -i '/C4E_/d' ~/.bash_profile
```
