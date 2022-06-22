<p style="font-size:14px" align="right">
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>


### Minimum Donanım Gereksinimleri
 - 2x CPU; saat hızı ne kadar yüksek olursa o kadar iyi
 - 4GB RAM
 - 50GB Disk
 - Kalıcı İnternet bağlantısı (testnet sırasında trafik minimum olacak; 10Mbps olacak - üretim için en az 100Mbps bekleniyor)



# 1. Kurulum
```
wget -O Nodeistsui.sh https://raw.githubusercontent.com/nnooddeeiisstt/Testnet_Kurulumlar/main/Sui/Nodeistsui.sh && chmod +x Nodeistsui.sh && ./Nodeistsui.sh
```


# Ek kodlar
### Node Kontrol:
```
curl -s -X POST http://127.0.0.1:9000 -H 'Content-Type: application/json' -d '{ "jsonrpc":"2.0", "method":"rpc.discover","id":1}' | jq .result.info
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
