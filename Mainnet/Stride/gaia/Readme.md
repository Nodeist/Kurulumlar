# Node Setup TR

[<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

[<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e\&utm\_campaign=Referral\_Invite\&utm\_medium=Referral\_Program\&utm\_source=badge)

![](https://i.hizliresim.com/qa5txaz.png)

## Gaia Kurulum Rehberi

### Donanım Gereksinimleri

Herhangi bir Cosmos-SDK zinciri gibi, donanım gereksinimleri de oldukça mütevazı.

#### Minimum Donanım Gereksinimleri

* 3x CPU; saat hızı ne kadar yüksek olursa o kadar iyi
* 4GB RAM
* 80GB Disk
* Kalıcı İnternet bağlantısı (testnet sırasında trafik minimum 10Mbps olacak - üretim için en az 100Mbps bekleniyor)

#### Önerilen Donanım Gereksinimleri

* 4x CPU; saat hızı ne kadar yüksek olursa o kadar iyi
* 8GB RAM
* 200 GB depolama (SSD veya NVME)
* Kalıcı İnternet bağlantısı (testnet sırasında trafik minimum 10Mbps olacak - üretim için en az 100Mbps bekleniyor)

### Gaia Full Node Kurulum Adımları

#### Tek Script İle Otomatik Kurulum

Aşağıdaki otomatik komut dosyasını kullanarak Gaia fullnode'unuzu birkaç dakika içinde kurabilirsiniz. Script sırasında size node isminiz (NODENAME) sorulacak!

```
wget -O GAIA.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Stride/gaia/GAIA && chmod +x GAIA.sh && ./GAIA.sh
```

#### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.

```
gaiad status 2>&1 | jq .SyncInfo
```

#### Cüzdan Oluşturma

Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.

```
gaiad keys add $GAIA_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:

```
gaiad keys add $GAIA_WALLET --recover
```

Mevcut cüzdan listesini almak için:

```
gaiad keys list
```

#### Cüzdan Bilgilerini Kaydet

Cüzdan Adresi Ekleyin:

```
GAIA_WALLET_ADDRESS=$(gaiad keys show $GAIA_WALLET -a)
GAIA_VALOPER_ADDRESS=$(gaiad keys show $GAIA_WALLET --bech val -a)
echo 'export GAIA_WALLET_ADDRESS='${GAIA_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export GAIA_VALOPER_ADDRESS='${GAIA_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

#### Doğrulayıcı oluştur

Doğrulayıcı oluşturmadan önce lütfen en az 1 atom'ye sahip olduğunuzdan (1 atom 1000000 uatom'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:

```
gaiad query bank balances $GAIA_WALLET_ADDRESS
```

> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:

```
gaiad tx staking create-validator \
  --amount 1999000uatom \
  --from $GAIA_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(gaiad tendermint show-validator) \
  --moniker $GAIA_NODENAME \
  --chain-id $GAIA_ID \
  --fees 250uatom
```


### Kullanışlı Komutlar

#### Servis Yönetimi

Logları Kontrol Et:

```
journalctl -fu gaiad -o cat
```

Servisi Başlat:

```
systemctl start gaiad
```

Servisi Durdur:

```
systemctl stop gaiad
```

Servisi Yeniden Başlat:

```
systemctl restart gaiad
```

#### Node Bilgileri

Senkronizasyon Bilgisi:

```
gaiad status 2>&1 | jq .SyncInfo
```

Validator Bilgisi:

```
gaiad status 2>&1 | jq .ValidatorInfo
```

Node Bilgisi:

```
gaiad status 2>&1 | jq .NodeInfo
```

Node ID Göser:

```
gaiad tendermint show-node-id
```

#### Cüzdan İşlemleri

Cüzdanları Listele:

```
gaiad keys list
```

Mnemonic kullanarak cüzdanı kurtar:

```
gaiad keys add $GAIA_WALLET --recover
```

Cüzdan Silme:

```
gaiad keys delete $GAIA_WALLET
```

Cüzdan Bakiyesi Sorgulama:

```
gaiad query bank balances $GAIA_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:

```
gaiad tx bank send $GAIA_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uatom
```

#### Oylama

```
gaiad tx gov vote 1 yes --from $GAIA_WALLET --chain-id=$GAIA_ID
```

#### Stake, Delegasyon ve Ödüller

Delegate İşlemi:

```
gaiad tx staking delegate $GAIA_VALOPER_ADDRESS 10000000uatom --from=$GAIA_WALLET --chain-id=$GAIA_ID --gas=auto --fees 250uatom
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:

```
gaiad tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uatom --from=$GAIA_WALLET --chain-id=$GAIA_ID --gas=auto --fees 250uatom
```

Tüm ödülleri çek:

```
gaiad tx distribution withdraw-all-rewards --from=$GAIA_WALLET --chain-id=$GAIA_ID --gas=auto --fees 250uatom
```

Komisyon ile ödülleri geri çekin:

```
gaiad tx distribution withdraw-rewards $GAIA_VALOPER_ADDRESS --from=$GAIA_WALLET --commission --chain-id=$GAIA_ID
```

#### Doğrulayıcı Yönetimi

Validatör İsmini Değiştir:

```
gaiad tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$GAIA_ID \
--from=$GAIA_WALLET
```

Hapisten Kurtul(Unjail):

```
gaiad tx slashing unjail \
  --broadcast-mode=block \
  --from=$GAIA_WALLET \
  --chain-id=$GAIA_ID \
  --gas=auto --fees 250uatom
```

Node Tamamen Silmek:

```
sudo systemctl stop gaiad
sudo systemctl disable gaiad
sudo rm /etc/systemd/system/gaia* -rf
sudo rm $(which gaiad) -rf
sudo rm $HOME/.gaia* -rf
sudo rm $HOME/gaia -rf
sed -i '/GAIA_/d' ~/.bash_profile
```

