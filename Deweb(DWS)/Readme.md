<p style="font-size:14px" align="right">
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://ahbaay.com/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>


<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Deweb(DWS)/dws.png">
</p>

# DWS Node Kurulumu — deweb-testnet-1

Resmi doküman:
>- [Validator Kurulum Rehberi](https://docs.deweb.services/guides/validator-setup-guide)

Gezgin:
>-  https://dws.explorers.guru/


## Deweb Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak deweb fullnode'unuzu birkaç dakika içinde kurabilirsiniz. Doğrulayıcı düğüm adınızı(NODE NAME) girmenizi isteyecektir!

```
wget -O NodeistDws.sh https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Deweb(DWS)/NodeistDws.sh && chmod +x NodeistDws.sh && ./NodeistDws.sh
```

### Kurulum Sonrası Adımlar
Kurulum bittiğinde lütfen değişkenleri sisteme yükleyin:
```
source $HOME/.bash_profile
```

Ardından, doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
dewebd status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı(mnemonic) kaydetmeyi unutmayın.
```
dewebd keys add $WALLET
```

(İSTEĞE BAĞLI) Cüzdanınızı hatırlatıcı(mnemonic) kullanarak kurtarmak için:
```
dewebd keys add $WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
dewebd keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
WALLET_ADDRESS=$(dewebd keys show $WALLET -a)
```

Valoper Adresi Ekleyin:
```
VALOPER_ADDRESS=$(dewebd keys show $WALLET --bech val -a)
```

Değişkenleri sisteme yükleyin:
```
echo 'export WALLET_ADDRESS='${WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export VALOPER_ADDRESS='${VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Musluğu kullanarak cüzdan bakiyenizi arttırın
Doğrulayıcı oluşturmak için önce cüzdanınıza testnet jetonları ile para yatırmanız gerekir. Cüzdanınızı doldurmak ve musluklara erişmek için deweb discord sunucusuna katılın. Uygun kanalda olduğunuzdan emin olun.

Musluktan token talep etmek için:
```
$request <YOUR_WALLET_ADDRESS> menkar
```
Bakiyenizi kontrol etmek için:
```
$balance <YOUR_WALLET_ADDRESS> menkar
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 qck'ye sahip olduğunuzdan (1 qck 1000000 uqck'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
dewebd query bank balances $WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 
Doğrulayıcıyı çalıştırma komutunu yazalım:
```
dewebd tx staking create-validator \
  --amount 1000000ufetf \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(dewebd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $CHAIN_ID
```

## Güvenlik
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
journalctl -fu dewebd -o cat
```

Servisi Başlat:
```
systemctl start dewebd
```

Servisi Durdur:
```
systemctl stop dewebd
```

Servisi Yeniden Başlat:
```
systemctl restart dewebd
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
dewebd status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
dewebd status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
dewebd status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
dewebd tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
dewebd keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
dewebd keys add $WALLET --recover
```

Cüzdan Silme:
```
dewebd keys delete $WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
dewebd query bank balances $WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
dewebd tx bank send $WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ufetf
```

### Oylama
```
dewebd tx gov vote 1 yes --from $WALLET --chain-id=$CHAIN_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
dewebd tx staking delegate $VALOPER_ADDRESS 10000000ufetf --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
dewebd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ufetf --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Tüm ödülleri çek:
```
dewebd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Komisyon ile ödülleri geri çekin:
```
dewebd tx distribution withdraw-rewards $VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$CHAIN_ID
```

### Doğrulayıcı Yönetimi
Validatörü Düzenle:
```
dewebd tx staking edit-validator \
--moniker=$NODENAME \
--identity=C6A8BDD24F8EA6F5 \
--website="http://nodeist.com" \
--details="Professional node running, best uptime, low fees" \
--chain-id=$CHAIN_ID \
--from=$WALLET
```

Hapisten Kurtul(Unjail): 
```
dewebd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$CHAIN_ID \
  --gas=auto
```


Node Tamamen Silmek:
```
sudo systemctl stop dewebd && \
sudo systemctl disable dewebd && \
rm /etc/systemd/system/dewebd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .deweb deweb && \
rm -rf $(which dewebd)
```
