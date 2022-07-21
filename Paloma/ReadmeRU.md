&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>

![](https://i.hizliresim.com/iz7y3vs.png)

# Paloma Руководство по установке
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

## Этапы установки Paloma Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду Paloma за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
wget -O PLM.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Paloma/PLM && chmod +x PLM.sh && ./PLM.sh
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
palomad status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
palomad keys add $PLM_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
palomad keys add $PLM_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
palomad keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
PLM_WALLET_ADDRESS=$(palomad keys show $PLM_WALLET -a)
PLM_VALOPER_ADDRESS=$(palomad keys show $PLM_WALLET --bech val -a)
echo 'export PLM_WALLET_ADDRESS='${PLM_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export PLM_VALOPER_ADDRESS='${PLM_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 grain (1 grain равен 1000000 ugrain) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
palomad query bank balances $PLM_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
```
palomad tx staking create-validator \
  --amount 1000000ugrain \
  --from $PLM_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(palomad tendermint show-validator) \
  --moniker $PLM_NODENAME \
  --chain-id $PLM_ID \
  --fees 250ugrain
```


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu palomad -o cat
```

Запустить службу:
```
systemctl start palomad
```

Остановить службу:
```
systemctl stop palomad
```

Перезапустить службу:
```
systemctl restart palomad
```

### Информация об узле
Информация о синхронизации:
```
palomad status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
palomad status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
palomad status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
palomad tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
palomad keys list
```

Восстановить кошелек с помощью Mnemonic:
```
palomad keys add $PLM_WALLET --recover
```

Удаление кошелька:
```
palomad keys delete $PLM_WALLET
```

Запрос баланса кошелька:
```
palomad query bank balances $PLM_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
palomad tx bank send $PLM_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ugrain
```

### Голосование
```
palomad tx gov vote 1 yes --from $PLM_WALLET --chain-id=$PLM_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
palomad tx staking delegate $PLM_VALOPER_ADDRESS 10000000ugrain --from=$PLM_WALLET --chain-id=$PLM_ID --gas=auto --fees 250ugrain
```

Повторно передать долю от валидатора другому валидатору:
```
palomad tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ugrain --from=$PLM_WALLET --chain-id=$PLM_ID --gas=auto --fees 250ugrain
```

Вывести все награды:
```
palomad tx distribution withdraw-all-rewards --from=$PLM_WALLET --chain-id=$PLM_ID --gas=auto --fees 250ugrain
```

Вывод вознаграждений с комиссией:
```
palomad tx distribution withdraw-rewards $PLM_VALOPER_ADDRESS --from=$PLM_WALLET --commission --chain-id=$PLM_ID
```

### Управление верификатором
Изменить имя валидатора:
```
palomad tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$PLM_ID \
--from=$PLM_WALLET
```

Выйти из тюрьмы (Unjail):
```
palomad tx slashing unjail \
  --broadcast-mode=block \
  --from=$PLM_WALLET \
  --chain-id=$PLM_ID \
  --gas=auto --fees 250ugrain
```


Чтобы полностью удалить узел:
```
sudo systemctl stop palomad
sudo systemctl disable palomad
sudo rm /etc/systemd/system/paloma* -rf
sudo rm $(which palomad) -rf
sudo rm $HOME/.paloma* -rf
sudo rm $HOME/paloma -rf
sed -i '/PLM_/d' ~/.bash_profile
```
