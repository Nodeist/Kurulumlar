<p style="font-size:14px" align="right">
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/nnooddeeiisstt/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/nnooddeeiisstt/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>

<p align="center">
  <img height="100" height="auto" src="https://i.hizliresim.com/an4fwuw.jpeg">
</p>


## Gemini Incentivized Testnet için Subspace düğümü kurulumu

Resmi belgeler:
- Resmi kılavuz: https://github.com/subspace/subspace/blob/main/docs/farming.md

## Önerilen donanım gereksinimleri
- CPU: 4 CPU
- Memory: 8 GB RAM
- Disk: 200 GB SSD Storage

## Gerekli bağlantı noktaları
Güvenlik duvarı kullanıyorsanız `30333` portunu açın.


## Polkadot.js cüzdanı oluşturun

Polkadot cüzdanı oluşturmak için:
  
1. İndirin ve yükleyin [Browser eklentisi](https://polkadot.js.org/extension/)
2. [Subspace Explorer](https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Feu.gemini-1b.subspace.network%2Fws#/accounts) websitesine gidin ve `Add account` butonuna basın.
3. Yeni cüzdan oluşturun ve `mnemonic` kelimelerini kaydedin.
4. Bu, daha sonra kullanmak zorunda kalacağınız cüzdan adresi üretecektir.
   `gkM1PHUgJHinKwyF4dQtsUey61R4c2L8Szq8ttdoynqJ9BTmE` cüzdan adresini yedekleyin node kurulumunda sorulacak.

## Subspace Node Kurulumu

Aşağıdaki otomatik komut dosyasını kullanarak subspace fullnode'unuzu birkaç dakika içinde kurabilirsiniz. Doğrulayıcı düğüm adınızı(NODE NAME), cüzdan adresi ve disk alanı girmenizi isteyecektir! minimum 10G olarak belirleyin maks 2TB

```
wget -O Nodeistsubspace.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Subspace/Nodeistsubspace.sh && chmod +x Nodeistsubspace.sh && ./Nodeistsubspace.sh
```

  ## Telemetrideki düğümünüzü kontrol edin

Düğümünüzü ve çiftçinizi kurmayı bitirdiğinizde:
  
1. [Subspace 1 Telemetrisine ](https://telemetry.subspace.network/#list/0x9ee86eefc3cc61c71a7751bba7f25e442da2512f408e6286153b3ccc055dccf0) gidin.
2. ve  düğüm adınızı yazarak arayın
3. Kendinizi aşağıdaki resimdeki gibi listede görmelisiniz

![image](https://i.hizliresim.com/6g6ykf6.png)

  ## Faydalı komutlar
Düğüm durumunu kontrol edin
```
service subspaced status
```

Çiftçi durumunu kontrol et
```
service subspaced-farmer status
```

Düğüm günlüklerini kontrol edin
```
journalctl -u subspaced -f -o cat
```

Çiftçi günlüklerini kontrol edin
  
```
journalctl -u subspaced-farmer -f -o cat
```

Günlüklerde aşağıdakilere benzer bir şey görmelisiniz:
  
```
2022-02-03 10:52:23 Subspace
2022-02-03 10:52:23 ✌️  version 0.1.0-35cf6f5-x86_64-ubuntu
2022-02-03 10:52:23 ❤️  by Subspace Labs <https://subspace.network>, 2021-2022
2022-02-03 10:52:23 📋 Chain specification: Subspace Gemini 1
2022-02-03 10:52:23 🏷  Node name: YOUR_FANCY_NAME
2022-02-03 10:52:23 👤 Role: AUTHORITY
2022-02-03 10:52:23 💾 Database: RocksDb at /home/X/.local/share/subspace-node-x86_64-ubuntu-20.04-snapshot-2022-jan-05/chains/subspace_test/db/full
2022-02-03 10:52:23 ⛓  Native runtime: subspace-100 (subspace-1.tx1.au1)
2022-02-03 10:52:23 🔨 Initializing Genesis block/state (state: 0x22a5…17ea, header-hash: 0x6ada…0d38)
2022-02-03 10:52:24 ⏱  Loaded block-time = 1s from block 0x6ada0792ea62bf3501abc87d92e1ce0e78ddefba66f02973de54144d12ed0d38
2022-02-03 10:52:24 Starting archiving from genesis
2022-02-03 10:52:24 Archiving already produced blocks 0..=0
2022-02-03 10:52:24 🏷  Local node identity is: 12D3KooWBgKtea7MVvraeNyxdPF935pToq1x9VjR1rDeNH1qecXu
2022-02-03 10:52:24 🧑‍🌾 Starting Subspace Authorship worker
2022-02-03 10:52:24 📦 Highest known block at #0
2022-02-03 10:52:24 〽️ Prometheus exporter started at 127.0.0.1:9615
2022-02-03 10:52:24 Listening for new connections on 0.0.0.0:9944.
2022-02-03 10:52:26 🔍 Discovered new external address for our node: /ip4/176.233.17.199/tcp/30333/p2p/12D3KooWBgKtea7MVvraeNyxdPF935pToq1x9VjR1rDeNH1qecXu
2022-02-03 10:52:29 ⚙️  Syncing, target=#215883 (2 peers), best: #55 (0xafc7…bccf), finalized #0 (0x6ada…0d38), ⬇ 850.1kiB/s ⬆ 1.5kiB/s
```

Düğümü silmek için
```
sudo systemctl stop subspaced subspaced-farmer
sudo systemctl disable subspaced subspaced-farmer
rm -rf /etc/systemd/system/subspaced*
rm -rf /usr/local/bin/subspace*
```
