<p style="font-size:14px" align="right">
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/nnooddeeiisstt/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/nnooddeeiisstt/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>


<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/nnooddeeiisstt/Testnet_Kurulumlar/main/Quicksilver/166148846-93575afe-e3ce-4ca5-a3f7-a21e8a8609cb.png">
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


# Quicksilver Node Kurulumu — quicktest-5

Resmi doküman:
>- [Validator Kurulum Rehberi](https://github.com/ingenuity-build/testnets)

Gezgin:
>-  [Nodes Guru Quicksilver Explorer](https://quicksilver.explorers.guru/)


## Quicksilver Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak quicksilver fullnode'unuzu birkaç dakika içinde kurabilirsiniz. Doğrulayıcı düğüm adınızı(NODE NAME) girmenizi isteyecektir!


```
wget -O Nodeistquicksilver.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Quicksilver/Nodeistquicksilver.sh && chmod +x Nodeistquicksilver.sh && ./Nodeistquicksilver.sh
```

### Kurulum Sonrası Adımlar
Kurulum bittiğinde lütfen değişkenleri sisteme yükleyin:
```
source $HOME/.bash_profile
```

Ardından, doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
quicksilverd status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı(mnemonic) kaydetmeyi unutmayın.
```
quicksilverd keys add $WALLET
```

(İSTEĞE BAĞLI) Cüzdanınızı hatırlatıcı(mnemonic) kullanarak kurtarmak için:
```
quicksilverd keys add $WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
quicksilverd keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
WALLET_ADDRESS=$(quicksilverd keys show $WALLET -a)
```

Valoper Adresi Ekleyin:
```
VALOPER_ADDRESS=$(quicksilverd keys show $WALLET --bech val -a)
```

Değişkenleri sisteme yükleyin:
```
echo 'export WALLET_ADDRESS='${WALLET_ADDRESS} >> $HOME/.bash_profile

echo 'export VALOPER_ADDRESS='${VALOPER_ADDRESS} >> $HOME/.bash_profile

source $HOME/.bash_profile
```

### Musluğu kullanarak cüzdan bakiyenizi arttırın
Doğrulayıcı oluşturmak için önce cüzdanınıza testnet jetonları ile para yatırmanız gerekir. Cüzdanınızı doldurmak ve QCK - ATOM musluklarına erişmek için Quicksilver discord sunucusuna katılın. Uygun kanalda olduğunuzdan emin olun.

Musluktan token talep etmek için:
```
$request <YOUR_WALLET_ADDRESS> rhapsody
```
Bakiyenizi kontrol etmek için:
```
$balance <YOUR_WALLET_ADDRESS> rhapsody
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 qck'ye sahip olduğunuzdan (1 qck 1000000 uqck'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
quicksilverd query bank balances $WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcıyı çalıştırma komutunu yazalım:
```
quicksilverd tx staking create-validator \
  --amount 500000uqck \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(quicksilverd tendermint show-validator) \
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
wget -O senkronizesurehesapla.py https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/quicksilver/senkronizesurehesapla.py && python3 ./senkronizesurehesapla.py
```

## Şu anda bağlı olan eşler listesini kimlikleri ile alın
```
curl -sS http://localhost:26657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

## Kullanışlı Komutlar
### Servis Yönetimi
Logları Kontrol Et:
```
journalctl -fu quicksilverd -o cat
```

Servisi Başlat:
```
systemctl start quicksilverd
```

Servisi Durdur:
```
systemctl stop quicksilverd
```

Servisi Yeniden Başlat:
```
systemctl restart quicksilverd
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
quicksilverd status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
quicksilverd status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
quicksilverd status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
quicksilverd tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
quicksilverd keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
quicksilverd keys add $WALLET --recover
```

Cüzdan Silme:
```
quicksilverd keys delete $WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
quicksilverd query bank balances $WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
quicksilverd tx bank send $WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ufetf
```

### Oylama
```
quicksilverd tx gov vote 1 yes --from $WALLET --chain-id=$CHAIN_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
quicksilverd tx staking delegate $VALOPER_ADDRESS 10000000ufetf --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
quicksilverd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ufetf --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Tüm ödülleri çek:
```
quicksilverd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Komisyon ile ödülleri geri çekin:
```
quicksilverd tx distribution withdraw-rewards $VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$CHAIN_ID
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
quicksilverd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$CHAIN_ID \
  --gas=auto
```


Node Tamamen Silmek:
```
sudo systemctl stop quicksilverd && \
sudo systemctl disable quicksilverd && \
rm /etc/systemd/system/quicksilverd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .quicksilverd quicksilverd && \
rm -rf $(which quicksilverd)
```
