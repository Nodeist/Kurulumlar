&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/4mmj0u4.png)


# Defund Руководство по установке
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

## Этапы установки Defund Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду Defund за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
wget -O FETF.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Defund/FETF && chmod +x FETF.sh && ./FETF.sh
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
defundd status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
defundd keys add $FETF_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
defundd keys add $FETF_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
defundd keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
FETF_WALLET_ADDRESS=$(defundd keys show $FETF_WALLET -a)
FETF_VALOPER_ADDRESS=$(defundd keys show $FETF_WALLET --bech val -a)
echo 'export FETF_WALLET_ADDRESS='${FETF_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export FETF_VALOPER_ADDRESS='${FETF_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 fetf (1 fetf равен 1000000 ufetf) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
defundd query bank balances $FETF_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
```
defundd tx staking create-validator \
  --amount 1000000ufetf \
  --from $FETF_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(defundd tendermint show-validator) \
  --moniker $FETF_NODENAME \
  --chain-id $FETF_ID \
  --fees 250ufetf
```


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu defundd -o cat
```

Запустить службу:
```
systemctl start defundd
```

Остановить службу:
```
systemctl stop defundd
```

Перезапустить службу:
```
systemctl restart defundd
```

### Информация об узле
Информация о синхронизации:
```
defundd status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
defundd status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
defundd status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
defundd tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
defundd keys list
```

Восстановить кошелек с помощью Mnemonic:
```
defundd keys add $FETF_WALLET --recover
```

Удаление кошелька:
```
defundd keys delete $FETF_WALLET
```

Запрос баланса кошелька:
```
defundd query bank balances $FETF_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
defundd tx bank send $FETF_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ufetf
```

### Голосование
```
defundd tx gov vote 1 yes --from $FETF_WALLET --chain-id=$FETF_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
defundd tx staking delegate $FETF_VALOPER_ADDRESS 10000000ufetf --from=$FETF_WALLET --chain-id=$FETF_ID --gas=auto --fees 250ufetf
```

Повторно передать долю от валидатора другому валидатору:
```
defundd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ufetf --from=$FETF_WALLET --chain-id=$FETF_ID --gas=auto --fees 250ufetf
```

Вывести все награды:
```
defundd tx distribution withdraw-all-rewards --from=$FETF_WALLET --chain-id=$FETF_ID --gas=auto --fees 250ufetf
```

Вывод вознаграждений с комиссией:
```
defundd tx distribution withdraw-rewards $FETF_VALOPER_ADDRESS --from=$FETF_WALLET --commission --chain-id=$FETF_ID
```

### Управление верификатором
Изменить имя валидатора:
```
defundd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$FETF_ID \
--from=$FETF_WALLET
```

Выйти из тюрьмы (Unjail):
```
defundd tx slashing unjail \
  --broadcast-mode=block \
  --from=$FETF_WALLET \
  --chain-id=$FETF_ID \
  --gas=auto --fees 250ufetf
```


Чтобы полностью удалить узел:
```
sudo systemctl stop defundd
sudo systemctl disable defundd
sudo rm /etc/systemd/system/anone* -rf
sudo rm $(which defundd) -rf
sudo rm $HOME/.anone* -rf
sudo rm $HOME/anone -rf
sed -i '/FETF_/d' ~/.bash_profile
```
  