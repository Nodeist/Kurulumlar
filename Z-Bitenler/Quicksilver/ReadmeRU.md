<p style="font-size:14px" align="right">
 100$ Бесплатный VPS на 2 Месяца <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Присоединяйтесь к Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Посетите наш сайт
</p>



<p align="center">
<img height="100" src="https://i.hizliresim.com/k29umk7.png">
</p>

# Quicksilver Руководство по установке
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

## Этапы установки Quicksilver Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду Quicksilver за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
wget -O QCK.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Z-Bitenler/Quicksilver/QCK && chmod +x QCK.sh && ./QCK.sh
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
quicksilverd status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
quicksilverd keys add $QCK_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
quicksilverd keys add $QCK_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
quicksilverd keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
QCK_WALLET_ADDRESS=$(quicksilverd keys show $QCK_WALLET -a)
QCK_VALOPER_ADDRESS=$(quicksilverd keys show $QCK_WALLET --bech val -a)
echo 'export QCK_WALLET_ADDRESS='${QCK_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export QCK_VALOPER_ADDRESS='${QCK_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 qck (1 qck равен 1000000 uqck) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
quicksilverd query bank balances $QCK_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
```
quicksilverd tx staking create-validator \
  --amount 1000000uqck \
  --from $QCK_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(quicksilverd tendermint show-validator) \
  --moniker $QCK_NODENAME \
  --chain-id $QCK_ID \
  --fees 250uqck
```


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu quicksilverd -o cat
```

Запустить службу:
```
systemctl start quicksilverd
```

Остановить службу:
```
systemctl stop quicksilverd
```

Перезапустить службу:
```
systemctl restart quicksilverd
```

### Информация об узле
Информация о синхронизации:
```
quicksilverd status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
quicksilverd status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
quicksilverd status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
quicksilverd tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
quicksilverd keys list
```

Восстановить кошелек с помощью Mnemonic:
```
quicksilverd keys add $QCK_WALLET --recover
```

Удаление кошелька:
```
quicksilverd keys delete $QCK_WALLET
```

Запрос баланса кошелька:
```
quicksilverd query bank balances $QCK_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
quicksilverd tx bank send $QCK_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uqck
```

### Голосование
```
quicksilverd tx gov vote 1 yes --from $QCK_WALLET --chain-id=$QCK_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
quicksilverd tx staking delegate $QCK_VALOPER_ADDRESS 10000000uqck --from=$QCK_WALLET --chain-id=$QCK_ID --gas=auto --fees 250uqck
```

Повторно передать долю от валидатора другому валидатору:
```
quicksilverd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uqck --from=$QCK_WALLET --chain-id=$QCK_ID --gas=auto --fees 250uqck
```

Вывести все награды:
```
quicksilverd tx distribution withdraw-all-rewards --from=$QCK_WALLET --chain-id=$QCK_ID --gas=auto --fees 250uqck
```

Вывод вознаграждений с комиссией:
```
quicksilverd tx distribution withdraw-rewards $QCK_VALOPER_ADDRESS --from=$QCK_WALLET --commission --chain-id=$QCK_ID
```

### Управление верификатором
Изменить имя валидатора:
```
quicksilverd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$QCK_ID \
--from=$QCK_WALLET
```

Выйти из тюрьмы (Unjail):
```
quicksilverd tx slashing unjail \
  --broadcast-mode=block \
  --from=$QCK_WALLET \
  --chain-id=$QCK_ID \
  --gas=auto --fees 250uqck
```


Чтобы полностью удалить узел:
```
sudo systemctl stop quicksilverd
sudo systemctl disable quicksilverd
sudo rm /etc/systemd/system/quicksilver* -rf
sudo rm $(which quicksilverd) -rf
sudo rm $HOME/.quicksilverd* -rf
sudo rm $HOME/quicksilver -rf
sed -i '/QCK_/d' ~/.bash_profile
```
