&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>

![](https://i.hizliresim.com/7ffu92z.jpeg)


# Teritori Руководство по установке
## Аппаратные требования
Как и у любой цепочки Cosmos-SDK, требования к оборудованию довольно скромные.

### Минимальные аппаратные требования
  - 3x ЦП; чем выше тактовая частота, тем лучше
  - 4 ГБ ОЗУ
  - 80 ГБ Диск
  - Постоянное подключение к Интернету (трафик будет не менее 10 Мбит / с во время тестовой сети - ожидается не менее 100 Мбит / с для производства)

### Рекомендуемые аппаратные требования
  - 4x ЦП; чем выше тактовая частота, тем лучше
  - 8 ГБ ОЗУ
  - 200 ГБ памяти (SSD или NVME)
  - Постоянное подключение к Интернету (трафик будет не менее 10 Мбит / с во время тестовой сети - ожидается не менее 100 Мбит / с для производства)

Официальная документация:
>- [Инструкции по настройке валидатора](https://github.com/TERITORI/teritori-chain/blob/main/testnet/teritori-testnet-v2/README.md)

исследователь:
>- https://teritori.explorers.guru/


## Этапы установки Teritori Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду Teritori за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
wget -O TT.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Teritori/TT && chmod +x TT.sh && ./TT.sh
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
teritorid status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
teritorid keys add $TT_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
teritorid keys add $TT_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
teritorid keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
TT_WALLET_ADDRESS=$(teritorid keys show $TT_WALLET -a)
TT_VALOPER_ADDRESS=$(teritorid keys show $TT_WALLET --bech val -a)
echo 'export TT_WALLET_ADDRESS='${TT_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export TT_VALOPER_ADDRESS='${TT_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 tori (1 tori равен 1000000 utori) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
teritorid query bank balances $TT_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
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


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu teritorid -o cat
```

Запустить службу:
```
systemctl start teritorid
```

Остановить службу:
```
systemctl stop teritorid
```

Перезапустить службу:
```
systemctl restart teritorid
```

### Информация об узле
Информация о синхронизации:
```
teritorid status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
teritorid status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
teritorid status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
teritorid tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
teritorid keys list
```

Восстановить кошелек с помощью Mnemonic:
```
teritorid keys add $TT_WALLET --recover
```

Удаление кошелька:
```
teritorid keys delete $TT_WALLET
```

Запрос баланса кошелька:
```
teritorid query bank balances $TT_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
teritorid tx bank send $TT_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000utori
```

### Голосование
```
teritorid tx gov vote 1 yes --from $TT_WALLET --chain-id=$TT_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
teritorid tx staking delegate $TT_VALOPER_ADDRESS 10000000utori --from=$TT_WALLET --chain-id=$TT_ID --gas=auto --fees 250utori
```

Повторно передать долю от валидатора другому валидатору:
```
teritorid tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utori --from=$TT_WALLET --chain-id=$TT_ID --gas=auto --fees 250utori
```

Вывести все награды:
```
teritorid tx distribution withdraw-all-rewards --from=$TT_WALLET --chain-id=$TT_ID --gas=auto --fees 250utori
```

Вывод вознаграждений с комиссией:
```
teritorid tx distribution withdraw-rewards $TT_VALOPER_ADDRESS --from=$TT_WALLET --commission --chain-id=$TT_ID
```

### Управление верификатором
Изменить имя валидатора:
```
teritorid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$TT_ID \
--from=$TT_WALLET
```

Выйти из тюрьмы (Unjail):
```
teritorid tx slashing unjail \
  --broadcast-mode=block \
  --from=$TT_WALLET \
  --chain-id=$TT_ID \
  --gas=auto --fees 250utori
```


Чтобы полностью удалить узел:
```
sudo systemctl stop teritorid
sudo systemctl disable teritorid
sudo rm /etc/systemd/system/teritori* -rf
sudo rm $(which teritorid) -rf
sudo rm $HOME/.teritori* -rf
sudo rm $HOME/teritori-chain -rf
sed -i '/TT_/d' ~/.bash_profile
```
  