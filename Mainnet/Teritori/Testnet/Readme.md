<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/teritori.png">
</p>

## Teritori Kurulum Rehberi

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

Resmi belgeler:

> > [Doğrulayıcı kurulum talimatları](https://github.com/TERITORI/teritori-chain/blob/main/testnet/teritori-testnet-v2/README.md)

Gezgin:

> > https://teritori.explorers.guru/

### Teritori Full Node Kurulum Adımları

#### Tek Script İle Otomatik Kurulum

Aşağıdaki otomatik komut dosyasını kullanarak Teritori fullnode'unuzu birkaç dakika içinde kurabilirsiniz. Script sırasında size node isminiz (NODENAME) sorulacak!

```
wget -O TT.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Testnet/Teritori/TT && chmod +x TT.sh && ./TT.sh
```

#### Kurulum Sonrası Adımlar

Doğrulayıcınızın blokları senkronize ettiğinden emin olmalısınız. Senkronizasyon durumunu kontrol etmek için aşağıdaki komutu kullanabilirsiniz.

```
teritorid status 2>&1 | jq .SyncInfo
```

#### Cüzdan Oluşturma

Yeni cüzdan oluşturmak için aşağıdaki komutu kullanabilirsiniz. Hatırlatıcıyı (mnemonic) kaydetmeyi unutmayın.

```
teritorid keys add $TT_WALLET
```

(OPSIYONEL) Cüzdanınızı hatırlatıcı (mnemonic) kullanarak kurtarmak için:

```
teritorid keys add $TT_WALLET --recover
```

Mevcut cüzdan listesini almak için:

```
teritorid keys list
```

#### Cüzdan Bilgilerini Kaydet

Cüzdan Adresi Ekleyin:

```
TT_WALLET_ADDRESS=$(teritorid keys show $TT_WALLET -a)
TT_VALOPER_ADDRESS=$(teritorid keys show $TT_WALLET --bech val -a)
echo 'export TT_WALLET_ADDRESS='${TT_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export TT_VALOPER_ADDRESS='${TT_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

#### Doğrulayıcı oluştur

Doğrulayıcı oluşturmadan önce lütfen en az 1 tori'ye sahip olduğunuzdan (1 tori 1000000 utori'e eşittir) ve düğümünüzün senkronize olduğundan emin olun.

Cüzdan bakiyenizi kontrol etmek için:

```
teritorid query bank balances $TT_WALLET_ADDRESS
```

> Cüzdanınızda bakiyenizi göremiyorsanız, muhtemelen düğümünüz hala eşitleniyordur. Lütfen senkronizasyonun bitmesini bekleyin ve ardından devam edin.

Doğrulayıcı Oluşturma:

```
teritorid tx staking create-validator \
  --amount 1000000utori \
  --from $TT_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(teritorid tendermint show-validator) \
  --moniker $TT_NODENAME \
  --chain-id $TT_ID \
  --fees 250utori
```

### Kullanışlı Komutlar

#### Servis Yönetimi

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

#### Node Bilgileri

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

#### Cüzdan İşlemleri

Cüzdanları Listele:

```
teritorid keys list
```

Mnemonic kullanarak cüzdanı kurtar:

```
teritorid keys add $TT_WALLET --recover
```

Cüzdan Silme:

```
teritorid keys delete $TT_WALLET
```

Cüzdan Bakiyesi Sorgulama:

```
teritorid query bank balances $TT_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:

```
teritorid tx bank send $TT_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000utori
```

#### Oylama

```
teritorid tx gov vote 1 yes --from $TT_WALLET --chain-id=$TT_ID
```

#### Stake, Delegasyon ve Ödüller

Delegate İşlemi:

```
teritorid tx staking delegate $TT_VALOPER_ADDRESS 10000000utori --from=$TT_WALLET --chain-id=$TT_ID --gas=auto --fees 250utori
```

Payını doğrulayıcıdan başka bir doğrulayıcıya yeniden devretme:

```
teritorid tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utori --from=$TT_WALLET --chain-id=$TT_ID --gas=auto --fees 250utori
```

Tüm ödülleri çek:

```
teritorid tx distribution withdraw-all-rewards --from=$TT_WALLET --chain-id=$TT_ID --gas=auto --fees 250utori
```

Komisyon ile ödülleri geri çekin:

```
teritorid tx distribution withdraw-rewards $TT_VALOPER_ADDRESS --from=$TT_WALLET --commission --chain-id=$TT_ID
```

#### Doğrulayıcı Yönetimi

Validatör İsmini Değiştir:

```
teritorid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$TT_ID \
--from=$TT_WALLET
```

Hapisten Kurtul(Unjail):

```
teritorid tx slashing unjail \
  --broadcast-mode=block \
  --from=$TT_WALLET \
  --chain-id=$TT_ID \
  --gas=auto --fees 250utori
```

Node Tamamen Silmek:

```
sudo systemctl stop teritorid
sudo systemctl disable teritorid
sudo rm /etc/systemd/system/teritori* -rf
sudo rm $(which teritorid) -rf
sudo rm $HOME/.teritori* -rf
sudo rm $HOME/teritori-chain -rf
sed -i '/TT_/d' ~/.bash_profile
```

{% embed url="https://www.youtube.com/watch?v=zk6JvHsxsVQ" %}
