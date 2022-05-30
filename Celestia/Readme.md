<p style="font-size:14px" align="right">
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Celestia/1.png">
</p>

# Celestia Node Kurulumu — mamaki


Gezgin:
>-  [Nodes Guru celestia Explorer](https://celestia.explorers.guru/)


## celestia Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak celestia fullnode'unuzu birkaç dakika içinde kurabilirsiniz. Doğrulayıcı düğüm adınızı(NODE NAME) girmenizi isteyecektir!


```
wget -O Nodeistcelestia.sh https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Celestia/Nodeistcelestia.sh && chmod +x Nodeistcelestia.sh && ./Nodeistcelestia.sh
```

### Kurulum Sonrası Adımlar
Kurulum bittiğinde lütfen değişkenleri sisteme yükleyin:
```
source $HOME/.bash_profile
```

Ardından, doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
celestia-appd status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı(mnemonic) kaydetmeyi unutmayın.
```
celestia-appd keys add $WALLET
```

(İSTEĞE BAĞLI) Cüzdanınızı hatırlatıcı(mnemonic) kullanarak kurtarmak için:
```
celestia-appd keys add $WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
celestia-appd keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
WALLET_ADDRESS=$(celestia-appd keys show $WALLET -a)
```

Valoper Adresi Ekleyin:
```
VALOPER_ADDRESS=$(celestia-appd keys show $WALLET --bech val -a)
```

Değişkenleri sisteme yükleyin:
```
echo 'export WALLET_ADDRESS='${WALLET_ADDRESS} >> $HOME/.bash_profile

echo 'export VALOPER_ADDRESS='${VALOPER_ADDRESS} >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Cüzdanınıza para yatırın

Doğrulayıcı oluşturmak için önce cüzdanınıza testnet jetonları ile para yatırmanız gerekir. 
Cüzdanınızı doldurmak için [Celestia discord sunucusuna katılın](https://discord.gg/QAsD8j4Z) ve NODE OPERATORS kategorisi altındaki #faucet kanalına gidin.

```
$request <YOUR_WALLET_ADDRESS>
```



### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 tia'ye sahip olduğunuzdan (1 celestia 1000000 utia'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
celestia-appd query bank balances $WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcıyı çalıştırma komutunu yazalım:
```
celestia-appd tx staking create-validator \
  --amount 1000000utia \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(celestia-appd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $CHAIN_ID
```

## Güvenlik (Opsiyonel)
Anahtarlarınızı korumak için lütfen temel güvenlik kurallarına uyduğunuzdan emin olun.

### Kimlik doğrulama için ssh anahtarlarını ayarlayın
Sunucunuza kimlik doğrulaması için ssh anahtarlarının nasıl kurulacağına dair iyi bir eğitim [burada bulunabilir](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04)

### Temel Güvenlik Duvarı güvenliği
ufw'nin durumunu kontrol ederek başlayın.
```
sudo ufw status
```

Varsayılanı, giden bağlantılara izin verecek, ssh ve 26656 hariç tüm gelenleri reddedecek şekilde ayarlayın. SSH oturum açma girişimlerini sınırlayın.
```
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw allow 26656,26660/tcp
sudo ufw enable
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
celestia-appd keys add $WALLET --recover
```

Cüzdan Silme:
```
celestia-appd keys delete $WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
celestia-appd query bank balances $WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
celestia-appd tx bank send $WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000utia
```

### Oylama
```
celestia-appd tx gov vote 1 yes --from $WALLET --chain-id=$CHAIN_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
celestia-appd tx staking delegate $VALOPER_ADDRESS 10000000utia --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
celestia-appd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utia --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Tüm ödülleri çek:
```
celestia-appd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Komisyon ile ödülleri geri çekin:
```
celestia-appd tx distribution withdraw-rewards $VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$CHAIN_ID
```

### Doğrulayıcı Yönetimi
Validatörü Düzenle:
```
celestia-appd tx staking edit-validator \
--moniker=$NODENAME \
--identity=C6A8BDD24F8EA6F5 \
--website="https://nodeist.site" \
--details="Professional node running, best uptime, low fees" \
--chain-id=$CHAIN_ID \
--from=$WALLET
```

Hapisten Kurtul(Unjail): 
```
celestia-appd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$CHAIN_ID \
  --gas=auto
```


Node Tamamen Silmek: 
```
sudo systemctl stop celestia-appd && \
sudo systemctl disable celestia-appd && \
rm /etc/systemd/system/celestia-appd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .celestia-app celestia-app && \
rm -rf $(which celestia-appd)
```
