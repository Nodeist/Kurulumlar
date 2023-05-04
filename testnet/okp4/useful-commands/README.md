## 🔑 Key management

#### Add new key

```bash
okp4d keys add wallet
```

#### Recover existing key

```bash
okp4d keys add wallet --recover
```

#### List all keys

```bash
okp4d keys list
```

#### Delete key

```bash
okp4d keys delete wallet
```

#### Export key to the file

```bash
okp4d keys export wallet
```

#### Import key from the file

```bash
okp4d keys import wallet wallet.backup
```

#### Query wallet balance

```bash
okp4d q bank balances $(okp4d keys show wallet -a)
```

## 👷 Validator management


- Please make sure you have adjusted **moniker**, **identity**, **details** and **website** to match your values.


#### Create new validator

```bash
okp4d tx staking create-validator \
--amount 1000000uknow \
--pubkey $(okp4d tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id okp4-nemeton-1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025uknow \
-y
```

#### Edit existing validator

```bash
okp4d tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id okp4-nemeton-1 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025uknow \
-y
```

#### Unjail validator

```bash
okp4d tx slashing unjail --from wallet --chain-id okp4-nemeton-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uknow -y
```

#### Jail reason

```bash
okp4d query slashing signing-info $(okp4d tendermint show-validator)
```

#### List all active validators

```bash
okp4d q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### List all inactive validators

```bash
okp4d q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### View validator details

```bash
okp4d q staking validator $(okp4d keys show wallet --bech val -a)
```

## 💲 Token management

#### Withdraw rewards from all validators

```bash
okp4d tx distribution withdraw-all-rewards --from wallet --chain-id okp4-nemeton-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uknow -y
```

#### Withdraw commission and rewards from your validator

```bash
okp4d tx distribution withdraw-rewards $(okp4d keys show wallet --bech val -a) --commission --from wallet --chain-id okp4-nemeton-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uknow -y
```

#### Delegate tokens to yourself

```bash
okp4d tx staking delegate $(okp4d keys show wallet --bech val -a) 1000000uknow --from wallet --chain-id okp4-nemeton-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uknow -y
```

#### Delegate tokens to validator

```bash
okp4d tx staking delegate <TO_VALOPER_ADDRESS> 1000000uknow --from wallet --chain-id okp4-nemeton-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uknow -y
```

#### Redelegate tokens to another validator

```bash
okp4d tx staking redelegate $(okp4d keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000uknow --from wallet --chain-id okp4-nemeton-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uknow -y
```

#### Unbond tokens from your validator

```bash
okp4d tx staking unbond $(okp4d keys show wallet --bech val -a) 1000000uknow --from wallet --chain-id okp4-nemeton-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uknow -y
```

#### Send tokens to the wallet

```bash
okp4d tx bank send wallet <TO_WALLET_ADDRESS> 1000000uknow --from wallet --chain-id okp4-nemeton-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uknow -y
```

## 🗳 Governance

#### List all proposals

```bash
okp4d query gov proposals
```

#### View proposal by id

```bash
okp4d query gov proposal 1
```

#### Vote 'Yes'

```bash
okp4d tx gov vote 1 yes --from wallet --chain-id okp4-nemeton-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uknow -y
```

#### Vote 'No'

```bash
okp4d tx gov vote 1 no --from wallet --chain-id okp4-nemeton-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uknow -y
```

#### Vote 'Abstain'

```bash
okp4d tx gov vote 1 abstain --from wallet --chain-id okp4-nemeton-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uknow -y
```

#### Vote 'NoWithVeto'

```bash
okp4d tx gov vote 1 NoWithVeto --from wallet --chain-id okp4-nemeton-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uknow -y
```

## ⚡️ Utility

#### Update ports

```bash
CUSTOM_PORT=67
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.okp4d/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.okp4d/config/app.toml
```

#### Update Indexer

##### Disable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.okp4d/config/config.toml
```

##### Enable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.okp4d/config/config.toml
```

#### Update pruning

```bash
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.okp4d/config/app.toml
```

## 🚨 Maintenance

#### Get validator info

```bash
okp4d status 2>&1 | jq .ValidatorInfo
```

#### Get sync info

```bash
okp4d status 2>&1 | jq .SyncInfo
```

#### Get node peer

```bash
echo $(okp4d tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.okp4d/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

#### Check if validator key is correct

```bash
[[ $(okp4d q staking validator $(okp4d keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(okp4d status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

#### Set minimum gas price

```bash
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025uknow\"/" $HOME/.okp4d/config/app.toml
```

#### Enable prometheus

```bash
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.okp4d/config/config.toml
```

#### Reset chain data

```bash
okp4d tendermint unsafe-reset-all --home $HOME/.okp4d --keep-addr-book
```

#### Remove node

- Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your **priv_validator_key.json**!


```bash
cd $HOME
sudo systemctl stop okp4d
sudo systemctl disable okp4d
sudo rm /etc/systemd/system/okp4d.service
sudo systemctl daemon-reload
rm -f $(which okp4d)
rm -rf $HOME/.okp4d
rm -rf $HOME/okp4
```

## ⚙️ Service Management

#### Reload service configuration

```bash
sudo systemctl daemon-reload
```

#### Enable service

```bash
sudo systemctl enable okp4d
```

#### Disable service

```bash
sudo systemctl disable okp4d
```

#### Start service

```bash
sudo systemctl start okp4d
```

#### Stop service

```bash
sudo systemctl stop okp4d
```

#### Restart service

```bash
sudo systemctl restart okp4d
```

#### Check service status

```bash
sudo systemctl status okp4d
```

#### Check service logs

```bash
sudo journalctl -u okp4d -f --no-hostname -o cat
```
