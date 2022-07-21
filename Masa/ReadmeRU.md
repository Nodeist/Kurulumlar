&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)



## Аппаратные требования
### Минимальные аппаратные требования
- ЦП: 1 ядро
- Память: 2 ГБ ОЗУ
- Диск: 20 ГБ


# Установка узла
Следуйте инструкциям ниже

## Установить переменную
```
MASA_NODENAME=<YOUR_NODE_NAME>
```

Сохраните переменную
```
echo "export MASA_NODENAME=$MASA_NODENAME" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Обновление пакетов
```
sudo apt update && sudo apt upgrade -y
```

## Установите требования
```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu net-tools -y
```

## Перейти к настройке
```
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```

## Загрузите и установите библиотеку
```
cd $HOME && rm -rf masa-node-v1.0
git clone https://github.com/masa-finance/masa-node-v1.0
cd masa-node-v1.0/src
make all
cp $HOME/masa-node-v1.0/src/build/bin/* /usr/local/bin
```

## Запускаем приложение
```
cd $HOME/masa-node-v1.0
geth --datadir data init ./network/testnet/genesis.json
```

## Добавляем загрузочные узлы
```
cd $HOME
wget https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Masa/bootnodes.txt
MASA_BOOTNODES=$(sed ':a; N; $!ba; s/\n/,/g' bootnodes.txt)
```

## Создать сервис
```
tee /etc/systemd/system/masad.service > /dev/null <<EOF
[Unit]
Description=MASA
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which geth) \
  --identity ${MASA_NODENAME} \
  --datadir $HOME/masa-node-v1.0/data \
  --bootnodes ${MASA_BOOTNODES} \
  --emitcheckpoints \
  --istanbul.blockperiod 10 \
  --mine \
  --miner.threads 1 \
  --syncmode full \
  --verbosity 5 \
  --networkid 190260 \
  --rpc \
  --rpccorsdomain "*" \
  --rpcvhosts "*" \
  --rpcaddr 127.0.0.1 \
  --rpcport 8545 \
  --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul \
  --port 30300 \
  --maxpeers 50
Restart=on-failure
RestartSec=10
LimitNOFILE=4096
Environment="PRIVATE_CONFIG=ignore"
[Install]
WantedBy=multi-user.target
EOF
```


### Восстановить ключ узла (миграция узла... Пропустите этот шаг, если вы устанавливаете в первый раз)
Чтобы восстановить ключ узла таблицы, поместите его в _$HOME/table-node-v1.0/data/geth/nodekey_, затем перезапустите службу\
Замените «<YOUR_NODE_KEY>» ключом вашего узла и выполните следующую команду.
```
echo <YOUR_NODE_KEY> > $HOME/masa-node-v1.0/data/geth/nodekey
```

## Регистрация и начало работы
```
sudo systemctl daemon-reload
sudo systemctl enable masad
sudo systemctl restart masad
```


## Полезные команды

### Проверить логи узла таблицы
Проверить состояние блоков:
```
journalctl -u masad -f | grep "new block"
```

### Получить ключ узла таблицы
!Не забудьте сделать резервную копию вашего `nodekey` в безопасном месте. Это единственный способ восстановить вашу ноду!
```
cat $HOME/masa-node-v1.0/data/geth/nodekey
```

### Получить идентификатор таблицы enode
```
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc --exec web3.admin.nodeInfo.enode | sed 's/^.//;s/.$//'
```

### Перезапустить службу
```
systemctl restart masad.service
```

### Проверить статус узла eth
Чтобы проверить статус синхронизации узла eth, необходимо сначала включить geth.
```
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc
```

После этого вы можете использовать приведенные ниже команды в geth (должны быть из eth.syncing = false и net.peerCount > 0)
```
# каталог данных узла с конфигурациями и переключателями
admin.datadir
# проверяем, подключен ли узел
net.listening
# показать статус синхронизации
eth.syncing
# состояние узла (сложность должна равняться текущей высоте блока)
admin.nodeInfo
# показать процент синхронизации
eth.syncing.currentBlock * 100 / eth.syncing.highestBlock
# список всех подключенных пиров (shortlist)
admin.peers.forEach(function(value){console.log(value.network.remoteAddress+"\t"+value.name)})
# список всех подключенных пиров (длинный список)
admin.peers
# показать количество подключенных пиров
net.peerCount
```

_Нажмите CTRL+D, чтобы выйти_

