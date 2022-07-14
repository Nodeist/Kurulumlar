 <p style="font-size:14px" align="right">
Sağ üst köşeden forklamayı ve yıldız vermeyi unutmayın ;) <br> <img src="https://i.hizliresim.com/njbmdlb.png"/></p>
<p style="font-size:14px" align="center">
<b>Bu sayfa, çeşitli kripto proje sunucularının nasıl çalıştırılacağına ilişkin eğitimler içerir. </b><br><br>
<a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="64"/></a> <br>Telegrama Katıl. <br>
<a href="https://nodeist.net/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="64"/></a> <br>Websitemizi Ziyaret et. 
</p>

## Donanım Gereksinimleri
Herhangi bir Cosmos-SDK zinciri gibi, donanım gereksinimleri de oldukça mütevazı.

### Minimum Donanım Gereksinimleri
 - 3x CPU; saat hızı ne kadar yüksek olursa o kadar iyi
 - 4GB RAM
 - 80GB Disk
 - Kalıcı İnternet bağlantısı (testnet sırasında trafik minimum 10Mbps bol olacak - üretim için en az 100Mbps bekleniyor)

### Önerilen Donanım Gereksinimleri
 - 4x CPU; saat hızı ne kadar yüksek olursa o kadar iyi
 - 8GB RAM
 - 200 GB depolama (SSD veya NVME)
 - Kalıcı İnternet bağlantısı (testnet sırasında trafik minimum 10Mbps bol olacak - üretim için en az 100Mbps bekleniyor)


# Teritori Node Kurulumu — teritori-testnet-v2

## Teritori Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Teritori fullnode'unuzu birkaç dakika içinde kurabilirsiniz. Doğrulayıcı düğüm adınızı(NODE NAME) girmenizi isteyecektir!


```
wget -O NodeistTeritori.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Teritori/NodeistTeritori.sh && chmod +x NodeistTeritori.sh && ./NodeistTeritori.sh
```

### Kurulum Sonrası Adımlar
Kurulum bittiğinde lütfen değişkenleri sisteme yükleyin:
```
source $HOME/.bash_profile
```

Ardından, doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
teritorid status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı(mnemonic) kaydetmeyi unutmayın.
```
teritorid keys add $WALLET
```

(İSTEĞE BAĞLI) Cüzdanınızı hatırlatıcı(mnemonic) kullanarak kurtarmak için:
```
teritorid keys add $WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
teritorid keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
WALLET_ADDRESS=$(teritorid keys show $WALLET -a)
```

Valoper Adresi Ekleyin:
```
VALOPER_ADDRESS=$(teritorid keys show $WALLET --bech val -a)
```

Değişkenleri sisteme yükleyin:
```
echo 'export WALLET_ADDRESS='${WALLET_ADDRESS} >> $HOME/.bash_profile

echo 'export VALOPER_ADDRESS='${VALOPER_ADDRESS} >> $HOME/.bash_profile

source $HOME/.bash_profile
```

### Musluğu kullanarak cüzdan bakiyenizi arttırın
Doğrulayıcı oluşturmak için önce cüzdanınıza testnet jetonları ile para yatırmanız gerekir. Cüzdanınızı doldurmak için Teritori discord sunucusuna katılın. Uygun kanalda olduğunuzdan emin olun.

Musluktan token talep etmek için:
```
$request <YOUR_TERITORI_ADDRESS>
```



### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 tori'ye sahip olduğunuzdan (1 tori 1000000 utori'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
teritorid query bank balances $WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcıyı çalıştırma komutunu yazalım:
```
teritorid tx staking create-validator \
 --commission-max-change-rate=0.01 \
 --commission-max-rate=0.2 \
 --commission-rate=0.05 \
 --amount 1000000utori \
 --pubkey=$(teritorid tendermint show-validator) \
 --moniker=$NODENAME \
 --chain-id=$CHAIN_ID \
 --min-self-delegation=1000000 \
 --from=$WALLET
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
curl -sS http://localhost:36457/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu teritorid -o cat
```

Servisi Başlat:
```
systemctl start teritorid
```

Servisi Durdur:
```
systemctl stop teritorid
```

Servisi Yeniden Başlat:
```
systemctl restart teritorid
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
teritorid status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
teritorid status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
teritorid status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
teritorid tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
teritorid keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
teritorid keys add $WALLET --recover
```

Cüzdan Silme:
```
teritorid keys delete $WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
teritorid query bank balances $WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
teritorid tx bank send $WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ufetf
```

### Oylama
```
teritorid tx gov vote 1 yes --from $WALLET --chain-id=$CHAIN_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
teritorid tx staking delegate $VALOPER_ADDRESS 10000000ufetf --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
teritorid tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ufetf --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Tüm ödülleri çek:
```
teritorid tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Komisyon ile ödülleri geri çekin:
```
teritorid tx distribution withdraw-rewards $VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$CHAIN_ID
```

### Doğrulayıcı Yönetimi
Validatör İsmini Değiştir:
```
teritorid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$CHAIN_ID \
--from=$WALLET
```

Hapisten Kurtul(Unjail): 
```
teritorid tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$CHAIN_ID \
  --gas=auto
```


Node Tamamen Silmek:
```
sudo systemctl stop teritorid && \
sudo systemctl disable teritorid && \
rm /etc/systemd/system/teritorid.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .teritorid teritorid && \
rm -rf $(which teritorid)
```
