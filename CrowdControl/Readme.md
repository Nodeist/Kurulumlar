<p style="font-size:14px" align="right">
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>


<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/165055511-83e8a2d3-1700-4d26-af27-abcc825573a7.png">
</p>

# CrowdControl Node Kurulumu — Cardchain


Gezgin:
>-  https://Cardchain.explorers.guru/

## Donanım Gereksinimleri
- Bellek: 8 GB RAM
- CPU: Dört Çekirdekli
- Disk: 250 GB SSD Depolama
- Bant Genişliği: İndirme için 1 Gbps/Yükleme için 100 Mbps

## Cardchain Full Node Kurulum Adımları
### Tek Script İle Otomatik Kurulum
Aşağıdaki otomatik komut dosyasını kullanarak Cardchain fullnode'unuzu birkaç dakika içinde kurabilirsiniz. Doğrulayıcı düğüm adınızı(NODE NAME) girmenizi isteyecektir!


```
wget -O NodeistCardchain.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Cardchain/NodeistCardchain.sh && chmod +x NodeistCardchain.sh && ./NodeistCardchain.sh
```

### Kurulum Sonrası Adımlar
Kurulum bittiğinde lütfen değişkenleri sisteme yükleyin:
```
source $HOME/.bash_profile
```

Ardından, doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.
```
cardchaind status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı(mnemonic) kaydetmeyi unutmayın.
```
cardchaind keys add $WALLET
```

(İSTEĞE BAĞLI) Cüzdanınızı hatırlatıcı(mnemonic) kullanarak kurtarmak için:
```
cardchaind keys add $WALLET --recover
```

Mevcut cüzdan listesini almak için:
```
cardchaind keys list
```

### Cüzdan Bilgilerini Kaydet
Cüzdan Adresi Ekleyin:
```
WALLET_ADDRESS=$(cardchaind keys show $WALLET -a)
```

Valoper Adresi Ekleyin:
```
VALOPER_ADDRESS=$(cardchaind keys show $WALLET --bech val -a)
```

Değişkenleri sisteme yükleyin:
```
echo 'export WALLET_ADDRESS='${WALLET_ADDRESS} >> $HOME/.bash_profile

echo 'export VALOPER_ADDRESS='${VALOPER_ADDRESS} >> $HOME/.bash_profile

source $HOME/.bash_profile
```

### Musluğu kullanarak cüzdan bakiyenizi arttırın
```
KEY=$(Cardchain keys show validator --output=json | jq .address -r)
curl -X POST https://cardchain.crowdcontrol.network/faucet/ -d "{\"address\": \"$KEY\"}"
```

### Doğrulayıcı oluştur
Doğrulayıcı oluşturmadan önce lütfen en az 1 bpf'ye sahip olduğunuzdan (1 fetf 1000000 ubpf'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:
```
cardchaind query bank balances $WALLET_ADDRESS
```
> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin. 

Doğrulayıcıyı çalıştırma komutunu yazalım:
```
Cardchain tx staking create-validator \
  --from=$WALLET \
  --amount=1000000ubpf \
  --moniker=$NODENAME \
  --chain-id=$CHAIN_ID \
  --commission-rate=0.1 \
  --commission-max-rate=0.5 \
  --commission-max-change-rate=0.1 \
  --min-self-delegation=1 \
  --pubkey=$(Cardchain tendermint show-validator) \
  --details="hello world" \
  --yes
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
journalctl -fu cardchaind -o cat
```

Servisi Başlat:
```
systemctl start cardchaind
```

Servisi Durdur:
```
systemctl stop cardchaind
```

Servisi Yeniden Başlat:
```
systemctl restart cardchaind
```

### Node Bilgileri
Senkronizasyon Bilgisi:
```
cardchaind status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:
```
cardchaind status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:
```
cardchaind status 2>&1 | jq .NodeInfo
```

Node ID Göser:
```
cardchaind tendermint show-node-id
```

### Cüzdan İşlemleri
Cüzdanları Listele:
```
cardchaind keys list
```

Mnemonic kullanarak cüzdanı kurtar:
```
cardchaind keys add $WALLET --recover
```

Cüzdan Silme:
```
cardchaind keys delete $WALLET
```

Cüzdan Bakiyesi Sorgulama:
```
cardchaind query bank balances $WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
cardchaind tx bank send $WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ubpf
```

### Oylama
```
cardchaind tx gov vote 1 yes --from $WALLET --chain-id=$CHAIN_ID
```

### Stake, Delegasyon ve Ödüller
Delegate İşlemi:
```
cardchaind tx staking delegate $VALOPER_ADDRESS 10000000ubpf --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:
```
cardchaind tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ubpf --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Tüm ödülleri çek:
```
cardchaind tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$CHAIN_ID --gas=auto
```

Komisyon ile ödülleri geri çekin:
```
cardchaind tx distribution withdraw-rewards $VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$CHAIN_ID
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
cardchaind tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$CHAIN_ID \
  --gas=auto
```

Node Tamamen Silmek:
```
sudo systemctl stop cardchaind && \
sudo systemctl disable cardchaind && \
rm /etc/systemd/system/cardchaind.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .Cardchain Cardchain && \
rm -rf $(which cardchaind)
```
