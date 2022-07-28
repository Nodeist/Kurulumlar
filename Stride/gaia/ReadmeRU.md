&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/qa5txaz.png)


# Gaia Руководство по установке
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

## Этапы установки Gaia Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду Gaia за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
wget -O GAIA.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Stride/gaia/GAIA && chmod +x GAIA.sh && ./GAIA.sh
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
gaiad status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
gaiad keys add $GAIA_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
gaiad keys add $GAIA_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
gaiad keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
GAIA_WALLET_ADDRESS=$(gaiad keys show $GAIA_WALLET -a)
GAIA_VALOPER_ADDRESS=$(gaiad keys show $GAIA_WALLET --bech val -a)
echo 'export GAIA_WALLET_ADDRESS='${GAIA_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export GAIA_VALOPER_ADDRESS='${GAIA_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 atom (1 atom равен 1000000 uatom) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
gaiad query bank balances $GAIA_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
```
gaiad tx staking create-validator \
  --amount 1000000uatom \
  --from $GAIA_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(gaiad tendermint show-validator) \
  --moniker $GAIA_NODENAME \
  --chain-id $GAIA_ID \
  --fees 250uatom
```


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu gaiad -o cat
```

Запустить службу:
```
systemctl start gaiad
```

Остановить службу:
```
systemctl stop gaiad
```

Перезапустить службу:
```
systemctl restart gaiad
```

### Информация об узле
Информация о синхронизации:
```
gaiad status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
gaiad status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
gaiad status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
gaiad tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
gaiad keys list
```

Восстановить кошелек с помощью Mnemonic:
```
gaiad keys add $GAIA_WALLET --recover
```

Удаление кошелька:
```
gaiad keys delete $GAIA_WALLET
```

Запрос баланса кошелька:
```
gaiad query bank balances $GAIA_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
gaiad tx bank send $GAIA_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uatom
```

### Голосование
```
gaiad tx gov vote 1 yes --from $GAIA_WALLET --chain-id=$GAIA_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
gaiad tx staking delegate $GAIA_VALOPER_ADDRESS 10000000uatom --from=$GAIA_WALLET --chain-id=$GAIA_ID --gas=auto --fees 250uatom
```

Повторно передать долю от валидатора другому валидатору:
```
gaiad tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uatom --from=$GAIA_WALLET --chain-id=$GAIA_ID --gas=auto --fees 250uatom
```

Вывести все награды:
```
gaiad tx distribution withdraw-all-rewards --from=$GAIA_WALLET --chain-id=$GAIA_ID --gas=auto --fees 250uatom
```

Вывод вознаграждений с комиссией:
```
gaiad tx distribution withdraw-rewards $GAIA_VALOPER_ADDRESS --from=$GAIA_WALLET --commission --chain-id=$GAIA_ID
```

### Управление верификатором
Изменить имя валидатора:
```
gaiad tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$GAIA_ID \
--from=$GAIA_WALLET
```

Выйти из тюрьмы (Unjail):
```
gaiad tx slashing unjail \
  --broadcast-mode=block \
  --from=$GAIA_WALLET \
  --chain-id=$GAIA_ID \
  --gas=auto --fees 250uatom
```


Чтобы полностью удалить узел:
```
sudo systemctl stop gaiad
sudo systemctl disable gaiad
sudo rm /etc/systemd/system/gaia* -rf
sudo rm $(which gaiad) -rf
sudo rm $HOME/.gaia* -rf
sudo rm $HOME/gaia -rf
sed -i '/GAIA_/d' ~/.bash_profile
```
  