&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>

![](https://i.hizliresim.com/kitpt1x.png)


# Deweb Руководство по установке
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

## Этапы установки Deweb Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду Deweb за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
wget -O DWS.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Deweb/DWS && chmod +x DWS.sh && ./DWS.sh
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
dewebd status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
dewebd keys add $DWS_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
dewebd keys add $DWS_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
dewebd keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
DWS_WALLET_ADDRESS=$(dewebd keys show $DWS_WALLET -a)
DWS_VALOPER_ADDRESS=$(dewebd keys show $DWS_WALLET --bech val -a)
echo 'export DWS_WALLET_ADDRESS='${DWS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export DWS_VALOPER_ADDRESS='${DWS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 dws (1 dws равен 1000000 udws) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
dewebd query bank balances $DWS_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
```
dewebd tx staking create-validator \
  --amount 1000000udws \
  --from $DWS_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(dewebd tendermint show-validator) \
  --moniker $DWS_NODENAME \
  --chain-id $DWS_ID \
  --fees 250udws
```


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu dewebd -o cat
```

Запустить службу:
```
systemctl start dewebd
```

Остановить службу:
```
systemctl stop dewebd
```

Перезапустить службу:
```
systemctl restart dewebd
```

### Информация об узле
Информация о синхронизации:
```
dewebd status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
dewebd status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
dewebd status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
dewebd tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
dewebd keys list
```

Восстановить кошелек с помощью Mnemonic:
```
dewebd keys add $DWS_WALLET --recover
```

Удаление кошелька:
```
dewebd keys delete $DWS_WALLET
```

Запрос баланса кошелька:
```
dewebd query bank balances $DWS_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
dewebd tx bank send $DWS_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000udws
```

### Голосование
```
dewebd tx gov vote 1 yes --from $DWS_WALLET --chain-id=$DWS_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
dewebd tx staking delegate $DWS_VALOPER_ADDRESS 10000000udws --from=$DWS_WALLET --chain-id=$DWS_ID --gas=auto --fees 250udws
```

Повторно передать долю от валидатора другому валидатору:
```
dewebd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000udws --from=$DWS_WALLET --chain-id=$DWS_ID --gas=auto --fees 250udws
```

Вывести все награды:
```
dewebd tx distribution withdraw-all-rewards --from=$DWS_WALLET --chain-id=$DWS_ID --gas=auto --fees 250udws
```

Вывод вознаграждений с комиссией:
```
dewebd tx distribution withdraw-rewards $DWS_VALOPER_ADDRESS --from=$DWS_WALLET --commission --chain-id=$DWS_ID
```

### Управление верификатором
Изменить имя валидатора:
```
dewebd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$DWS_ID \
--from=$DWS_WALLET
```

Выйти из тюрьмы (Unjail):
```
dewebd tx slashing unjail \
  --broadcast-mode=block \
  --from=$DWS_WALLET \
  --chain-id=$DWS_ID \
  --gas=auto --fees 250udws
```


Чтобы полностью удалить узел:
```
sudo systemctl stop dewebd
sudo systemctl disable dewebd
sudo rm /etc/systemd/system/deweb* -rf
sudo rm $(which dewebd) -rf
sudo rm $HOME/.deweb* -rf
sudo rm $HOME/deweb -rf
sed -i '/DWS_/d' ~/.bash_profile
```
  