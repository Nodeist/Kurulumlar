# 1. Kurulum
```
wget -O Nodeistsui.sh https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Sui/Nodeistsui.sh && chmod +x Nodeistsui.sh && ./Nodeistsui.sh
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
