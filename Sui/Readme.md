&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)



### Minimum Donanım Gereksinimleri
 - 2x CPU; saat hızı ne kadar yüksek olursa o kadar iyi
 - 4GB RAM
 - 50GB Disk
 - Kalıcı İnternet bağlantısı (testnet sırasında trafik minimum olacak; 10Mbps olacak - üretim için en az 100Mbps bekleniyor)



# Kurulum
```
wget -O Nodeistsui.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Sui/Nodeistsui.sh && chmod +x Nodeistsui.sh && ./Nodeistsui.sh
```


# Kurulum Sonrası Adımlar
### Düğümünüzün durumunu kontrol edin:
```
curl -s -X POST http://127.0.0.1:9000 -H 'Content-Type: application/json' -d '{ "jsonrpc":"2.0", "method":"rpc.discover","id":1}' | jq .result.info
```


Sonuç buna benzer olmalı:
```
{
"title": "Sui JSON-RPC",
"description": "Sui JSON-RPC API for interaction with the Sui network gateway.",
"contact": {
"name": "Mysten Labs",
"url": "https://mystenlabs.com",
"email": "build@mystenlabs.com"
},
"license": {
"name": "Apache-2.0",
"url": "https://raw.githubusercontent.com/MystenLabs/sui/main/LICENSE"
},
"version": "0.1.0"
}
```


En son 5 işlem ile ilgili bilgi alın:
```
curl --location --request POST 'http://127.0.0.1:9000/' --header 'Content-Type: application/json' \
--data-raw '{ "jsonrpc":"2.0", "id":1, "method":"sui_getRecentTransactions", "params":[5] }' | jq .
```

Belirlenen işlem ile ilgili ayrıntı alın:
```
curl --location --request POST 'http://127.0.0.1:9000/' --header 'Content-Type: application/json' \
--data-raw '{ "jsonrpc":"2.0", "id":1, "method":"sui_getTransaction", "params":["<RECENT_TXN_FROM_ABOVE>"] }' | jq .
```

## Yükleme sonrası
Sui düğümünüzü kurduktan sonra onu [Sui Discord](https://discord.gg/yYZpFJ5DQC)'a kaydetmeniz gerekir:
1) `#📋node-ip-application` kanalına gidin
2) Düğüm bitiş noktası url'nizi gönderin
```
http://<SİZİN_NODE_IP>:9000/
```

## Düğüm sağlık durumunuzu kontrol edin
Düğüm IP'nizi https://node.sui.zvalid.com/ adresine girin

Sağlıklı düğüm şöyle görünmelidir:
![image](https://i.hizliresim.com/qs9m96i.png)

## Cüzdan oluştur
```
echo -e "y\n" | sui client
```
> !Lütfen `$HOME/.sui/sui_config/` dizininde bulunan cüzdan anahtarı dosyalarınızı yedekleyin!

## Cüzdanınızı doldurun
1. Cüzdan adresinizi alın:
```
sui client active-address
```

2. [Sui Discord](https://discord.gg/sui) `#devnet-faucet` kanalına gidin ve cüzdanınıza para yükleyin
```
!faucet <CUZDANADRESI>
```

Bakiyenizi aşağıdaki adresten kontrol edin:
```
https://explorer.devnet.sui.io/addresses/<YOUR_WALLET_ADDRESS>
```


## Objelerle işlemler
### İki objeyi tek bir objede birleştirin
```
JSON=$(sui client gas --json | jq -r)
FIRST_OBJECT_ID=$(sui client gas --json | jq -r .[0].id.id)
SECOND_OBJECT_ID=$(sui client gas --json | jq -r .[1].id.id)
sui client merge-coin --primary-coin ${FIRST_OBJECT_ID} --coin-to-merge ${SECOND_OBJECT_ID} --gas-budget 1000
```

Çıktıyı şöyle görmelisiniz:
```
----- Certificate ----
Transaction Hash: t3BscscUH2tMnMRfzYyc4Nr9HZ65nXuaL87BicUwXVo=
Transaction Signature: OCIYOWRPLSwpLG0bAmDTMixvE3IcyJgcRM5TEXJAOWvDv1xDmPxm99qQEJJQb0iwCgEfDBl74Q3XI6yD+AK7BQ==@U6zbX7hNmQ0SeZMheEKgPQVGVmdE5ikRQZIeDKFXwt8=
Signed Authorities Bitmap: RoaringBitmap<[0, 2, 3]>
Transaction Kind : Call
Package ID : 0x2
Module : coin
Function : join
Arguments : ["0x530720be83c5e8dffde5f602d2f36e467a24f6de", "0xb66106ac8bc9bf8ec58a5949da934febc6d7837c"]
Type Arguments : ["0x2::sui::SUI"]
----- Merge Coin Results ----
Updated Coin : Coin { id: 0x530720be83c5e8dffde5f602d2f36e467a24f6de, value: 100000 }
Updated Gas : Coin { id: 0xc0a3fa96f8e52395fa659756a6821c209428b3d9, value: 49560 }
```

Objelerin listesini kontrol edelim:
```
sui client gas
```

>Bu, şu anda yapılabilecek işlemlerden sadece bir tanesidir. Diğer örnekler [resmi web sitesinde](https://docs.sui.io/build/wallet) bulunabilir.

## Sui fullnode için faydalı komutlar
Özel düğüm durumunu kontrol edin
```
docker ps -a
```

Düğüm günlüklerini kontrol edin
```
docker logs -f sui-fullnode-1 --tail 50
```

Düğümü silmek için
```
cd $HOME/sui && docker-compose down --volumes
cd $HOME && rm -rf sui
```

## sui için faydalı komutlar
Sui sürümünü kontrol edin
```
sui --version
```

Sui sürümünü güncelle
```
wget -qO Update.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Sui/Tools/Update.sh && chmod +x Update.sh && ./Update.sh
```

## Anahtarlarınızı kurtarın
Anahtarlarınızı `$HOME/.sui/sui_config/` dizinine kopyalayın ve düğümü yeniden başlatın

## Düğümünüzü silin
```
rm -rf /usr/local/bin/{sui,sui-node,sui-faucet} 
cd $HOME/.sui && docker-compose down --volumes 
cd $HOME && rm -rf .sui
```


### Node Logları :
```
journalctl -u suid -f -o cat
```

### Restart Node:
```
sudo systemctl restart suid
```

### Stop Node:
```
sudo systemctl stop suid
```

### Delete Node:
```
sudo systemctl stop suid
sudo systemctl disable suid
rm -rf ~/sui /var/sui/
rm /etc/systemd/suid.service
```
