<p style="font-size:14px" align="right">
 100$ Бесплатный VPS на 2 Месяца <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Присоединяйтесь к Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Посетите наш сайт
</p>



<p align="center">
  <img height="100" src="https://i.hizliresim.com/cdpen5h.png">
</p>

# Another-1 Руководство по установке
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

## Этапы установки Anone Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду Anone за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
wget -O ANONE.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Anone/ANONE && chmod +x ANONE.sh && ./ANONE.sh
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
anoned status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
anoned keys add $ANONE_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
anoned keys add $ANONE_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
anoned keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
ANONE_WALLET_ADDRESS=$(anoned keys show $ANONE_WALLET -a)
ANONE_VALOPER_ADDRESS=$(anoned keys show $ANONE_WALLET --bech val -a)
echo 'export ANONE_WALLET_ADDRESS='${ANONE_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export ANONE_VALOPER_ADDRESS='${ANONE_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 an1 (1 an1 равен 1000000 uan1) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
anoned query bank balances $ANONE_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
```
anoned tx staking create-validator \
  --amount 1000000uan1 \
  --from $ANONE_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(anoned tendermint show-validator) \
  --moniker $ANONE_NODENAME \
  --chain-id $ANONE_ID \
  --fees 250uan1
```


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu anoned -o cat
```

Запустить службу:
```
systemctl start anoned
```

Остановить службу:
```
systemctl stop anoned
```

Перезапустить службу:
```
systemctl restart anoned
```

### Информация об узле
Информация о синхронизации:
```
anoned status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
anoned status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
anoned status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
anoned tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
anoned keys list
```

Восстановить кошелек с помощью Mnemonic:
```
anoned keys add $ANONE_WALLET --recover
```

Удаление кошелька:
```
anoned keys delete $ANONE_WALLET
```

Запрос баланса кошелька:
```
anoned query bank balances $ANONE_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
anoned tx bank send $ANONE_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uan1
```

### Голосование
```
anoned tx gov vote 1 yes --from $ANONE_WALLET --chain-id=$ANONE_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
anoned tx staking delegate $ANONE_VALOPER_ADDRESS 10000000uan1 --from=$ANONE_WALLET --chain-id=$ANONE_ID --gas=auto --fees 250uan1
```

Повторно передать долю от валидатора другому валидатору:
```
anoned tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uan1 --from=$ANONE_WALLET --chain-id=$ANONE_ID --gas=auto --fees 250uan1
```

Вывести все награды:
```
anoned tx distribution withdraw-all-rewards --from=$ANONE_WALLET --chain-id=$ANONE_ID --gas=auto --fees 250uan1
```

Вывод вознаграждений с комиссией:
```
anoned tx distribution withdraw-rewards $ANONE_VALOPER_ADDRESS --from=$ANONE_WALLET --commission --chain-id=$ANONE_ID
```

### Управление верификатором
Изменить имя валидатора:
```
anoned tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$ANONE_ID \
--from=$ANONE_WALLET
```

Выйти из тюрьмы (Unjail):
```
anoned tx slashing unjail \
  --broadcast-mode=block \
  --from=$ANONE_WALLET \
  --chain-id=$ANONE_ID \
  --gas=auto --fees 250uan1
```


Чтобы полностью удалить узел:
```
sudo systemctl stop anoned
sudo systemctl disable anoned
sudo rm /etc/systemd/system/anone* -rf
sudo rm $(which anoned) -rf
sudo rm $HOME/.anone* -rf
sudo rm $HOME/anone -rf
sed -i '/ANONE_/d' ~/.bash_profile
```
