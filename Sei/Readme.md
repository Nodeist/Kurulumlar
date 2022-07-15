<p style="font-size:14px" align="right">
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>



<p align="center">
  <img height="100" src="https://i.hizliresim.com/gsu0zju.png">
</p>

# Sei Kurulum Rehberi
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

## Sei Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Sei fullnode'unuzu birkaç dakika içinde kurabilirsiniz. 
Script sırasında size node isminiz (NODENAME) sorulacak!


```
wget -O SEI.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Sei/SEI && chmod +x SEI.sh && ./SEI.sh
```

### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. 
Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
seid status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.
```
seid keys add $SEI_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:
```
seid keys add $SEI_WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
seid keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
SEI_WALLET_ADDRESS=$(seid keys show $SEI_WALLET -a)
SEI_VALOPER_ADDRESS=$(seid keys show $SEI_WALLET --bech val -a)
echo 'export SEI_WALLET_ADDRESS='${SEI_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export SEI_VALOPER_ADDRESS='${SEI_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 sei'ye sahip olduğunuzdan (1 sei 1000000 usei'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
seid query bank balances $SEI_WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcı Oluşturma:
```
seid tx staking create-validator \
  --amount 1999000usei \
  --from $SEI_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(seid tendermint show-validator) \
  --moniker $SEI_NODENAME \
  --chain-id $SEI_ID \
  --fees 250usei
```



## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu seid -o cat
```

Servisi Başlat:
```
systemctl start seid
```

Servisi Durdur:
```
systemctl stop seid
```

Servisi Yeniden Başlat:
```
systemctl restart seid
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
seid status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
seid status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
seid status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
seid tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
seid keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
seid keys add $SEI_WALLET --recover
```

Cüzdan Silme:
```
seid keys delete $SEI_WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
seid query bank balances $SEI_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
seid tx bank send $SEI_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000usei
```

### Oylama
```
seid tx gov vote 1 yes --from $SEI_WALLET --chain-id=$SEI_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
seid tx staking delegate $SEI_VALOPER_ADDRESS 10000000usei --from=$SEI_WALLET --chain-id=$SEI_ID --gas=auto --fees 250usei
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
seid tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000usei --from=$SEI_WALLET --chain-id=$SEI_ID --gas=auto --fees 250usei
```

Tüm ödülleri çek:
```
seid tx distribution withdraw-all-rewards --from=$SEI_WALLET --chain-id=$SEI_ID --gas=auto --fees 250usei
```

Komisyon ile ödülleri geri çekin:
```
seid tx distribution withdraw-rewards $SEI_VALOPER_ADDRESS --from=$SEI_WALLET --commission --chain-id=$SEI_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
seid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$SEI_ID \
--from=$SEI_WALLET
```

Hapisten Kurtul(Unjail): 
```
seid tx slashing unjail \
  --broadcast-mode=block \
  --from=$SEI_WALLET \
  --chain-id=$SEI_ID \
  --gas=auto --fees 250usei
```


Node Tamamen Silmek:
```
sudo systemctl stop seid
sudo systemctl disable seid
sudo rm /etc/systemd/system/seid* -rf
sudo rm $(which seid) -rf
sudo rm $HOME/.sei* -rf
sudo rm $HOME/sei-chain -rf
sed -i '/SEI_/d' ~/.bash_profile
```
