<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/rebus.png">
</p>

### Rebus Kurulum Rehberi

#### Donanım Gereksinimleri

Herhangi bir Cosmos-SDK zinciri gibi, donanım gereksinimleri de oldukça mütevazı.

**Minimum Donanım Gereksinimleri**

* 3x CPU; saat hızı ne kadar yüksek olursa o kadar iyi
* 4GB RAM
* 80GB Disk
* Kalıcı İnternet bağlantısı (testnet sırasında trafik minimum 10Mbps olacak - üretim için en az 100Mbps bekleniyor)

**Önerilen Donanım Gereksinimleri**

* 4x CPU; saat hızı ne kadar yüksek olursa o kadar iyi
* 8GB RAM
* 200 GB depolama (SSD veya NVME)
* Kalıcı İnternet bağlantısı (testnet sırasında trafik minimum 10Mbps olacak - üretim için en az 100Mbps bekleniyor)

#### Rebus Full Node Kurulum Adımları

**Tek Script İle Otomatik Kurulum**

Aşağıdaki otomatik komut dosyasını kullanarak Rebus fullnode'unuzu birkaç dakika içinde kurabilirsiniz. Script sırasında size node isminiz (NODENAME) sorulacak!

```
wget -O RBS.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Rebus/RBS && chmod +x RBS.sh && ./RBS.sh
```

**Kurulum Sonrası Adımlar**

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.

```
rebusd status 2>&1 | jq .SyncInfo
```

**Cüzdan Oluşturma**

Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.

```
rebusd keys add $RBS_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:

```
rebusd keys add $RBS_WALLET --recover
```

Mevcut cüzdan listesini almak için:

```
rebusd keys list
```

**Cüzdan Bilgilerini Kaydet**

Cüzdan Adresi Ekleyin:

```
RBS_WALLET_ADDRESS=$(rebusd keys show $RBS_WALLET -a)
RBS_VALOPER_ADDRESS=$(rebusd keys show $RBS_WALLET --bech val -a)
echo 'export RBS_WALLET_ADDRESS='${RBS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export RBS_VALOPER_ADDRESS='${RBS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

**Doğrulayıcı oluştur**

Doğrulayıcı oluşturmadan önce lütfen en az 1 rebus'ye sahip olduğunuzdan (1 rebus 1000000 arebus'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:

```
rebusd query bank balances $RBS_WALLET_ADDRESS
```

> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:

```
rebusd tx staking create-validator \
  --amount 1000000arebus \
  --from $RBS_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(rebusd tendermint show-validator) \
  --moniker $RBS_NODENAME \
  --chain-id $RBS_ID \
  --fees 250arebus
```

#### Kullanışlı Komutlar

**Servis Yönetimi**

Logları Kontrol Et:

```
journalctl -fu rebusd -o cat
```

Servisi Başlat:

```
systemctl start rebusd
```

Servisi Durdur:

```
systemctl stop rebusd
```

Servisi Yeniden Başlat:

```
systemctl restart rebusd
```

**Node Bilgileri**

Senkronizasyon Bilgisi:

```
rebusd status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:

```
rebusd status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:

```
rebusd status 2>&1 | jq .NodeInfo
```

Node ID Göser:

```
rebusd tendermint show-node-id
```

**Cüzdan İşlemleri**

Cüzdanları Listele:

```
rebusd keys list
```

Mnemonic kullanarak cüzdanı kurtar:

```
rebusd keys add $RBS_WALLET --recover
```

Cüzdan Silme:

```
rebusd keys delete $RBS_WALLET
```

Cüzdan Bakiyesi Sorgulama:

```
rebusd query bank balances $RBS_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:

```
rebusd tx bank send $RBS_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000arebus
```

**Oylama**

```
rebusd tx gov vote 1 yes --from $RBS_WALLET --chain-id=$RBS_ID
```

**Stake, Delegasyon ve Ödüller**

Delegate İşlemi:

```
rebusd tx staking delegate $RBS_VALOPER_ADDRESS 10000000arebus --from=$RBS_WALLET --chain-id=$RBS_ID --gas=auto --fees 250arebus
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:

```
rebusd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000arebus --from=$RBS_WALLET --chain-id=$RBS_ID --gas=auto --fees 250arebus
```

Tüm ödülleri çek:

```
rebusd tx distribution withdraw-all-rewards --from=$RBS_WALLET --chain-id=$RBS_ID --gas=auto --fees 250arebus
```

Komisyon ile ödülleri geri çekin:

```
rebusd tx distribution withdraw-rewards $RBS_VALOPER_ADDRESS --from=$RBS_WALLET --commission --chain-id=$RBS_ID
```

**Doğrulayıcı Yönetimi**

Validatör İsmini Değiştir:

```
rebusd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$RBS_ID \
--from=$RBS_WALLET
```

Hapisten Kurtul(Unjail):

```
rebusd tx slashing unjail \
  --broadcast-mode=block \
  --from=$RBS_WALLET \
  --chain-id=$RBS_ID \
  --gas=auto --fees 250arebus
```

Node Tamamen Silmek:

```
sudo systemctl stop rebusd
sudo systemctl disable rebusd
sudo rm /etc/systemd/system/rebusd* -rf
sudo rm $(which rebusd) -rf
sudo rm $HOME/.rebusd* -rf
sudo rm $HOME/rebus.core -rf
sed -i '/RBS_/d' ~/.bash_profile
```
