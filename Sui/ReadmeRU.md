&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

### Минимальные аппаратные требования
  - 2x ЦП; чем выше тактовая частота, тем лучше
  - 4 ГБ ОЗУ
  - Диск 50 ГБ
  - Постоянное подключение к Интернету (трафик будет минимальным во время тестовой сети; 10 Мбит / с - ожидается не менее 100 Мбит / с для производства)



№ 1. Установка
```
wget -O Nodeistsui.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Sui/Nodeistsui.sh && chmod +x Nodeistsui.sh && ./Nodeistsui.sh
```


# Дополнительные коды
### Управление узлом:
```
curl -s -X POST http://127.0.0.1:9000 -H 'Content-Type: application/json' -d '{ "jsonrpc":"2.0", "method":"rpc.discover","id":1}' | jq .result.info
```

### Журналы узла:
```
journalctl -u suid -f -o cat
```

### Перезапустить узел:
```
sudo systemctl restart suid
```

### Остановить узел:
```
sudo systemctl stop suid
```

### Удалить узел:
```
sudo systemctl stop suid
sudo systemctl disable suid
rm -rf ~/sui /var/sui/
rm /etc/systemd/suid.service
```
