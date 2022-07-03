

# Anone Node Kurulumu — anone-testnet-1


Gezgin:
>-  https://anone.explorers.guru/

## Donanım Gereksinimleri
- Bellek: 8 GB RAM
- CPU: Dört Çekirdekli
- Disk: 250 GB SSD Depolama
- Bant Genişliği: İndirme için 1 Gbps/Yükleme için 100 Mbps

## Anone Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak defund fullnode'unuzu birkaç dakika içinde kurabilirsiniz. Doğrulayıcı düğüm adınızı(NODE NAME) girmenizi isteyecektir!


```
wget -O Nodeistanone.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Anone/Nodeistanone.sh && chmod +x Nodeistanone.sh && ./Nodeistanone.sh
```

### Kurulum Sonrası Adımlar
Kurulum bittiğinde lütfen değişkenleri sisteme yükleyin:
```
source $HOME/.bash_profile
```

Ardından, doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
anoned status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı(mnemonic) kaydetmeyi unutmayın.
```
anoned keys add $WALLET
```

(İSTEĞE BAĞLI) Cüzdanınızı hatırlatıcı(mnemonic) kullanarak kurtarmak için:
```
anoned keys add $WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
anoned keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
WALLET_ADDRESS=$(anoned keys show $WALLET -a)
```

Valoper Adresi Ekleyin:
```
VALOPER_ADDRESS=$(anoned keys show $WALLET --bech val -a)
```

Değişkenleri sisteme yükleyin:
```
echo 'export WALLET_ADDRESS='${WALLET_ADDRESS} >> $HOME/.bash_profile

echo 'export VALOPER_ADDRESS='${VALOPER_ADDRESS} >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 anl'ye sahip olduğunuzdan (1 anl 1000000 uanl'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
anoned query bank balances $WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcıyı çalıştırma komutunu yazalım:
```
anoned tx staking create-validator \
  --amount 1000000uanl \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(anoned tendermint show-validator) \
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

## Senkronizasyon süresini hesaplayın

Bu komut dosyası, düğümünüzü tam olarak senkronize etmenin ne kadar zaman alacağını tahmin etmenize yardımcı olacaktır. 
5 dakikalık bir süre boyunca senkronize edilen dakika başına ortalama blokları ölçer ve ardından size sonuçlar verir.
```
wget -O senkronizesurehesapla.py https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Defund/senkronizesurehesapla.py && python3 ./senkronizesurehesapla.py
```

## Şu anda bağlı olan eşler listesini kimlikleri ile alın
```
curl -sS http://localhost:26657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu anoned -o cat
```

Servisi Başlat:
```
systemctl start anoned
```

Servisi Durdur:
```
systemctl stop anoned
```

Servisi Yeniden Başlat:
```
systemctl restart anoned
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
anoned status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
anoned status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
anoned status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
anoned tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
anoned keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
anoned keys add $WALLET --recover
```

Cüzdan Silme:
```
anoned keys delete $WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
anoned query bank balances $WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
anoned tx bank send $WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uanl
```

### Oylama
```
anoned tx gov vote 1 yes --from $WALLET --chain-id=$CHAIN_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
anoned tx staking delegate $VALOPER_ADDRESS 10000000uanl --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
anoned tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uanl --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Tüm ödülleri çek:
```
anoned tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Komisyon ile ödülleri geri çekin:
```
anoned tx distribution withdraw-rewards $VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$CHAIN_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
seid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$CHAIN_ID \
--from=$WALLET
```

Hapisten Kurtul(Unjail): 
```
anoned tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$CHAIN_ID \
  --gas=auto
```

Node Tamamen Silmek:
```
sudo systemctl stop anoned && \
sudo systemctl disable anoned && \
rm /etc/systemd/system/anoned.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .anone defund && \
rm -rf $(which anoned)
```
