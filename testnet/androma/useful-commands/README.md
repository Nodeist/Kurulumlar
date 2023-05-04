## 🔑 Key management

#### Add new key

```bash
andromad keys add wallet
```

#### Recover existing key

```bash
andromad keys add wallet --recover
```

#### List all keys

```bash
andromad keys list
```

#### Delete key

```bash
andromad keys delete wallet
```

#### Export key to the file

```bash
andromad keys export wallet
```

#### Import key from the file

```bash
andromad keys import wallet wallet.backup
```

#### Query wallet balance

```bash
andromad q bank balances $(andromad keys show wallet -a)
```

## 👷 Validator management


- Please make sure you have adjusted **moniker**, **identity**, **details** and **website** to match your values.


#### Create new validator

```bash
andromad tx staking create-validator \
--amount 1000000uandr \
--pubkey $(andromad tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id androma-1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025uandr \
-y
```

#### Edit existing validator

```bash
andromad tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id androma-1 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025uandr \
-y
```

#### Unjail validator

```bash
andromad tx slashing unjail --from wallet --chain-id androma-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uandr -y
```

#### Jail reason

```bash
andromad query slashing signing-info $(andromad tendermint show-validator)
```

#### List all active validators

```bash
andromad q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### List all inactive validators

```bash
andromad q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### View validator details

```bash
andromad q staking validator $(andromad keys show wallet --bech val -a)
```

## 💲 Token management

#### Withdraw rewards from all validators

```bash
andromad tx distribution withdraw-all-rewards --from wallet --chain-id androma-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uandr -y
```

#### Withdraw commission and rewards from your validator

```bash
andromad tx distribution withdraw-rewards $(andromad keys show wallet --bech val -a) --commission --from wallet --chain-id androma-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uandr -y
```

#### Delegate tokens to yourself

```bash
andromad tx staking delegate $(andromad keys show wallet --bech val -a) 1000000uandr --from wallet --chain-id androma-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uandr -y
```

#### Delegate tokens to validator

```bash
andromad tx staking delegate <TO_VALOPER_ADDRESS> 1000000uandr --from wallet --chain-id androma-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uandr -y
```

#### Redelegate tokens to another validator

```bash
andromad tx staking redelegate $(andromad keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000uandr --from wallet --chain-id androma-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uandr -y
```

#### Unbond tokens from your validator

```bash
andromad tx staking unbond $(andromad keys show wallet --bech val -a) 1000000uandr --from wallet --chain-id androma-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uandr -y
```

#### Send tokens to the wallet

```bash
andromad tx bank send wallet <TO_WALLET_ADDRESS> 1000000uandr --from wallet --chain-id androma-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uandr -y
```

## 🗳 Governance

#### List all proposals

```bash
andromad query gov proposals
```

#### View proposal by id

```bash
andromad query gov proposal 1
```

#### Vote 'Yes'

```bash
andromad tx gov vote 1 yes --from wallet --chain-id androma-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uandr -y
```

#### Vote 'No'

```bash
andromad tx gov vote 1 no --from wallet --chain-id androma-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uandr -y
```

#### Vote 'Abstain'

```bash
andromad tx gov vote 1 abstain --from wallet --chain-id androma-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uandr -y
```

#### Vote 'NoWithVeto'

```bash
andromad tx gov vote 1 NoWithVeto --from wallet --chain-id androma-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uandr -y
```

## ⚡️ Utility

#### Update ports

```bash
CUSTOM_PORT=57
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.androma/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.androma/config/app.toml
```

#### Update Indexer

##### Disable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.androma/config/config.toml
```

##### Enable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.androma/config/config.toml
```

#### Update pruning

```bash
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.androma/config/app.toml
```

## 🚨 Maintenance

#### Get validator info

```bash
andromad status 2>&1 | jq .ValidatorInfo
```

#### Get sync info

```bash
andromad status 2>&1 | jq .SyncInfo
```

#### Get node peer

```bash
echo $(andromad tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.androma/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

#### Check if validator key is correct

```bash
[[ $(andromad q staking validator $(andromad keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(andromad status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

#### Set minimum gas price

```bash
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025uandr\"/" $HOME/.androma/config/app.toml
```

#### Enable prometheus

```bash
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.androma/config/config.toml
```

#### Reset chain data

```bash
andromad tendermint unsafe-reset-all --home $HOME/.androma --keep-addr-book
```

#### Remove node

- Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your **priv_validator_key.json**!


```bash
cd $HOME
sudo systemctl stop andromad
sudo systemctl disable andromad
sudo rm /etc/systemd/system/andromad.service
sudo systemctl daemon-reload
rm -f $(which andromad)
rm -rf $HOME/.androma
rm -rf $HOME/androma
```

## ⚙️ Service Management

#### Reload service configuration

```bash
sudo systemctl daemon-reload
```

#### Enable service

```bash
sudo systemctl enable andromad
```

#### Disable service

```bash
sudo systemctl disable andromad
```

#### Start service

```bash
sudo systemctl start andromad
```

#### Stop service

```bash
sudo systemctl stop andromad
```

#### Restart service

```bash
sudo systemctl restart andromad
```

#### Check service status

```bash
sudo systemctl status andromad
```

#### Check service logs

```bash
sudo journalctl -u andromad -f --no-hostname -o cat
```
