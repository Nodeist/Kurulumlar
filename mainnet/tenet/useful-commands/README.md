## 🔑 Key management

#### Add new key

```bash
tenetd keys add wallet
```

#### Recover existing key

```bash
tenetd keys add wallet --recover
```

#### List all keys

```bash
tenetd keys list
```

#### Delete key

```bash
tenetd keys delete wallet
```

#### Export key to the file

```bash
tenetd keys export wallet
```

#### Import key from the file

```bash
tenetd keys import wallet wallet.backup
```

#### Query wallet balance

```bash
tenetd q bank balances $(tenetd keys show wallet -a)
```

## 👷 Validator management


- Please make sure you have adjusted **moniker**, **identity**, **details** and **website** to match your values.


#### Create new validator

```bash
tenetd tx staking create-validator \
--amount 1000000utenet \
--pubkey $(tenetd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id tenet_1559-1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025utenet \
-y
```

#### Edit existing validator

```bash
tenetd tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id tenet_1559-1 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025utenet \
-y
```

#### Unjail validator

```bash
tenetd tx slashing unjail --from wallet --chain-id tenet_1559-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025utenet -y
```

#### Jail reason

```bash
tenetd query slashing signing-info $(tenetd tendermint show-validator)
```

#### List all active validators

```bash
tenetd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### List all inactive validators

```bash
tenetd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### View validator details

```bash
tenetd q staking validator $(tenetd keys show wallet --bech val -a)
```

## 💲 Token management

#### Withdraw rewards from all validators

```bash
tenetd tx distribution withdraw-all-rewards --from wallet --chain-id tenet_1559-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025utenet -y
```

#### Withdraw commission and rewards from your validator

```bash
tenetd tx distribution withdraw-rewards $(tenetd keys show wallet --bech val -a) --commission --from wallet --chain-id tenet_1559-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025utenet -y
```

#### Delegate tokens to yourself

```bash
tenetd tx staking delegate $(tenetd keys show wallet --bech val -a) 1000000utenet --from wallet --chain-id tenet_1559-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025utenet -y
```

#### Delegate tokens to validator

```bash
tenetd tx staking delegate <TO_VALOPER_ADDRESS> 1000000utenet --from wallet --chain-id tenet_1559-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025utenet -y
```

#### Redelegate tokens to another validator

```bash
tenetd tx staking redelegate $(tenetd keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000utenet --from wallet --chain-id tenet_1559-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025utenet -y
```

#### Unbond tokens from your validator

```bash
tenetd tx staking unbond $(tenetd keys show wallet --bech val -a) 1000000utenet --from wallet --chain-id tenet_1559-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025utenet -y
```

#### Send tokens to the wallet

```bash
tenetd tx bank send wallet <TO_WALLET_ADDRESS> 1000000utenet --from wallet --chain-id tenet_1559-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025utenet -y
```

## 🗳 Governance

#### List all proposals

```bash
tenetd query gov proposals
```

#### View proposal by id

```bash
tenetd query gov proposal 1
```

#### Vote 'Yes'

```bash
tenetd tx gov vote 1 yes --from wallet --chain-id tenet_1559-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025utenet -y
```

#### Vote 'No'

```bash
tenetd tx gov vote 1 no --from wallet --chain-id tenet_1559-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025utenet -y
```

#### Vote 'Abstain'

```bash
tenetd tx gov vote 1 abstain --from wallet --chain-id tenet_1559-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025utenet -y
```

#### Vote 'NoWithVeto'

```bash
tenetd tx gov vote 1 NoWithVeto --from wallet --chain-id tenet_1559-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025utenet -y
```

## ⚡️ Utility

#### Update ports

```bash
CUSTOM_PORT=20
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.tenetd/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.tenetd/config/app.toml
```

#### Update Indexer

##### Disable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.tenetd/config/config.toml
```

##### Enable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.tenetd/config/config.toml
```

#### Update pruning

```bash
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.tenetd/config/app.toml
```

## 🚨 Maintenance

#### Get validator info

```bash
tenetd status 2>&1 | jq .ValidatorInfo
```

#### Get sync info

```bash
tenetd status 2>&1 | jq .SyncInfo
```

#### Get node peer

```bash
echo $(tenetd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.tenetd/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

#### Check if validator key is correct

```bash
[[ $(tenetd q staking validator $(tenetd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(tenetd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

#### Get live peers

```bash
curl -sS http://localhost:27657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

#### Set minimum gas price

```bash
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025utenet\"/" $HOME/.tenetd/config/app.toml
```

#### Enable prometheus

```bash
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.tenetd/config/config.toml
```

#### Reset chain data

```bash
tenetd tendermint unsafe-reset-all --home $HOME/.tenetd --keep-addr-book
```

#### Remove node

- Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your **priv_validator_key.json**!


```bash
cd $HOME
sudo systemctl stop tenetd
sudo systemctl disable tenetd
sudo rm /etc/systemd/system/tenetd.service
sudo systemctl daemon-reload
rm -f $(which tenetd)
rm -rf $HOME/.tenetd
```

## ⚙️ Service Management

#### Reload service configuration

```bash
sudo systemctl daemon-reload
```

#### Enable service

```bash
sudo systemctl enable tenetd
```

#### Disable service

```bash
sudo systemctl disable tenetd
```

#### Start service

```bash
sudo systemctl start tenetd
```

#### Stop service

```bash
sudo systemctl stop tenetd
```

#### Restart service

```bash
sudo systemctl restart tenetd
```

#### Check service status

```bash
sudo systemctl status tenetd
```

#### Check service logs

```bash
sudo journalctl -u tenetd -f --no-hostname -o cat
```
