<p style="font-size:14px" align="right">
 100$ Бесплатный VPS на 2 Месяца <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Присоединяйтесь к Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Посетите наш сайт
</p>



<p align="center">
  <img height="100" src="https://i.hizliresim.com/7wxdkbj.jpeg">
</p>

# ClanNetwork Руководство по установке
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

## Этапы установки Clan Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду Clan за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
wget -O CLAN.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Clan/CLAN && chmod +x CLAN.sh && ./CLAN.sh
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
cland status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
cland keys add $CLAN_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
cland keys add $CLAN_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
cland keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
CLAN_WALLET_ADDRESS=$(cland keys show $CLAN_WALLET -a)
CLAN_VALOPER_ADDRESS=$(cland keys show $CLAN_WALLET --bech val -a)
echo 'export CLAN_WALLET_ADDRESS='${CLAN_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export CLAN_VALOPER_ADDRESS='${CLAN_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 clan (1 clan равен 1000000 uclan) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
cland query bank balances $CLAN_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
```
cland tx staking create-validator \
  --amount 1000000uclan \
  --from $CLAN_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(cland tendermint show-validator) \
  --moniker $CLAN_NODENAME \
  --chain-id $CLAN_ID \
  --fees 250uclan
```


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu cland -o cat
```

Запустить службу:
```
systemctl start cland
```

Остановить службу:
```
systemctl stop cland
```

Перезапустить службу:
```
systemctl restart cland
```

### Информация об узле
Информация о синхронизации:
```
cland status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
cland status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
cland status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
cland tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
cland keys list
```

Восстановить кошелек с помощью Mnemonic:
```
cland keys add $CLAN_WALLET --recover
```

Удаление кошелька:
```
cland keys delete $CLAN_WALLET
```

Запрос баланса кошелька:
```
cland query bank balances $CLAN_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
cland tx bank send $CLAN_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uclan
```

### Голосование
```
cland tx gov vote 1 yes --from $CLAN_WALLET --chain-id=$CLAN_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
cland tx staking delegate $CLAN_VALOPER_ADDRESS 10000000uclan --from=$CLAN_WALLET --chain-id=$CLAN_ID --gas=auto --fees 250uclan
```

Повторно передать долю от валидатора другому валидатору:
```
cland tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uclan --from=$CLAN_WALLET --chain-id=$CLAN_ID --gas=auto --fees 250uclan
```

Вывести все награды:
```
cland tx distribution withdraw-all-rewards --from=$CLAN_WALLET --chain-id=$CLAN_ID --gas=auto --fees 250uclan
```

Вывод вознаграждений с комиссией:
```
cland tx distribution withdraw-rewards $CLAN_VALOPER_ADDRESS --from=$CLAN_WALLET --commission --chain-id=$CLAN_ID
```

### Управление верификатором
Изменить имя валидатора:
```
cland tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$CLAN_ID \
--from=$CLAN_WALLET
```

Выйти из тюрьмы (Unjail):
```
cland tx slashing unjail \
  --broadcast-mode=block \
  --from=$CLAN_WALLET \
  --chain-id=$CLAN_ID \
  --gas=auto --fees 250uclan
```


Чтобы полностью удалить узел:
```
sudo systemctl stop cland
sudo systemctl disable cland
sudo rm /etc/systemd/system/clan* -rf
sudo rm $(which cland) -rf
sudo rm $HOME/.clan* -rf
sudo rm $HOME/clan-network -rf
sed -i '/CLAN_/d' ~/.bash_profile
```
