&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>

![](https://i.hizliresim.com/5oh0erz.png)

# Celestia Руководство по установке
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

## Этапы установки Celestia Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду Celestia за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
wget -O TIA.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Celestia/TIA && chmod +x TIA.sh && ./TIA.sh
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
celestia-appd status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
celestia-appd keys add $TIA_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
celestia-appd keys add $TIA_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
celestia-appd keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
TIA_WALLET_ADDRESS=$(celestia-appd keys show $TIA_WALLET -a)
TIA_VALOPER_ADDRESS=$(celestia-appd keys show $TIA_WALLET --bech val -a)
echo 'export TIA_WALLET_ADDRESS='${TIA_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export TIA_VALOPER_ADDRESS='${TIA_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 tia (1 tia равен 1000000 utia) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
celestia-appd query bank balances $TIA_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
```
celestia-appd tx staking create-validator \
  --amount 1000000utia \
  --from $TIA_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(celestia-appd tendermint show-validator) \
  --moniker $TIA_NODENAME \
  --chain-id $TIA_ID \
  --fees 250utia
```


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu celestia-appd -o cat
```

Запустить службу:
```
systemctl start celestia-appd
```

Остановить службу:
```
systemctl stop celestia-appd
```

Перезапустить службу:
```
systemctl restart celestia-appd
```

### Информация об узле
Информация о синхронизации:
```
celestia-appd status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
celestia-appd status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
celestia-appd status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
celestia-appd tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
celestia-appd keys list
```

Восстановить кошелек с помощью Mnemonic:
```
celestia-appd keys add $TIA_WALLET --recover
```

Удаление кошелька:
```
celestia-appd keys delete $TIA_WALLET
```

Запрос баланса кошелька:
```
celestia-appd query bank balances $TIA_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
celestia-appd tx bank send $TIA_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000utia
```

### Голосование
```
celestia-appd tx gov vote 1 yes --from $TIA_WALLET --chain-id=$TIA_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
celestia-appd tx staking delegate $TIA_VALOPER_ADDRESS 10000000utia --from=$TIA_WALLET --chain-id=$TIA_ID --gas=auto --fees 250utia
```

Повторно передать долю от валидатора другому валидатору:
```
celestia-appd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utia --from=$TIA_WALLET --chain-id=$TIA_ID --gas=auto --fees 250utia
```

Вывести все награды:
```
celestia-appd tx distribution withdraw-all-rewards --from=$TIA_WALLET --chain-id=$TIA_ID --gas=auto --fees 250utia
```

Вывод вознаграждений с комиссией:
```
celestia-appd tx distribution withdraw-rewards $TIA_VALOPER_ADDRESS --from=$TIA_WALLET --commission --chain-id=$TIA_ID
```

### Управление верификатором
Изменить имя валидатора:
```
celestia-appd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$TIA_ID \
--from=$TIA_WALLET
```

Выйти из тюрьмы (Unjail):
```
celestia-appd tx slashing unjail \
  --broadcast-mode=block \
  --from=$TIA_WALLET \
  --chain-id=$TIA_ID \
  --gas=auto --fees 250utia
```


Чтобы полностью удалить узел:
```
sudo systemctl stop celestia-appd
sudo systemctl disable celestia-appd
sudo rm /etc/systemd/system/celestia-app* -rf
sudo rm $(which celestia-appd) -rf
sudo rm $HOME/.celestia-app* -rf
sudo rm $HOME/core -rf
sed -i '/TIA_/d' ~/.bash_profile
```
