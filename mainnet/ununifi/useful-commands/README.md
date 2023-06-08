## 🔑 Key management

#### Add new key

```bash
ununifid keys add wallet
```

#### Recover existing key

```bash
ununifid keys add wallet --recover
```

#### List all keys

```bash
ununifid keys list
```

#### Delete key

```bash
ununifid keys delete wallet
```

#### Export key to the file

```bash
ununifid keys export wallet
```

#### Import key from the file

```bash
ununifid keys import wallet wallet.backup
```

#### Query wallet balance

```bash
ununifid q bank balances $(ununifid keys show wallet -a)
```

## 👷 Validator management


- Please make sure you have adjusted **moniker**, **identity**, **details** and **website** to match your values.


#### Create new validator

```bash
ununifid tx staking create-validator \
--amount 1000000uguu \
--pubkey $(ununifid tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id ununifi-beta-v1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025uguu \
-y
```

#### Edit existing validator

```bash
ununifid tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id ununifi-beta-v1 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025uguu \
-y
```

#### Unjail validator

```bash
ununifid tx slashing unjail --from wallet --chain-id ununifi-beta-v1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uguu -y
```

#### Jail reason

```bash
ununifid query slashing signing-info $(ununifid tendermint show-validator)
```

#### List all active validators

```bash
ununifid q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### List all inactive validators

```bash
ununifid q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### View validator details

```bash
ununifid q staking validator $(ununifid keys show wallet --bech val -a)
```

## 💲 Token management

#### Withdraw rewards from all validators

```bash
ununifid tx distribution withdraw-all-rewards --from wallet --chain-id ununifi-beta-v1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uguu -y
```

#### Withdraw commission and rewards from your validator

```bash
ununifid tx distribution withdraw-rewards $(ununifid keys show wallet --bech val -a) --commission --from wallet --chain-id ununifi-beta-v1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uguu -y
```

#### Delegate tokens to yourself

```bash
ununifid tx staking delegate $(ununifid keys show wallet --bech val -a) 1000000uguu --from wallet --chain-id ununifi-beta-v1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uguu -y
```

#### Delegate tokens to validator

```bash
ununifid tx staking delegate <TO_VALOPER_ADDRESS> 1000000uguu --from wallet --chain-id ununifi-beta-v1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uguu -y
```

#### Redelegate tokens to another validator

```bash
ununifid tx staking redelegate $(ununifid keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000uguu --from wallet --chain-id ununifi-beta-v1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uguu -y
```

#### Unbond tokens from your validator

```bash
ununifid tx staking unbond $(ununifid keys show wallet --bech val -a) 1000000uguu --from wallet --chain-id ununifi-beta-v1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uguu -y
```

#### Send tokens to the wallet

```bash
ununifid tx bank send wallet <TO_WALLET_ADDRESS> 1000000uguu --from wallet --chain-id ununifi-beta-v1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uguu -y
```

## 🗳 Governance

#### List all proposals

```bash
ununifid query gov proposals
```

#### View proposal by id

```bash
ununifid query gov proposal 1
```

#### Vote 'Yes'

```bash
ununifid tx gov vote 1 yes --from wallet --chain-id ununifi-beta-v1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uguu -y
```

#### Vote 'No'

```bash
ununifid tx gov vote 1 no --from wallet --chain-id ununifi-beta-v1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uguu -y
```

#### Vote 'Abstain'

```bash
ununifid tx gov vote 1 abstain --from wallet --chain-id ununifi-beta-v1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uguu -y
```

#### Vote 'NoWithVeto'

```bash
ununifid tx gov vote 1 NoWithVeto --from wallet --chain-id ununifi-beta-v1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025uguu -y
```

## ⚡️ Utility

#### Update ports

```bash
CUSTOM_PORT=15
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.ununifi/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.ununifi/config/app.toml
```

#### Update Indexer

##### Disable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.ununifi/config/config.toml
```

##### Enable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.ununifi/config/config.toml
```

#### Update pruning

```bash
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.ununifi/config/app.toml
```

## 🚨 Maintenance

#### Get validator info

```bash
ununifid status 2>&1 | jq .ValidatorInfo
```

#### Get sync info

```bash
ununifid status 2>&1 | jq .SyncInfo
```

#### Get node peer

```bash
echo $(ununifid tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.ununifi/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

#### Check if validator key is correct

```bash
[[ $(ununifid q staking validator $(ununifid keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(ununifid status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

#### Get live peers

```bash
curl -sS http://localhost:27657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

#### Set minimum gas price

```bash
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025uguu\"/" $HOME/.ununifi/config/app.toml
```

#### Enable prometheus

```bash
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.ununifi/config/config.toml
```

#### Reset chain data

```bash
ununifid tendermint unsafe-reset-all --home $HOME/.ununifi --keep-addr-book
```

#### Remove node

- Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your **priv_validator_key.json**!


```bash
cd $HOME
sudo systemctl stop ununifid
sudo systemctl disable ununifid
sudo rm /etc/systemd/system/ununifid.service
sudo systemctl daemon-reload
rm -f $(which ununifid)
rm -rf $HOME/.ununifi
rm -rf $HOME/ununifi-core
```

## ⚙️ Service Management

#### Reload service configuration

```bash
sudo systemctl daemon-reload
```

#### Enable service

```bash
sudo systemctl enable ununifid
```

#### Disable service

```bash
sudo systemctl disable ununifid
```

#### Start service

```bash
sudo systemctl start ununifid
```

#### Stop service

```bash
sudo systemctl stop ununifid
```

#### Restart service

```bash
sudo systemctl restart ununifid
```

#### Check service status

```bash
sudo systemctl status ununifid
```

#### Check service logs

```bash
sudo journalctl -u ununifid -f --no-hostname -o cat
```
