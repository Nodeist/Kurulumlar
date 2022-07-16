<p style="font-size:14px" align="right">
 100$ Бесплатный VPS на 2 Месяца <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Присоединяйтесь к Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Посетите наш сайт
</p>



<p align="center">
<img height="100" src="https://i.hizliresim.com/idr6y7f.png">
</p>

# Kyve Руководство по установке
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

## Этапы установки Kyve Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду Kyve за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
wget -O KYVE.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Z-Bitenler/Kyve/KYVE && chmod +x KYVE.sh && ./KYVE.sh
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
kyved status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
kyved keys add $KYVE_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
kyved keys add $KYVE_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
kyved keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
KYVE_WALLET_ADDRESS=$(kyved keys show $KYVE_WALLET -a)
KYVE_VALOPER_ADDRESS=$(kyved keys show $KYVE_WALLET --bech val -a)
echo 'export KYVE_WALLET_ADDRESS='${KYVE_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export KYVE_VALOPER_ADDRESS='${KYVE_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 kyve (1 kyve равен 1000000 tkyve) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
kyved query bank balances $KYVE_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
```
kyved tx staking create-validator \
  --amount 1000000tkyve \
  --from $KYVE_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(kyved tendermint show-validator) \
  --moniker $KYVE_NODENAME \
  --chain-id $KYVE_ID \
  --fees 250tkyve
```


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu kyved -o cat
```

Запустить службу:
```
systemctl start kyved
```

Остановить службу:
```
systemctl stop kyved
```

Перезапустить службу:
```
systemctl restart kyved
```

### Информация об узле
Информация о синхронизации:
```
kyved status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
kyved status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
kyved status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
kyved tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
kyved keys list
```

Восстановить кошелек с помощью Mnemonic:
```
kyved keys add $KYVE_WALLET --recover
```

Удаление кошелька:
```
kyved keys delete $KYVE_WALLET
```

Запрос баланса кошелька:
```
kyved query bank balances $KYVE_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
kyved tx bank send $KYVE_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000tkyve
```

### Голосование
```
kyved tx gov vote 1 yes --from $KYVE_WALLET --chain-id=$KYVE_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
kyved tx staking delegate $KYVE_VALOPER_ADDRESS 10000000tkyve --from=$KYVE_WALLET --chain-id=$KYVE_ID --gas=auto --fees 250tkyve
```

Повторно передать долю от валидатора другому валидатору:
```
kyved tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000tkyve --from=$KYVE_WALLET --chain-id=$KYVE_ID --gas=auto --fees 250tkyve
```

Вывести все награды:
```
kyved tx distribution withdraw-all-rewards --from=$KYVE_WALLET --chain-id=$KYVE_ID --gas=auto --fees 250tkyve
```

Вывод вознаграждений с комиссией:
```
kyved tx distribution withdraw-rewards $KYVE_VALOPER_ADDRESS --from=$KYVE_WALLET --commission --chain-id=$KYVE_ID
```

### Управление верификатором
Изменить имя валидатора:
```
kyved tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$KYVE_ID \
--from=$KYVE_WALLET
```

Выйти из тюрьмы (Unjail):
```
kyved tx slashing unjail \
  --broadcast-mode=block \
  --from=$KYVE_WALLET \
  --chain-id=$KYVE_ID \
  --gas=auto --fees 250tkyve
```


Чтобы полностью удалить узел:
```
sudo systemctl stop kyved
sudo systemctl disable kyved
sudo rm /etc/systemd/system/kyved* -rf
sudo rm $(which kyved) -rf
sudo rm $HOME/.kyve* -rf
sudo rm $HOME/kyve -rf
sed -i '/KYVE_/d' ~/.bash_profile
```
