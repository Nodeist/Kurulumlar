## 🔑 Key management

#### Add new key

```bash
banksyd keys add wallet
```

#### Recover existing key

```bash
banksyd keys add wallet --recover
```

#### List all keys

```bash
banksyd keys list
```

#### Delete key

```bash
banksyd keys delete wallet
```

#### Export key to the file

```bash
banksyd keys export wallet
```

#### Import key from the file

```bash
banksyd keys import wallet wallet.backup
```

#### Query wallet balance

```bash
banksyd q bank balances $(banksyd keys show wallet -a)
```

## 👷 Validator management


- Please make sure you have adjusted **moniker**, **identity**, **details** and **website** to match your values.


#### Create new validator

```bash
banksyd tx staking create-validator \
--amount 1000000ubanksy \
--pubkey $(banksyd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id banksy-testnet-1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025ubanksy \
-y
```

#### Edit existing validator

```bash
banksyd tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id banksy-testnet-1 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025ubanksy \
-y
```

#### Unjail validator

```bash
banksyd tx slashing unjail --from wallet --chain-id banksy-testnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubanksy -y
```

#### Jail reason

```bash
banksyd query slashing signing-info $(banksyd tendermint show-validator)
```

#### List all active validators

```bash
banksyd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### List all inactive validators

```bash
banksyd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### View validator details

```bash
banksyd q staking validator $(banksyd keys show wallet --bech val -a)
```

## 💲 Token management

#### Withdraw rewards from all validators

```bash
banksyd tx distribution withdraw-all-rewards --from wallet --chain-id banksy-testnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubanksy -y
```

#### Withdraw commission and rewards from your validator

```bash
banksyd tx distribution withdraw-rewards $(banksyd keys show wallet --bech val -a) --commission --from wallet --chain-id banksy-testnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubanksy -y
```

#### Delegate tokens to yourself

```bash
banksyd tx staking delegate $(banksyd keys show wallet --bech val -a) 1000000ubanksy --from wallet --chain-id banksy-testnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubanksy -y
```

#### Delegate tokens to validator

```bash
banksyd tx staking delegate <TO_VALOPER_ADDRESS> 1000000ubanksy --from wallet --chain-id banksy-testnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubanksy -y
```

#### Redelegate tokens to another validator

```bash
banksyd tx staking redelegate $(banksyd keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000ubanksy --from wallet --chain-id banksy-testnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubanksy -y
```

#### Unbond tokens from your validator

```bash
banksyd tx staking unbond $(banksyd keys show wallet --bech val -a) 1000000ubanksy --from wallet --chain-id banksy-testnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubanksy -y
```

#### Send tokens to the wallet

```bash
banksyd tx bank send wallet <TO_WALLET_ADDRESS> 1000000ubanksy --from wallet --chain-id banksy-testnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubanksy -y
```

## 🗳 Governance

#### List all proposals

```bash
banksyd query gov proposals
```

#### View proposal by id

```bash
banksyd query gov proposal 1
```

#### Vote 'Yes'

```bash
banksyd tx gov vote 1 yes --from wallet --chain-id banksy-testnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubanksy -y
```

#### Vote 'No'

```bash
banksyd tx gov vote 1 no --from wallet --chain-id banksy-testnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubanksy -y
```

#### Vote 'Abstain'

```bash
banksyd tx gov vote 1 abstain --from wallet --chain-id banksy-testnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubanksy -y
```

#### Vote 'NoWithVeto'

```bash
banksyd tx gov vote 1 NoWithVeto --from wallet --chain-id banksy-testnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubanksy -y
```

## ⚡️ Utility

#### Update ports

```bash
CUSTOM_PORT=22
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.banksy/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.banksy/config/app.toml
```

#### Update Indexer

##### Disable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.banksy/config/config.toml
```

##### Enable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.banksy/config/config.toml
```

#### Update pruning

```bash
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.banksy/config/app.toml
```

## 🚨 Maintenance

#### Get validator info

```bash
banksyd status 2>&1 | jq .ValidatorInfo
```

#### Get sync info

```bash
banksyd status 2>&1 | jq .SyncInfo
```

#### Get node peer

```bash
echo $(banksyd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.banksy/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

#### Check if validator key is correct

```bash
[[ $(banksyd q staking validator $(banksyd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(banksyd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

#### Set minimum gas price

```bash
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025ubanksy\"/" $HOME/.banksy/config/app.toml
```

#### Enable prometheus

```bash
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.banksy/config/config.toml
```

#### Reset chain data

```bash
banksyd tendermint unsafe-reset-all --home $HOME/.banksy --keep-addr-book
```

#### Remove node

- Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your **priv_validator_key.json**!


```bash
cd $HOME
sudo systemctl stop banksyd
sudo systemctl disable banksyd
sudo rm /etc/systemd/system/banksyd.service
sudo systemctl daemon-reload
rm -f $(which banksyd)
rm -rf $HOME/.banksy
rm -rf $HOME/composable-testnet
```

## ⚙️ Service Management

#### Reload service configuration

```bash
sudo systemctl daemon-reload
```

#### Enable service

```bash
sudo systemctl enable banksyd
```

#### Disable service

```bash
sudo systemctl disable banksyd
```

#### Start service

```bash
sudo systemctl start banksyd
```

#### Stop service

```bash
sudo systemctl stop banksyd
```

#### Restart service

```bash
sudo systemctl restart banksyd
```

#### Check service status

```bash
sudo systemctl status banksyd
```

#### Check service logs

```bash
sudo journalctl -u banksyd -f --no-hostname -o cat
```
