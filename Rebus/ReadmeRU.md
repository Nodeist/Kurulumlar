&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/cn8tdch.png)

# Rebus Руководство по установке
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

## Этапы установки Rebus Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду Rebus за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
wget -O RBS.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Rebus/RBS && chmod +x RBS.sh && ./RBS.sh
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
rebusd status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
rebusd keys add $RBS_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
rebusd keys add $RBS_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
rebusd keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
RBS_WALLET_ADDRESS=$(rebusd keys show $RBS_WALLET -a)
RBS_VALOPER_ADDRESS=$(rebusd keys show $RBS_WALLET --bech val -a)
echo 'export RBS_WALLET_ADDRESS='${RBS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export RBS_VALOPER_ADDRESS='${RBS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 rebus (1 rebus равен 1000000 arebus) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
rebusd query bank balances $RBS_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
```
rebusd tx staking create-validator \
  --amount 1000000arebus \
  --from $RBS_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(rebusd tendermint show-validator) \
  --moniker $RBS_NODENAME \
  --chain-id $RBS_ID \
  --fees 250arebus
```


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu rebusd -o cat
```

Запустить службу:
```
systemctl start rebusd
```

Остановить службу:
```
systemctl stop rebusd
```

Перезапустить службу:
```
systemctl restart rebusd
```

### Информация об узле
Информация о синхронизации:
```
rebusd status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
rebusd status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
rebusd status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
rebusd tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
rebusd keys list
```

Восстановить кошелек с помощью Mnemonic:
```
rebusd keys add $RBS_WALLET --recover
```

Удаление кошелька:
```
rebusd keys delete $RBS_WALLET
```

Запрос баланса кошелька:
```
rebusd query bank balances $RBS_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
rebusd tx bank send $RBS_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000arebus
```

### Голосование
```
rebusd tx gov vote 1 yes --from $RBS_WALLET --chain-id=$RBS_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
rebusd tx staking delegate $RBS_VALOPER_ADDRESS 10000000arebus --from=$RBS_WALLET --chain-id=$RBS_ID --gas=auto --fees 250arebus
```

Повторно передать долю от валидатора другому валидатору:
```
rebusd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000arebus --from=$RBS_WALLET --chain-id=$RBS_ID --gas=auto --fees 250arebus
```

Вывести все награды:
```
rebusd tx distribution withdraw-all-rewards --from=$RBS_WALLET --chain-id=$RBS_ID --gas=auto --fees 250arebus
```

Вывод вознаграждений с комиссией:
```
rebusd tx distribution withdraw-rewards $RBS_VALOPER_ADDRESS --from=$RBS_WALLET --commission --chain-id=$RBS_ID
```

### Управление верификатором
Изменить имя валидатора:
```
rebusd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$RBS_ID \
--from=$RBS_WALLET
```

Выйти из тюрьмы (Unjail):
```
rebusd tx slashing unjail \
  --broadcast-mode=block \
  --from=$RBS_WALLET \
  --chain-id=$RBS_ID \
  --gas=auto --fees 250arebus
```


Чтобы полностью удалить узел:
```
sudo systemctl stop rebusd
sudo systemctl disable rebusd
sudo rm /etc/systemd/system/anone* -rf
sudo rm $(which rebusd) -rf
sudo rm $HOME/.anone* -rf
sudo rm $HOME/anone -rf
sed -i '/RBS_/d' ~/.bash_profile
```
