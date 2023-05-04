## 🔑 Key management

#### Add new key

```bash
elysd keys add wallet
```

#### Recover existing key

```bash
elysd keys add wallet --recover
```

#### List all keys

```bash
elysd keys list
```

#### Delete key

```bash
elysd keys delete wallet
```

#### Export key to the file

```bash
elysd keys export wallet
```

#### Import key from the file

```bash
elysd keys import wallet wallet.backup
```

#### Query wallet balance

```bash
elysd q bank balances $(elysd keys show wallet -a)
```

## 👷 Validator management


- Please make sure you have adjusted **moniker**, **identity**, **details** and **website** to match your values.


#### Create new validator

```bash
elysd tx staking create-validator \
--amount 1000000uelys \
--pubkey $(elysd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id elystestnet-1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025uelys \
-y
```

#### Edit existing validator

```bash
elysd tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id elystestnet-1 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025uelys \
-y
```

#### Unjail validator

```bash
elysd tx slashing unjail --from wallet --chain-id elystestnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uelys -y
```

#### Jail reason

```bash
elysd query slashing signing-info $(elysd tendermint show-validator)
```

#### List all active validators

```bash
elysd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### List all inactive validators

```bash
elysd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### View validator details

```bash
elysd q staking validator $(elysd keys show wallet --bech val -a)
```

## 💲 Token management

#### Withdraw rewards from all validators

```bash
elysd tx distribution withdraw-all-rewards --from wallet --chain-id elystestnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uelys -y
```

#### Withdraw commission and rewards from your validator

```bash
elysd tx distribution withdraw-rewards $(elysd keys show wallet --bech val -a) --commission --from wallet --chain-id elystestnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uelys -y
```

#### Delegate tokens to yourself

```bash
elysd tx staking delegate $(elysd keys show wallet --bech val -a) 1000000uelys --from wallet --chain-id elystestnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uelys -y
```

#### Delegate tokens to validator

```bash
elysd tx staking delegate <TO_VALOPER_ADDRESS> 1000000uelys --from wallet --chain-id elystestnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uelys -y
```

#### Redelegate tokens to another validator

```bash
elysd tx staking redelegate $(elysd keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000uelys --from wallet --chain-id elystestnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uelys -y
```

#### Unbond tokens from your validator

```bash
elysd tx staking unbond $(elysd keys show wallet --bech val -a) 1000000uelys --from wallet --chain-id elystestnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uelys -y
```

#### Send tokens to the wallet

```bash
elysd tx bank send wallet <TO_WALLET_ADDRESS> 1000000uelys --from wallet --chain-id elystestnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uelys -y
```

## 🗳 Governance

#### List all proposals

```bash
elysd query gov proposals
```

#### View proposal by id

```bash
elysd query gov proposal 1
```

#### Vote 'Yes'

```bash
elysd tx gov vote 1 yes --from wallet --chain-id elystestnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uelys -y
```

#### Vote 'No'

```bash
elysd tx gov vote 1 no --from wallet --chain-id elystestnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uelys -y
```

#### Vote 'Abstain'

```bash
elysd tx gov vote 1 abstain --from wallet --chain-id elystestnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uelys -y
```

#### Vote 'NoWithVeto'

```bash
elysd tx gov vote 1 NoWithVeto --from wallet --chain-id elystestnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uelys -y
```

## ⚡️ Utility

#### Update ports

```bash
CUSTOM_PORT=62
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.elys/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.elys/config/app.toml
```

#### Update Indexer

##### Disable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.elys/config/config.toml
```

##### Enable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.elys/config/config.toml
```

#### Update pruning

```bash
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.elys/config/app.toml
```

## 🚨 Maintenance

#### Get validator info

```bash
elysd status 2>&1 | jq .ValidatorInfo
```

#### Get sync info

```bash
elysd status 2>&1 | jq .SyncInfo
```

#### Get node peer

```bash
echo $(elysd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.elys/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

#### Check if validator key is correct

```bash
[[ $(elysd q staking validator $(elysd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(elysd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

#### Set minimum gas price

```bash
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025uelys\"/" $HOME/.elys/config/app.toml
```

#### Enable prometheus

```bash
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.elys/config/config.toml
```

#### Reset chain data

```bash
elysd tendermint unsafe-reset-all --home $HOME/.elys --keep-addr-book
```

#### Remove node

- Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your **priv_validator_key.json**!


```bash
cd $HOME
sudo systemctl stop elysd
sudo systemctl disable elysd
sudo rm /etc/systemd/system/elysd.service
sudo systemctl daemon-reload
rm -f $(which elysd)
rm -rf $HOME/.elys
rm -rf $HOME/elys
```

## ⚙️ Service Management

#### Reload service configuration

```bash
sudo systemctl daemon-reload
```

#### Enable service

```bash
sudo systemctl enable elysd
```

#### Disable service

```bash
sudo systemctl disable elysd
```

#### Start service

```bash
sudo systemctl start elysd
```

#### Stop service

```bash
sudo systemctl stop elysd
```

#### Restart service

```bash
sudo systemctl restart elysd
```

#### Check service status

```bash
sudo systemctl status elysd
```

#### Check service logs

```bash
sudo journalctl -u elysd -f --no-hostname -o cat
```
