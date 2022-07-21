&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

### Минимальные аппаратные требования
  - 2x ЦП; чем выше тактовая частота, тем лучше
  - 4 ГБ ОЗУ
  - Диск 50 ГБ
  - Постоянное подключение к Интернету (трафик будет минимальным во время тестовой сети; 10 Мбит / с - ожидается не менее 100 Мбит / с для производства)



# Установить
```
wget -O Nodeistsui.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Sui/Nodeistsui.sh && chmod +x Nodeistsui.sh && ./Nodeistsui.sh
```


# Действия после установки
### Проверьте статус вашего узла:
```
curl -s -X POST http://127.0.0.1:9000 -H 'Content-Type: application/json' -d '{ "jsonrpc":"2.0", "method":"rpc.discover","id":1}' | jq .result.info
```


Результат должен быть похож на этот:
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


Получить информацию о последних 5 транзакциях:
```
curl --location --request POST 'http://127.0.0.1:9000/' --header 'Content-Type: application/json' \
--data-raw '{ "jsonrpc":"2.0", "id":1, "method":"sui_getRecentTransactions", "params":[5] }' | jq .
```

Получить подробную информацию об указанном действии:
```
curl --location --request POST 'http://127.0.0.1:9000/' --header 'Content-Type: application/json' \
--data-raw '{ "jsonrpc":"2.0", "id":1, "method":"sui_getTransaction", "params":["<RECENT_TXN_FROM_ABOVE>"] }' | jq .
```

## После установки
После установки узла sui его необходимо зарегистрировать в [Sui Discord](https://discord.gg/yYZpFJ5DQC):
1) Перейти на канал `#📋node-ip-application`
2) Отправьте URL конечной точки вашего узла
```
http://<ВАШ_УЗЕЛ_IP>:9000/
```

## Проверьте работоспособность вашего узла
Введите IP-адрес вашего узла на https://node.sui.zvalid.com/

Здоровый узел должен выглядеть так:
![изображение](https://i.hizliresim.com/qs9m96i.png)

## Создать кошелек
```
echo -e "y\n" | sui client
```
> !Пожалуйста, сделайте резервную копию файлов ключей вашего кошелька, расположенных в каталоге `$HOME/.sui/sui_config/`!


## Пополните свой кошелек
1. Получите адрес своего кошелька:
```
sui client active-address
```

2. Перейдите в [Sui Discord](https://discord.gg/sui) `#devnet-faucet` и пополните свой кошелек.
```
!faucet <WALLETADRESS>
```

Проверьте свой баланс по адресу:
```
https://explorer.devnet.sui.io/addresses/<WALLETADDRESS>
```


## Операции с объектами
### Объединить два объекта в один объект
```
JSON=$(sui client gas --json)
FIRST_OBJECT_ID=$(sui client gas --json | jq -r .[0].id.id)
SECOND_OBJECT_ID=$(sui client gas --json | jq -r .[1].id.id)
sui client merge-coin --primary-coin ${FIRST_OBJECT_ID} --coin-to-merge ${SECOND_OBJECT_ID} --gas-budget 1000
```

Вы должны увидеть вывод следующим образом:
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

Проверим список объектов:
```
sui client gas
```

>Это только одно из действий, которое можно сделать в данное время. Другие примеры можно найти на [официальном сайте](https://docs.sui.io/build/wallet).

## Полезные команды для sui fullnode
Проверить статус пользовательского узла
```
docker ps -a
```

Проверьте журналы узла
```
docker logs -f sui-fullnode-1 --tail 50
```

Чтобы удалить узел
```
cd $HOME/sui && docker-compose down --volumes
cd $HOME && rm -rf sui
```

## полезные команды для костюма
Проверить суй версию
```
sui --version
```

Обновить суй версию
```
wget -qO Update.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Sui/Tools/Update.sh && chmod +x Update.sh && ./Update.sh
```

## Восстановите свои ключи
Скопируйте ваши ключи в `$HOME/.sui/sui_config/` и перезапустите узел

## Удалите свой узел
```
rm -rf /usr/local/bin/{sui,sui-node,sui-faucet} 
cd $HOME/.sui && docker-compose down --volumes 
cd $HOME && rm -rf .sui
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
