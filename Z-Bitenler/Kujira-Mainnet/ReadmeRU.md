<p style="font-size:14px" align="right">
 100$ Бесплатный VPS на 2 Месяца <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Присоединяйтесь к Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Посетите наш сайт
</p>



<p align="center">
<img height="100" src="https://i.hizliresim.com/hb4a5iv.png">
</p>

# Kujira Руководство по установке
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

## Этапы установки Kujira Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду Kujira за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Z-Bitenler/Kujira-Mainnet/KUJI
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
kujirad status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
kujirad keys add $KUJI_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
kujirad keys add $KUJI_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
kujirad keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
KUJI_WALLET_ADDRESS=$(kujirad keys show $KUJI_WALLET -a)
KUJI_VALOPER_ADDRESS=$(kujirad keys show $KUJI_WALLET --bech val -a)
echo 'export KUJI_WALLET_ADDRESS='${KUJI_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export KUJI_VALOPER_ADDRESS='${KUJI_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 kuji (1 kuji равен 1000000 ukuji) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
kujirad query bank balances $KUJI_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
```
kujirad tx staking create-validator \
  --amount 1000000ukuji \
  --from $KUJI_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(kujirad tendermint show-validator) \
  --moniker $KUJI_NODENAME \
  --chain-id $KUJI_ID \
  --fees 250ukuji
```


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu kujirad -o cat
```

Запустить службу:
```
systemctl start kujirad
```

Остановить службу:
```
systemctl stop kujirad
```

Перезапустить службу:
```
systemctl restart kujirad
```

### Информация об узле
Информация о синхронизации:
```
kujirad status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
kujirad status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
kujirad status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
kujirad tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
kujirad keys list
```

Восстановить кошелек с помощью Mnemonic:
```
kujirad keys add $KUJI_WALLET --recover
```

Удаление кошелька:
```
kujirad keys delete $KUJI_WALLET
```

Запрос баланса кошелька:
```
kujirad query bank balances $KUJI_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
kujirad tx bank send $KUJI_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ukuji
```

### Голосование
```
kujirad tx gov vote 1 yes --from $KUJI_WALLET --chain-id=$KUJI_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
kujirad tx staking delegate $KUJI_VALOPER_ADDRESS 10000000ukuji --from=$KUJI_WALLET --chain-id=$KUJI_ID --gas=auto --fees 250ukuji
```

Повторно передать долю от валидатора другому валидатору:
```
kujirad tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ukuji --from=$KUJI_WALLET --chain-id=$KUJI_ID --gas=auto --fees 250ukuji
```

Вывести все награды:
```
kujirad tx distribution withdraw-all-rewards --from=$KUJI_WALLET --chain-id=$KUJI_ID --gas=auto --fees 250ukuji
```

Вывод вознаграждений с комиссией:
```
kujirad tx distribution withdraw-rewards $KUJI_VALOPER_ADDRESS --from=$KUJI_WALLET --commission --chain-id=$KUJI_ID
```

### Управление верификатором
Изменить имя валидатора:
```
kujirad tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$KUJI_ID \
--from=$KUJI_WALLET
```

Выйти из тюрьмы (Unjail):
```
kujirad tx slashing unjail \
  --broadcast-mode=block \
  --from=$KUJI_WALLET \
  --chain-id=$KUJI_ID \
  --gas=auto --fees 250ukuji
```


Чтобы полностью удалить узел:
```
sudo systemctl stop kujirad
sudo systemctl disable kujirad
sudo rm /etc/systemd/system/kujira* -rf
sudo rm $(which kujirad) -rf
sudo rm $HOME/.kujira* -rf
sudo rm $HOME/core -rf
sed -i '/KUJI_/d' ~/.bash_profile
```
