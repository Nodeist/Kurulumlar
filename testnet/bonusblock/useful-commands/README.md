## 🔑 Key management

#### Add new key

```bash
bonus-blockd keys add wallet
```

#### Recover existing key

```bash
bonus-blockd keys add wallet --recover
```

#### List all keys

```bash
bonus-blockd keys list
```

#### Delete key

```bash
bonus-blockd keys delete wallet
```

#### Export key to the file

```bash
bonus-blockd keys export wallet
```

#### Import key from the file

```bash
bonus-blockd keys import wallet wallet.backup
```

#### Query wallet balance

```bash
bonus-blockd q bank balances $(bonus-blockd keys show wallet -a)
```

## 👷 Validator management


- Please make sure you have adjusted **moniker**, **identity**, **details** and **website** to match your values.


#### Create new validator

```bash
bonus-blockd tx staking create-validator \
--amount 1000000ubonus \
--pubkey $(bonus-blockd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id blocktopia-01 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025ubonus \
-y
```

#### Edit existing validator

```bash
bonus-blockd tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id blocktopia-01 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025ubonus \
-y
```

#### Unjail validator

```bash
bonus-blockd tx slashing unjail --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubonus -y
```

#### Jail reason

```bash
bonus-blockd query slashing signing-info $(bonus-blockd tendermint show-validator)
```

#### List all active validators

```bash
bonus-blockd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### List all inactive validators

```bash
bonus-blockd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### View validator details

```bash
bonus-blockd q staking validator $(bonus-blockd keys show wallet --bech val -a)
```

## 💲 Token management

#### Withdraw rewards from all validators

```bash
bonus-blockd tx distribution withdraw-all-rewards --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubonus -y
```

#### Withdraw commission and rewards from your validator

```bash
bonus-blockd tx distribution withdraw-rewards $(bonus-blockd keys show wallet --bech val -a) --commission --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubonus -y
```

#### Delegate tokens to yourself

```bash
bonus-blockd tx staking delegate $(bonus-blockd keys show wallet --bech val -a) 1000000ubonus --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubonus -y
```

#### Delegate tokens to validator

```bash
bonus-blockd tx staking delegate <TO_VALOPER_ADDRESS> 1000000ubonus --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubonus -y
```

#### Redelegate tokens to another validator

```bash
bonus-blockd tx staking redelegate $(bonus-blockd keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000ubonus --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubonus -y
```

#### Unbond tokens from your validator

```bash
bonus-blockd tx staking unbond $(bonus-blockd keys show wallet --bech val -a) 1000000ubonus --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubonus -y
```

#### Send tokens to the wallet

```bash
bonus-blockd tx bank send wallet <TO_WALLET_ADDRESS> 1000000ubonus --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubonus -y
```

## 🗳 Governance

#### List all proposals

```bash
bonus-blockd query gov proposals
```

#### View proposal by id

```bash
bonus-blockd query gov proposal 1
```

#### Vote 'Yes'

```bash
bonus-blockd tx gov vote 1 yes --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubonus -y
```

#### Vote 'No'

```bash
bonus-blockd tx gov vote 1 no --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubonus -y
```

#### Vote 'Abstain'

```bash
bonus-blockd tx gov vote 1 abstain --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubonus -y
```

#### Vote 'NoWithVeto'

```bash
bonus-blockd tx gov vote 1 NoWithVeto --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubonus -y
```

## ⚡️ Utility

#### Update ports

```bash
CUSTOM_PORT=58
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.bonusblock/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.bonusblock/config/app.toml
```

#### Update Indexer

##### Disable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.bonusblock/config/config.toml
```

##### Enable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.bonusblock/config/config.toml
```

#### Update pruning

```bash
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.bonusblock/config/app.toml
```

## 🚨 Maintenance

#### Get validator info

```bash
bonus-blockd status 2>&1 | jq .ValidatorInfo
```

#### Get sync info

```bash
bonus-blockd status 2>&1 | jq .SyncInfo
```

#### Get node peer

```bash
echo $(bonus-blockd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.bonusblock/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

#### Check if validator key is correct

```bash
[[ $(bonus-blockd q staking validator $(bonus-blockd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(bonus-blockd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

#### Set minimum gas price

```bash
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025ubonus\"/" $HOME/.bonusblock/config/app.toml
```

#### Enable prometheus

```bash
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.bonusblock/config/config.toml
```

#### Reset chain data

```bash
bonus-blockd tendermint unsafe-reset-all --home $HOME/.bonusblock --keep-addr-book
```

#### Remove node

- Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your **priv_validator_key.json**!


```bash
cd $HOME
sudo systemctl stop bonus-blockd
sudo systemctl disable bonus-blockd
sudo rm /etc/systemd/system/bonus-blockd.service
sudo systemctl daemon-reload
rm -f $(which bonus-blockd)
rm -rf $HOME/.bonusblock
rm -rf $HOME/BonusBlock-chain
```

## ⚙️ Service Management

#### Reload service configuration

```bash
sudo systemctl daemon-reload
```

#### Enable service

```bash
sudo systemctl enable bonus-blockd
```

#### Disable service

```bash
sudo systemctl disable bonus-blockd
```

#### Start service

```bash
sudo systemctl start bonus-blockd
```

#### Stop service

```bash
sudo systemctl stop bonus-blockd
```

#### Restart service

```bash
sudo systemctl restart bonus-blockd
```

#### Check service status

```bash
sudo systemctl status bonus-blockd
```

#### Check service logs

```bash
sudo journalctl -u bonus-blockd -f --no-hostname -o cat
```
