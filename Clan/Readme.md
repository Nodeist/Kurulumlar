<p style="font-size:14px" align="right">
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.com/" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/a1520438004a799bba57311cd0cfc1f9a047691e/logo.png" width="60"/></a><br> Websitemizi Ziyaret Et 
</p>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Clan/logo.webp">
</p>

# clan Node Kurulumu — clan-private-1

Gezgin:
>-  https://clan.explorers.guru/

## clan Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak clan fullnode'unuzu birkaç dakika içinde kurabilirsiniz. Doğrulayıcı düğüm adınızı(NODE NAME) girmenizi isteyecektir!


```
wget -O Nodeistclan.sh https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Clan/Nodeistclan.sh && chmod +x Nodeistclan.sh && ./Nodeistclan.sh
```

### Kurulum Sonrası Adımlar
Kurulum bittiğinde lütfen değişkenleri sisteme yükleyin:
```
source $HOME/.bash_profile
```

Ardından, doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
cland status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı(mnemonic) kaydetmeyi unutmayın.
```
cland keys add $WALLET
```

(İSTEĞE BAĞLI) Cüzdanınızı hatırlatıcı(mnemonic) kullanarak kurtarmak için:
```
cland keys add $WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
cland keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
WALLET_ADDRESS=$(cland keys show $WALLET -a)
```

Valoper Adresi Ekleyin:
```
VALOPER_ADDRESS=$(cland keys show $WALLET --bech val -a)
```

Değişkenleri sisteme yükleyin:
```
echo 'export WALLET_ADDRESS='${WALLET_ADDRESS} >> $HOME/.bash_profile

echo 'export VALOPER_ADDRESS='${VALOPER_ADDRESS} >> $HOME/.bash_profile

source $HOME/.bash_profile
```

### Musluğu kullanarak cüzdan bakiyenizi arttırın


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 clan'ye sahip olduğunuzdan (1 clan 1000000 uclan'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
cland query bank balances $WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcıyı çalıştırma komutunu yazalım:
```
cland tx staking create-validator \
  --amount 1000000uclan \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(cland tendermint show-validator) \
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

## Şu anda bağlı olan eşler listesini kimlikleri ile alın
```
curl -sS http://localhost:26657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
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
cland keys add $WALLET --recover
```

Cüzdan Silme:
```
cland keys delete $WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
cland query bank balances $WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
cland tx bank send $WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uclan
```

### Oylama
```
cland tx gov vote 1 yes --from $WALLET --chain-id=$CHAIN_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
cland tx staking delegate $VALOPER_ADDRESS 10000000uclan --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
cland tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uclan --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Tüm ödülleri çek:
```
cland tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Komisyon ile ödülleri geri çekin:
```
cland tx distribution withdraw-rewards $VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$CHAIN_ID
```

### Doğrulayıcı Yönetimi
Validatörü Düzenle:
```
cland tx staking edit-validator \
--moniker=$NODENAME \
--identity=C6A8BDD24F8EA6F5 \
--website="http://nodeist.com" \
--details="Professional node running, best uptime, low fees" \
--chain-id=$CHAIN_ID \
--from=$WALLET
```

Hapisten Kurtul(Unjail): 
```
cland tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$CHAIN_ID \
  --gas=auto
```
