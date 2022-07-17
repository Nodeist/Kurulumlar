<p style="font-size:14px" align="right">
 100$ Бесплатный VPS на 2 Месяца <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Присоединяйтесь к Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Посетите наш сайт
</p>

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
