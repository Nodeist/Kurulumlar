&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>

![](https://i.hizliresim.com/nro1l6b.jpeg)


# Uptick Руководство по установке
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

## Этапы установки Uptick Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду Uptick за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
wget -O UPTICK.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Z-Bitenler/Uptick/UPTICK && chmod +x UPTICK.sh && ./UPTICK.sh
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
uptickd status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
uptickd keys add $UPTICK_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
uptickd keys add $UPTICK_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
uptickd keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
UPTICK_WALLET_ADDRESS=$(uptickd keys show $UPTICK_WALLET -a)
UPTICK_VALOPER_ADDRESS=$(uptickd keys show $UPTICK_WALLET --bech val -a)
echo 'export UPTICK_WALLET_ADDRESS='${UPTICK_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export UPTICK_VALOPER_ADDRESS='${UPTICK_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 uptick (1 uptick равен 1000000 auptick) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
uptickd query bank balances $UPTICK_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
```
uptickd tx staking create-validator \
  --amount 1000000auptick \
  --from $UPTICK_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(uptickd tendermint show-validator) \
  --moniker $UPTICK_NODENAME \
  --chain-id $UPTICK_ID \
  --fees 250auptick
```


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu uptickd -o cat
```

Запустить службу:
```
systemctl start uptickd
```

Остановить службу:
```
systemctl stop uptickd
```

Перезапустить службу:
```
systemctl restart uptickd
```

### Информация об узле
Информация о синхронизации:
```
uptickd status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
uptickd status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
uptickd status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
uptickd tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
uptickd keys list
```

Восстановить кошелек с помощью Mnemonic:
```
uptickd keys add $UPTICK_WALLET --recover
```

Удаление кошелька:
```
uptickd keys delete $UPTICK_WALLET
```

Запрос баланса кошелька:
```
uptickd query bank balances $UPTICK_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
uptickd tx bank send $UPTICK_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000auptick
```

### Голосование
```
uptickd tx gov vote 1 yes --from $UPTICK_WALLET --chain-id=$UPTICK_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
uptickd tx staking delegate $UPTICK_VALOPER_ADDRESS 10000000auptick --from=$UPTICK_WALLET --chain-id=$UPTICK_ID --gas=auto --fees 250auptick
```

Повторно передать долю от валидатора другому валидатору:
```
uptickd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000auptick --from=$UPTICK_WALLET --chain-id=$UPTICK_ID --gas=auto --fees 250auptick
```

Вывести все награды:
```
uptickd tx distribution withdraw-all-rewards --from=$UPTICK_WALLET --chain-id=$UPTICK_ID --gas=auto --fees 250auptick
```

Вывод вознаграждений с комиссией:
```
uptickd tx distribution withdraw-rewards $UPTICK_VALOPER_ADDRESS --from=$UPTICK_WALLET --commission --chain-id=$UPTICK_ID
```

### Управление верификатором
Изменить имя валидатора:
```
uptickd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$UPTICK_ID \
--from=$UPTICK_WALLET
```

Выйти из тюрьмы (Unjail):
```
uptickd tx slashing unjail \
  --broadcast-mode=block \
  --from=$UPTICK_WALLET \
  --chain-id=$UPTICK_ID \
  --gas=auto --fees 250auptick
```


Чтобы полностью удалить узел:
```
sudo systemctl stop uptickd
sudo systemctl disable uptickd
sudo rm /etc/systemd/system/uptick* -rf
sudo rm $(which uptickd) -rf
sudo rm $HOME/.uptickd* -rf
sudo rm $HOME/uptick -rf
sed -i '/UPTICK_/d' ~/.bash_profile
```
  