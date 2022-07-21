&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/gsu0zju.png)

# Sei Руководство по установке
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

## Этапы установки Sei Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду Sei за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
wget -O SEI.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Sei/SEI && chmod +x SEI.sh && ./SEI.sh
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
seid status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
seid keys add $SEI_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
seid keys add $SEI_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
seid keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
SEI_WALLET_ADDRESS=$(seid keys show $SEI_WALLET -a)
SEI_VALOPER_ADDRESS=$(seid keys show $SEI_WALLET --bech val -a)
echo 'export SEI_WALLET_ADDRESS='${SEI_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export SEI_VALOPER_ADDRESS='${SEI_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 sei (1 sei равен 1000000 usei) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
seid query bank balances $SEI_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
```
seid tx staking create-validator \
  --amount 1000000usei \
  --from $SEI_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(seid tendermint show-validator) \
  --moniker $SEI_NODENAME \
  --chain-id $SEI_ID \
  --fees 250usei
```


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu seid -o cat
```

Запустить службу:
```
systemctl start seid
```

Остановить службу:
```
systemctl stop seid
```

Перезапустить службу:
```
systemctl restart seid
```

### Информация об узле
Информация о синхронизации:
```
seid status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
seid status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
seid status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
seid tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
seid keys list
```

Восстановить кошелек с помощью Mnemonic:
```
seid keys add $SEI_WALLET --recover
```

Удаление кошелька:
```
seid keys delete $SEI_WALLET
```

Запрос баланса кошелька:
```
seid query bank balances $SEI_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
seid tx bank send $SEI_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000usei
```

### Голосование
```
seid tx gov vote 1 yes --from $SEI_WALLET --chain-id=$SEI_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
seid tx staking delegate $SEI_VALOPER_ADDRESS 10000000usei --from=$SEI_WALLET --chain-id=$SEI_ID --gas=auto --fees 250usei
```

Повторно передать долю от валидатора другому валидатору:
```
seid tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000usei --from=$SEI_WALLET --chain-id=$SEI_ID --gas=auto --fees 250usei
```

Вывести все награды:
```
seid tx distribution withdraw-all-rewards --from=$SEI_WALLET --chain-id=$SEI_ID --gas=auto --fees 250usei
```

Вывод вознаграждений с комиссией:
```
seid tx distribution withdraw-rewards $SEI_VALOPER_ADDRESS --from=$SEI_WALLET --commission --chain-id=$SEI_ID
```

### Управление верификатором
Изменить имя валидатора:
```
seid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$SEI_ID \
--from=$SEI_WALLET
```

Выйти из тюрьмы (Unjail):
```
seid tx slashing unjail \
  --broadcast-mode=block \
  --from=$SEI_WALLET \
  --chain-id=$SEI_ID \
  --gas=auto --fees 250usei
```


Чтобы полностью удалить узел:
```
sudo systemctl stop seid
sudo systemctl disable seid
sudo rm /etc/systemd/system/seid* -rf
sudo rm $(which seid) -rf
sudo rm $HOME/.sei* -rf
sudo rm $HOME/sei-chain -rf
sed -i '/SEI_/d' ~/.bash_profile
```
