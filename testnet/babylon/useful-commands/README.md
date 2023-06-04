## 🔑 Key management

#### Add new key

```bash
babylond keys add wallet
```

#### Recover existing key

```bash
babylond keys add wallet --recover
```

#### List all keys

```bash
babylond keys list
```

#### Delete key

```bash
babylond keys delete wallet
```

#### Export key to the file

```bash
babylond keys export wallet
```

#### Import key from the file

```bash
babylond keys import wallet wallet.backup
```

#### Query wallet balance

```bash
babylond q bank balances $(babylond keys show wallet -a)
```

## 👷 Validator management


- Please make sure you have adjusted **moniker**, **identity**, **details** and **website** to match your values.

#### Create a BLS key

```bash
babylond create-bls-key WALLET_ADDRESS
```

#### Create new validator

```bash
babylond tx checkpointing create-validator \
--amount 1000000ubbn \
--pubkey $(babylond tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id bbn-test1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025ubbn \
-y
```

#### Edit existing validator

```bash
babylond tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id bbn-test1 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025ubbn \
-y
```

#### Unjail validator

```bash
babylond tx slashing unjail --from wallet --chain-id bbn-test1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubbn -y
```

#### Jail reason

```bash
babylond query slashing signing-info $(babylond tendermint show-validator)
```

#### List all active validators

```bash
babylond q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### List all inactive validators

```bash
babylond q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### View validator details

```bash
babylond q staking validator $(babylond keys show wallet --bech val -a)
```

## 💲 Token management

#### Withdraw rewards from all validators

```bash
babylond tx distribution withdraw-all-rewards --from wallet --chain-id bbn-test1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubbn -y
```

#### Withdraw commission and rewards from your validator

```bash
babylond tx distribution withdraw-rewards $(babylond keys show wallet --bech val -a) --commission --from wallet --chain-id bbn-test1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubbn -y
```

#### Delegate tokens to yourself

```bash
babylond tx staking delegate $(babylond keys show wallet --bech val -a) 1000000ubbn --from wallet --chain-id bbn-test1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubbn -y
```

#### Delegate tokens to validator

```bash
babylond tx staking delegate <TO_VALOPER_ADDRESS> 1000000ubbn --from wallet --chain-id bbn-test1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubbn -y
```

#### Redelegate tokens to another validator

```bash
babylond tx staking redelegate $(babylond keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000ubbn --from wallet --chain-id bbn-test1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubbn -y
```

#### Unbond tokens from your validator

```bash
babylond tx staking unbond $(babylond keys show wallet --bech val -a) 1000000ubbn --from wallet --chain-id bbn-test1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubbn -y
```

#### Send tokens to the wallet

```bash
babylond tx bank send wallet <TO_WALLET_ADDRESS> 1000000ubbn --from wallet --chain-id bbn-test1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubbn -y
```

## 🗳 Governance

#### List all proposals

```bash
babylond query gov proposals
```

#### View proposal by id

```bash
babylond query gov proposal 1
```

#### Vote 'Yes'

```bash
babylond tx gov vote 1 yes --from wallet --chain-id bbn-test1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubbn -y
```

#### Vote 'No'

```bash
babylond tx gov vote 1 no --from wallet --chain-id bbn-test1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubbn -y
```

#### Vote 'Abstain'

```bash
babylond tx gov vote 1 abstain --from wallet --chain-id bbn-test1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubbn -y
```

#### Vote 'NoWithVeto'

```bash
babylond tx gov vote 1 NoWithVeto --from wallet --chain-id bbn-test1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubbn -y
```

## ⚡️ Utility

#### Update ports

```bash
CUSTOM_PORT=53
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.babylond/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.babylond/config/app.toml
```

#### Update Indexer

##### Disable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.babylond/config/config.toml
```

##### Enable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.babylond/config/config.toml
```

#### Update pruning

```bash
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.babylond/config/app.toml
```

## 🚨 Maintenance

#### Get validator info

```bash
babylond status 2>&1 | jq .ValidatorInfo
```

#### Get sync info

```bash
babylond status 2>&1 | jq .SyncInfo
```

#### Get node peer

```bash
echo $(babylond tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.babylond/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

#### Check if validator key is correct

```bash
[[ $(babylond q staking validator $(babylond keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(babylond status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

#### Set minimum gas price

```bash
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025ubbn\"/" $HOME/.babylond/config/app.toml
```

#### Enable prometheus

```bash
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.babylond/config/config.toml
```

#### Reset chain data

```bash
babylond tendermint unsafe-reset-all --home $HOME/.babylond --keep-addr-book
```

#### Remove node

- Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your **priv_validator_key.json**!


```bash
cd $HOME
sudo systemctl stop babylond
sudo systemctl disable babylond
sudo rm /etc/systemd/system/babylond.service
sudo systemctl daemon-reload
rm -f $(which babylond)
rm -rf $HOME/.babylond
rm -rf $HOME/babylon
```

## ⚙️ Service Management

#### Reload service configuration

```bash
sudo systemctl daemon-reload
```

#### Enable service

```bash
sudo systemctl enable babylond
```

#### Disable service

```bash
sudo systemctl disable babylond
```

#### Start service

```bash
sudo systemctl start babylond
```

#### Stop service

```bash
sudo systemctl stop babylond
```

#### Restart service

```bash
sudo systemctl restart babylond
```

#### Check service status

```bash
sudo systemctl status babylond
```

#### Check service logs

```bash
sudo journalctl -u babylond -f --no-hostname -o cat
```
