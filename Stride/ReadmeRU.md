<p style="font-size:14px" align="right">
 100$ Бесплатный VPS на 2 Месяца <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Присоединяйтесь к Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Посетите наш сайт
</p>



<p align="center">
<img height="100" src="https://i.hizliresim.com/qa5txaz.png">
</p>

# Stride Руководство по установке
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

## Этапы установки Stride Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду Stride за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
wget -O STRD.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Stride/STRD && chmod +x STRD.sh && ./STRD.sh
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
strided status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
strided keys add $STRD_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
strided keys add $STRD_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
strided keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
STRD_WALLET_ADDRESS=$(strided keys show $STRD_WALLET -a)
STRD_VALOPER_ADDRESS=$(strided keys show $STRD_WALLET --bech val -a)
echo 'export STRD_WALLET_ADDRESS='${STRD_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export STRD_VALOPER_ADDRESS='${STRD_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 strd (1 strd равен 1000000 ustrd) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
strided query bank balances $STRD_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
```
strided tx staking create-validator \
  --amount 1000000ustrd \
  --from $STRD_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(strided tendermint show-validator) \
  --moniker $STRD_NODENAME \
  --chain-id $STRD_ID \
  --fees 250ustrd
```


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu strided -o cat
```

Запустить службу:
```
systemctl start strided
```

Остановить службу:
```
systemctl stop strided
```

Перезапустить службу:
```
systemctl restart strided
```

### Информация об узле
Информация о синхронизации:
```
strided status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
strided status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
strided status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
strided tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
strided keys list
```

Восстановить кошелек с помощью Mnemonic:
```
strided keys add $STRD_WALLET --recover
```

Удаление кошелька:
```
strided keys delete $STRD_WALLET
```

Запрос баланса кошелька:
```
strided query bank balances $STRD_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
strided tx bank send $STRD_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ustrd
```

### Голосование
```
strided tx gov vote 1 yes --from $STRD_WALLET --chain-id=$STRD_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
strided tx staking delegate $STRD_VALOPER_ADDRESS 10000000ustrd --from=$STRD_WALLET --chain-id=$STRD_ID --gas=auto --fees 250ustrd
```

Повторно передать долю от валидатора другому валидатору:
```
strided tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ustrd --from=$STRD_WALLET --chain-id=$STRD_ID --gas=auto --fees 250ustrd
```

Вывести все награды:
```
strided tx distribution withdraw-all-rewards --from=$STRD_WALLET --chain-id=$STRD_ID --gas=auto --fees 250ustrd
```

Вывод вознаграждений с комиссией:
```
strided tx distribution withdraw-rewards $STRD_VALOPER_ADDRESS --from=$STRD_WALLET --commission --chain-id=$STRD_ID
```

### Управление верификатором
Изменить имя валидатора:
```
strided tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$STRD_ID \
--from=$STRD_WALLET
```

Выйти из тюрьмы (Unjail):
```
strided tx slashing unjail \
  --broadcast-mode=block \
  --from=$STRD_WALLET \
  --chain-id=$STRD_ID \
  --gas=auto --fees 250ustrd
```


Чтобы полностью удалить узел:
```
sudo systemctl stop strided
sudo systemctl disable strided
sudo rm /etc/systemd/system/stride* -rf
sudo rm $(which strided) -rf
sudo rm $HOME/.stride* -rf
sudo rm $HOME/stride -rf
sed -i '/STRD_/d' ~/.bash_profile
```
