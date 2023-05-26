## 🔑 Key management

#### Add new key

```bash
noriad keys add wallet
```

#### Recover existing key

```bash
noriad keys add wallet --recover
```

#### List all keys

```bash
noriad keys list
```

#### Delete key

```bash
noriad keys delete wallet
```

#### Export key to the file

```bash
noriad keys export wallet
```

#### Import key from the file

```bash
noriad keys import wallet wallet.backup
```

#### Query wallet balance

```bash
noriad q bank balances $(noriad keys show wallet -a)
```

## 👷 Validator management


- Please make sure you have adjusted **moniker**, **identity**, **details** and **website** to match your values.


#### Create new validator

```bash
noriad tx staking create-validator \
--amount 1000000ucrd \
--pubkey $(noriad tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id oasis-3 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025ucrd \
-y
```

#### Edit existing validator

```bash
noriad tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id oasis-3 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025ucrd \
-y
```

#### Unjail validator

```bash
noriad tx slashing unjail --from wallet --chain-id oasis-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ucrd -y
```

#### Jail reason

```bash
noriad query slashing signing-info $(noriad tendermint show-validator)
```

#### List all active validators

```bash
noriad q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### List all inactive validators

```bash
noriad q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### View validator details

```bash
noriad q staking validator $(noriad keys show wallet --bech val -a)
```

## 💲 Token management

#### Withdraw rewards from all validators

```bash
noriad tx distribution withdraw-all-rewards --from wallet --chain-id oasis-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ucrd -y
```

#### Withdraw commission and rewards from your validator

```bash
noriad tx distribution withdraw-rewards $(noriad keys show wallet --bech val -a) --commission --from wallet --chain-id oasis-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ucrd -y
```

#### Delegate tokens to yourself

```bash
noriad tx staking delegate $(noriad keys show wallet --bech val -a) 1000000ucrd --from wallet --chain-id oasis-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ucrd -y
```

#### Delegate tokens to validator

```bash
noriad tx staking delegate <TO_VALOPER_ADDRESS> 1000000ucrd --from wallet --chain-id oasis-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ucrd -y
```

#### Redelegate tokens to another validator

```bash
noriad tx staking redelegate $(noriad keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000ucrd --from wallet --chain-id oasis-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ucrd -y
```

#### Unbond tokens from your validator

```bash
noriad tx staking unbond $(noriad keys show wallet --bech val -a) 1000000ucrd --from wallet --chain-id oasis-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ucrd -y
```

#### Send tokens to the wallet

```bash
noriad tx bank send wallet <TO_WALLET_ADDRESS> 1000000ucrd --from wallet --chain-id oasis-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ucrd -y
```

## 🗳 Governance

#### List all proposals

```bash
noriad query gov proposals
```

#### View proposal by id

```bash
noriad query gov proposal 1
```

#### Vote 'Yes'

```bash
noriad tx gov vote 1 yes --from wallet --chain-id oasis-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ucrd -y
```

#### Vote 'No'

```bash
noriad tx gov vote 1 no --from wallet --chain-id oasis-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ucrd -y
```

#### Vote 'Abstain'

```bash
noriad tx gov vote 1 abstain --from wallet --chain-id oasis-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ucrd -y
```

#### Vote 'NoWithVeto'

```bash
noriad tx gov vote 1 NoWithVeto --from wallet --chain-id oasis-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ucrd -y
```

## ⚡️ Utility

#### Update ports

```bash
CUSTOM_PORT=96
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.noria/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.noria/config/app.toml
```

#### Update Indexer

##### Disable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.noria/config/config.toml
```

##### Enable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.noria/config/config.toml
```

#### Update pruning

```bash
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.noria/config/app.toml
```

## 🚨 Maintenance

#### Get validator info

```bash
noriad status 2>&1 | jq .ValidatorInfo
```

#### Get sync info

```bash
noriad status 2>&1 | jq .SyncInfo
```

#### Get node peer

```bash
echo $(noriad tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.noria/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

#### Check if validator key is correct

```bash
[[ $(noriad q staking validator $(noriad keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(noriad status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

#### Set minimum gas price

```bash
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025ucrd\"/" $HOME/.noria/config/app.toml
```

#### Enable prometheus

```bash
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.noria/config/config.toml
```

#### Reset chain data

```bash
noriad tendermint unsafe-reset-all --home $HOME/.noria --keep-addr-book
```

#### Remove node

- Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your **priv_validator_key.json**!


```bash
cd $HOME
sudo systemctl stop noriad
sudo systemctl disable noriad
sudo rm /etc/systemd/system/noriad.service
sudo systemctl daemon-reload
rm -f $(which noriad)
rm -rf $HOME/.noria
rm -rf $HOME/noria
```

## ⚙️ Service Management

#### Reload service configuration

```bash
sudo systemctl daemon-reload
```

#### Enable service

```bash
sudo systemctl enable noriad
```

#### Disable service

```bash
sudo systemctl disable noriad
```

#### Start service

```bash
sudo systemctl start noriad
```

#### Stop service

```bash
sudo systemctl stop noriad
```

#### Restart service

```bash
sudo systemctl restart noriad
```

#### Check service status

```bash
sudo systemctl status noriad
```

#### Check service logs

```bash
sudo journalctl -u noriad -f --no-hostname -o cat
```
