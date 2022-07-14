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


# Stride Node Kurulumu — STRIDE-1



## Stride Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Stride fullnode'unuzu birkaç dakika içinde kurabilirsiniz. Doğrulayıcı düğüm adınızı(NODE NAME) girmenizi isteyecektir!


```
wget -O NodeistStride.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Stride/NodeistStride.sh && chmod +x NodeistStride.sh && ./NodeistStride.sh
```

### Kurulum Sonrası Adımlar
Kurulum bittiğinde lütfen değişkenleri sisteme yükleyin:
```
source $HOME/.bash_profile
```

Ardından, doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
strided status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı(mnemonic) kaydetmeyi unutmayın.
```
strided keys add $WALLET
```

(İSTEĞE BAĞLI) Cüzdanınızı hatırlatıcı(mnemonic) kullanarak kurtarmak için:
```
strided keys add $WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
strided keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
WALLET_ADDRESS=$(strided keys show $WALLET -a)
```

Valoper Adresi Ekleyin:
```
VALOPER_ADDRESS=$(strided keys show $WALLET --bech val -a)
```

Değişkenleri sisteme yükleyin:
```
echo 'export WALLET_ADDRESS='${WALLET_ADDRESS} >> $HOME/.bash_profile

echo 'export VALOPER_ADDRESS='${VALOPER_ADDRESS} >> $HOME/.bash_profile

source $HOME/.bash_profile
```

### Musluğu kullanarak cüzdan bakiyenizi arttırın
Doğrulayıcı oluşturmak için önce cüzdanınıza testnet jetonları ile para yatırmanız gerekir. 
Discord sunucusunda faucet kanalından token talep edin.

Musluktan token talep etmek için:
```
$faucet:<YOUR_WALLET_ADDRESS>
```

Bakiyenizi kontrol edin:
```
$balance:<YOUR_WALLET_ADDRESS>
```


### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 strd'ye sahip olduğunuzdan (1 strd 1000000 ustrd'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
strided query bank balances $WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcıyı çalıştırma komutunu yazalım:
```
  strided tx staking create-validator \
    --amount 10000000ustrd \
    --from $WALLET \
    --commission-max-change-rate "0.01" \
    --commission-max-rate "0.2" \
    --commission-rate "0.07" \
    --min-self-delegation "1" \
    --pubkey  $(strided tendermint show-validator) \
    --moniker $NODENAME \
    --chain-id $STRIDE_CHAIN_ID
```

## Likit hisseli işlemler
### Likidite stake edin
Likidite, ATOM'unuzu stATOM için Stride'da stake edin:
```
strided tx stakeibc liquid-stake 1000 uatom --from $WALLET --chain-id $STRIDE_CHAIN_ID
```

> Not: 1000 uatom likit stake yaparsanız, karşılığında sadece 990 (az ya da çok olabilir) stATOM alabilirsiniz! Bunun nedeni döviz kurumuzun çalışma şeklidir. 990 stATOM'unuz hala 1000 uatom değerindedir (veya stake ödülleri kazandıkça daha fazla!)

### Redeem işlemi
Bazı staking ödüllerini topladıktan sonra, jetonlarınızı geri alabilirsiniz. Şu anda Gaia (Cosmos Hub) test ağımızdaki bağlanma süresi yaklaşık 30 dakikadır.
```
strided tx stakeibc redeem-stake 999 GAIA <cosmos_address_you_want_to_redeem_to> --chain-id $STRIDE_CHAIN_ID --from $WALLET
```

### Jetonların talep edilebilir olup olmadığını kontrol edin
Belirteçlerinizin talep edilmeye hazır olup olmadığını görmek istiyorsanız, "<your_stride_account>" ile anahtarlanmış "UserRedemptionRecord"unuzu arayın.
```
strided q records list-user-redemption-record --output json | jq --arg WALLET_ADDRESS "$STRIDE_WALLET_ADDRESS" '.UserRedemptionRecord | map(select(.sender == $WALLET_ADDRESS))'
```
Kaydınız "isClaimable=true" özelliğine sahipse, hak talebinde bulunulmaya hazırdır!

### Talep belirteçleri
Belirteçlerinizin bağı çözüldükten sonra, talep sürecini tetikleyerek talep edilebilirler.
```
strided tx stakeibc claim-undelegated-tokens GAIA 5 --chain-id $STRIDE_CHAIN_ID --from $WALLET
```
> Not: Bu işlev, bir FIFO kuyruğundaki talepleri tetikler, yani talebiniz 20. sıradaysa, jetonlarınızın hesabınızda görünmesini görmeden önce diğer talepleri işleme koymuş olursunuz.



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
journalctl -fu strided -o cat
```

Servisi Başlat:
```
systemctl start strided
```

Servisi Durdur:
```
systemctl stop strided
```

Servisi Yeniden Başlat:
```
systemctl restart strided
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
strided status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
strided status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
strided status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
strided tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
strided keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
strided keys add $WALLET --recover
```

Cüzdan Silme:
```
strided keys delete $WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
strided query bank balances $WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
strided tx bank send $WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ustrd
```

### Oylama
```
strided tx gov vote 1 yes --from $WALLET --chain-id=$CHAIN_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
strided tx staking delegate $VALOPER_ADDRESS 10000000ustrd --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
strided tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ustrd --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Tüm ödülleri çek:
```
strided tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Komisyon ile ödülleri geri çekin:
```
strided tx distribution withdraw-rewards $VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$CHAIN_ID
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
strided tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$CHAIN_ID \
  --gas=auto
```


Node Tamamen Silmek:
```
sudo systemctl stop strided
sudo systemctl disable strided
sudo rm /etc/systemd/system/stride* -rf
sudo rm $(which strided) -rf
sudo rm $HOME/.stride* -rf
sudo rm $HOME/stride -rf
sed -i '/STRIDE_/d' ~/.bash_profile
```
