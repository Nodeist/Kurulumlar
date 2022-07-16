<p style="font-size:14px" align="right">
 100$ Бесплатный VPS на 2 Месяца <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Присоединяйтесь к Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Посетите наш сайт
</p>



<p align="center">
<img height="100" src="https://i.hizliresim.com/qii2z30.jpeg">
</p>

# CrowdControl Руководство по установке
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

## Этапы установки CrowdControl Full Node
### Автоматическая установка с помощью одного скрипта
Вы можете настроить полную ноду CrowdControl за несколько минут, используя приведенный ниже автоматизированный скрипт.
Вам будет предложено ввести имя вашего узла (NODENAME) во время скрипта!

```
wget -O CC.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/CrowdControl/CC && chmod +x CC.sh && ./CC.sh
```
### Действия после установки

Вы должны убедиться, что ваш валидатор синхронизирует блоки.
Вы можете использовать следующую команду для проверки состояния синхронизации.
```
Cardchain status 2>&1 | jq .SyncInfo
```

### Создание кошелька
Вы можете использовать следующую команду для создания нового кошелька. Не забудьте сохранить напоминание (мнемонику).
```
Cardchain keys add $CC_WALLET
```

(НЕОБЯЗАТЕЛЬНО) Чтобы восстановить кошелек с помощью мнемоники:
```
Cardchain keys add $CC_WALLET --recover
```

Чтобы получить текущий список кошельков:
```
Cardchain keys list
```
### Сохранить информацию о кошельке
Добавить адрес кошелька:
```
CC_WALLET_ADDRESS=$(Cardchain keys show $CC_WALLET -a)
CC_VALOPER_ADDRESS=$(Cardchain keys show $CC_WALLET --bech val -a)
echo 'export CC_WALLET_ADDRESS='${CC_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export CC_VALOPER_ADDRESS='${CC_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Создать валидатор
Перед созданием валидатора убедитесь, что у вас есть как минимум 1 bpf (1 bpf равен 1000000 ubpf) и ваш узел синхронизирован.
Чтобы проверить баланс кошелька:
```
Cardchain query bank balances $CC_WALLET_ADDRESS
```
> Если вы не видите свой баланс в кошельке, скорее всего, ваш узел все еще синхронизируется. Подождите, пока синхронизация завершится, а затем продолжите.

Создание валидатора:
```
Cardchain tx staking create-validator \
  --amount 1000000ubpf \
  --from $CC_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(Cardchain tendermint show-validator) \
  --moniker $CC_NODENAME \
  --chain-id $CC_ID \
  --fees 250ubpf
```


## Полезные команды
### Управление услугами
Проверить журналы:
```
journalctl -fu Cardchain -o cat
```

Запустить службу:
```
systemctl start Cardchain
```

Остановить службу:
```
systemctl stop Cardchain
```

Перезапустить службу:
```
systemctl restart Cardchain
```

### Информация об узле
Информация о синхронизации:
```
Cardchain status 2>&1 | jq .SyncInfo
```

Информация о валидаторе:
```
Cardchain status 2>&1 | jq .ValidatorInfo
```

Информация об узле:
```
Cardchain status 2>&1 | jq .NodeInfo
```

Показать идентификатор узла:
```
Cardchain tendermint show-node-id
```

### Транзакции кошелька
Список кошельков:
```
Cardchain keys list
```

Восстановить кошелек с помощью Mnemonic:
```
Cardchain keys add $CC_WALLET --recover
```

Удаление кошелька:
```
Cardchain keys delete $CC_WALLET
```

Запрос баланса кошелька:
```
Cardchain query bank balances $CC_WALLET_ADDRESS
```

Перевод баланса с кошелька на кошелек:
```
Cardchain tx bank send $CC_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ubpf
```

### Голосование
```
Cardchain tx gov vote 1 yes --from $CC_WALLET --chain-id=$CC_ID
```

### Ставка, делегирование и вознаграждение
Процесс делегирования:
```
Cardchain tx staking delegate $CC_VALOPER_ADDRESS 10000000ubpf --from=$CC_WALLET --chain-id=$CC_ID --gas=auto --fees 250ubpf
```

Повторно передать долю от валидатора другому валидатору:
```
Cardchain tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ubpf --from=$CC_WALLET --chain-id=$CC_ID --gas=auto --fees 250ubpf
```

Вывести все награды:
```
Cardchain tx distribution withdraw-all-rewards --from=$CC_WALLET --chain-id=$CC_ID --gas=auto --fees 250ubpf
```

Вывод вознаграждений с комиссией:
```
Cardchain tx distribution withdraw-rewards $CC_VALOPER_ADDRESS --from=$CC_WALLET --commission --chain-id=$CC_ID
```

### Управление верификатором
Изменить имя валидатора:
```
Cardchain tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$CC_ID \
--from=$CC_WALLET
```

Выйти из тюрьмы (Unjail):
```
Cardchain tx slashing unjail \
  --broadcast-mode=block \
  --from=$CC_WALLET \
  --chain-id=$CC_ID \
  --gas=auto --fees 250ubpf
```


Чтобы полностью удалить узел:
```
sudo systemctl stop Cardchain
sudo systemctl disable Cardchain
sudo rm /etc/systemd/system/Cardchain* -rf
sudo rm $(which Cardchain) -rf
sudo rm $HOME/.Cardchain* -rf
sudo rm $HOME/Cardchain -rf
sed -i '/CC_/d' ~/.bash_profile
```
