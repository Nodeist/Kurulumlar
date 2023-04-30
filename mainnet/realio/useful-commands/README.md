## 🔑 Key management

#### Add new key

```bash
realio-networkd keys add wallet
```

#### Recover existing key

```bash
realio-networkd keys add wallet --recover
```

#### List all keys

```bash
realio-networkd keys list
```

#### Delete key

```bash
realio-networkd keys delete wallet
```

#### Export key to the file

```bash
realio-networkd keys export wallet
```

#### Import key from the file

```bash
realio-networkd keys import wallet wallet.backup
```

#### Query wallet balance

```bash
realio-networkd q bank balances $(realio-networkd keys show wallet -a)
```

## 👷 Validator management


- Please make sure you have adjusted **moniker**, **identity**, **details** and **website** to match your values.


#### Create new validator

```bash
realio-networkd tx staking create-validator \
--amount 1000000ario \
--pubkey $(realio-networkd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id realionetwork_3300-1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025ario \
-y
```

#### Edit existing validator

```bash
realio-networkd tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id realionetwork_3300-1 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025ario \
-y
```

#### Unjail validator

```bash
realio-networkd tx slashing unjail --from wallet --chain-id realionetwork_3300-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ario -y
```

#### Jail reason

```bash
realio-networkd query slashing signing-info $(realio-networkd tendermint show-validator)
```

#### List all active validators

```bash
realio-networkd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### List all inactive validators

```bash
realio-networkd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### View validator details

```bash
realio-networkd q staking validator $(realio-networkd keys show wallet --bech val -a)
```

## 💲 Token management

#### Withdraw rewards from all validators

```bash
realio-networkd tx distribution withdraw-all-rewards --from wallet --chain-id realionetwork_3300-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ario -y
```

#### Withdraw commission and rewards from your validator

```bash
realio-networkd tx distribution withdraw-rewards $(realio-networkd keys show wallet --bech val -a) --commission --from wallet --chain-id realionetwork_3300-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ario -y
```

#### Delegate tokens to yourself

```bash
realio-networkd tx staking delegate $(realio-networkd keys show wallet --bech val -a) 1000000ario --from wallet --chain-id realionetwork_3300-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ario -y
```

#### Delegate tokens to validator

```bash
realio-networkd tx staking delegate <TO_VALOPER_ADDRESS> 1000000ario --from wallet --chain-id realionetwork_3300-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ario -y
```

#### Redelegate tokens to another validator

```bash
realio-networkd tx staking redelegate $(realio-networkd keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000ario --from wallet --chain-id realionetwork_3300-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ario -y
```

#### Unbond tokens from your validator

```bash
realio-networkd tx staking unbond $(realio-networkd keys show wallet --bech val -a) 1000000ario --from wallet --chain-id realionetwork_3300-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ario -y
```

#### Send tokens to the wallet

```bash
realio-networkd tx bank send wallet <TO_WALLET_ADDRESS> 1000000ario --from wallet --chain-id realionetwork_3300-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ario -y
```

## 🗳 Governance

#### List all proposals

```bash
realio-networkd query gov proposals
```

#### View proposal by id

```bash
realio-networkd query gov proposal 1
```

#### Vote 'Yes'

```bash
realio-networkd tx gov vote 1 yes --from wallet --chain-id realionetwork_3300-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ario -y
```

#### Vote 'No'

```bash
realio-networkd tx gov vote 1 no --from wallet --chain-id realionetwork_3300-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ario -y
```

#### Vote 'Abstain'

```bash
realio-networkd tx gov vote 1 abstain --from wallet --chain-id realionetwork_3300-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ario -y
```

#### Vote 'NoWithVeto'

```bash
realio-networkd tx gov vote 1 NoWithVeto --from wallet --chain-id realionetwork_3300-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ario -y
```

## ⚡️ Utility

#### Update ports

```bash
CUSTOM_PORT=12
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.realio-network/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.realio-network/config/app.toml
```

#### Update Indexer

##### Disable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.realio-network/config/config.toml
```

##### Enable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.realio-network/config/config.toml
```

#### Update pruning

```bash
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.realio-network/config/app.toml
```

## 🚨 Maintenance

#### Get validator info

```bash
realio-networkd status 2>&1 | jq .ValidatorInfo
```

#### Get sync info

```bash
realio-networkd status 2>&1 | jq .SyncInfo
```

#### Get node peer

```bash
echo $(realio-networkd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.realio-network/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

#### Check if validator key is correct

```bash
[[ $(realio-networkd q staking validator $(realio-networkd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(realio-networkd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

#### Get live peers

```bash
curl -sS http://localhost:27657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

#### Set minimum gas price

```bash
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025ario\"/" $HOME/.realio-network/config/app.toml
```

#### Enable prometheus

```bash
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.realio-network/config/config.toml
```

#### Reset chain data

```bash
realio-networkd tendermint unsafe-reset-all --home $HOME/.realio-network --keep-addr-book
```

#### Remove node

- Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your **priv_validator_key.json**!


```bash
cd $HOME
sudo systemctl stop realio-networkd
sudo systemctl disable realio-networkd
sudo rm /etc/systemd/system/realio-networkd.service
sudo systemctl daemon-reload
rm -f $(which realio-networkd)
rm -rf $HOME/.realio-network
rm -rf $HOME/realio-network
```

## ⚙️ Service Management

#### Reload service configuration

```bash
sudo systemctl daemon-reload
```

#### Enable service

```bash
sudo systemctl enable realio-networkd
```

#### Disable service

```bash
sudo systemctl disable realio-networkd
```

#### Start service

```bash
sudo systemctl start realio-networkd
```

#### Stop service

```bash
sudo systemctl stop realio-networkd
```

#### Restart service

```bash
sudo systemctl restart realio-networkd
```

#### Check service status

```bash
sudo systemctl status realio-networkd
```

#### Check service logs

```bash
sudo journalctl -u realio-networkd -f --no-hostname -o cat
```
