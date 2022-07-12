 <p style="font-size:14px" align="right">
Sağ üst köşeden forklamayı ve yıldız vermeyi unutmayın ;) <br> <img src="https://i.hizliresim.com/njbmdlb.png"/></p>
<p style="font-size:14px" align="center">
<b>Bu sayfa, çeşitli kripto proje sunucularının nasıl çalıştırılacağına ilişkin eğitimler içerir. </b><br><br>
<a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="64"/></a> <br>Telegrama Katıl. <br>
<a href="https://nodeist.net/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="64"/></a> <br>Websitemizi Ziyaret et. 
</p>

# kyve Node Kurulumu — korellia


Gezgin:
>-  [Nodes Guru kyve Explorer](https://kyve.explorers.guru/)


## Donanım Gereksinimleri
Herhangi bir Cosmos-SDK zinciri gibi, donanım gereksinimleri de oldukça mütevazı.

### Minimum Donanım Gereksinimleri
 - 3x CPU; saat hızı ne kadar yüksek olursa o kadar iyi
 - 4GB RAM
 - 200GB Disk
 - Kalıcı İnternet bağlantısı (testnet sırasında trafik minimum 10Mbps olacak - üretim için en az 100Mbps bekleniyor)

### Önerilen Donanım Gereksinimleri
 - 4x CPU; saat hızı ne kadar yüksek olursa o kadar iyi
 - 8GB RAM
 - 400 GB depolama (SSD veya NVME)
 - Kalıcı İnternet bağlantısı (testnet sırasında trafik minimum 10Mbps olacak - üretim için en az 100Mbps bekleniyor)


## kyve Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak kyve fullnode'unuzu birkaç dakika içinde kurabilirsiniz. Doğrulayıcı düğüm adınızı(NODE NAME) girmenizi isteyecektir!


```
wget -O Nodeistkyve.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Kyve/Nodeistkyve.sh && chmod +x Nodeistkyve.sh && ./Nodeistkyve.sh
```

### Kurulum Sonrası Adımlar
Kurulum bittiğinde lütfen değişkenleri sisteme yükleyin:
```
source $HOME/.bash_profile
```

### Kyve chain node database snapshot: (900MB)
Height: 1271244
```
URL="https://snapshot.testnet.run/testnet/kyve/korellia_2022-07-02_1271244.tar.lz4"
wget -O - $URL | lz4 -d | tar -xvf - -C $HOME/.kyve/data
```

Ardından, doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
kyved status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı(mnemonic) kaydetmeyi unutmayın.
```
kyved keys add $WALLET
```

(İSTEĞE BAĞLI) Cüzdanınızı hatırlatıcı(mnemonic) kullanarak kurtarmak için:
```
kyved keys add $WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
kyved keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
WALLET_ADDRESS=$(kyved keys show $WALLET -a)
```

Valoper Adresi Ekleyin:
```
VALOPER_ADDRESS=$(kyved keys show $WALLET --bech val -a)
```

Değişkenleri sisteme yükleyin:
```
echo 'export WALLET_ADDRESS='${WALLET_ADDRESS} >> $HOME/.bash_profile

echo 'export VALOPER_ADDRESS='${VALOPER_ADDRESS} >> $HOME/.bash_profile

source $HOME/.bash_profile
```

### Cüzdanınıza para yatırın
Doğrulayıcı oluşturmak için önce cüzdanınıza testnet jetonları ile para yatırmanız gerekir.

kyve testnet'in genesis düğümünde (3.22.112.181) bir musluk sunucusu çalışıyor. Cüzdan adresinize coin istemek için, musluk sunucusuna bir HTTP isteği göndermeniz yeterlidir.

Musluktan token talep etmek için:
```
curl -X POST -d '{"address": "<WALLET_ADDRESS>", "coins": ["1000000ukyve"]}' http://3.22.112.181:8000
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 kyve'ye sahip olduğunuzdan (1 kyve 1000000 ukyve'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
kyved query bank balances $WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcıyı çalıştırma komutunu yazalım:
```
kyved tx staking create-validator \
  --amount 1000000ukyve \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(kyved tendermint show-validator) \
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
journalctl -fu kyved -o cat
```

Servisi Başlat:
```
systemctl start kyved
```

Servisi Durdur:
```
systemctl stop kyved
```

Servisi Yeniden Başlat:
```
systemctl restart kyved
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
kyved status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
kyved status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
kyved status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
kyved tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
kyved keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
kyved keys add $WALLET --recover
```

Cüzdan Silme:
```
kyved keys delete $WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
kyved query bank balances $WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
kyved tx bank send $WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ukyve
```

### Oylama
```
kyved tx gov vote 1 yes --from $WALLET --chain-id=$CHAIN_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
kyved tx staking delegate $VALOPER_ADDRESS 10000000ukyve --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
kyved tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ukyve --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Tüm ödülleri çek:
```
kyved tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Komisyon ile ödülleri geri çekin:
```
kyved tx distribution withdraw-rewards $VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$CHAIN_ID
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
kyved tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$CHAIN_ID \
  --gas=auto
```

Node Tamamen Silmek:
```
sudo systemctl stop kyved && \
sudo systemctl disable kyved && \
rm /etc/systemd/system/kyved.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .kyve kyve && \
rm -rf $(which kyved)
```
