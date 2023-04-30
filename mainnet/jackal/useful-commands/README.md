## 🔑 Key management

#### Add new key

```bash
canined keys add wallet
```

#### Recover existing key

```bash
canined keys add wallet --recover
```

#### List all keys

```bash
canined keys list
```

#### Delete key

```bash
canined keys delete wallet
```

#### Export key to the file

```bash
canined keys export wallet
```

#### Import key from the file

```bash
canined keys import wallet wallet.backup
```

#### Query wallet balance

```bash
canined q bank balances $(canined keys show wallet -a)
```

## 👷 Validator management


- Please make sure you have adjusted **moniker**, **identity**, **details** and **website** to match your values.


#### Create new validator

```bash
canined tx staking create-validator \
--amount 1000000ujkl \
--pubkey $(canined tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id jackal-1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025ujkl \
-y
```

#### Edit existing validator

```bash
canined tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id jackal-1 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025ujkl \
-y
```

#### Unjail validator

```bash
canined tx slashing unjail --from wallet --chain-id jackal-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ujkl -y
```

#### Jail reason

```bash
canined query slashing signing-info $(canined tendermint show-validator)
```

#### List all active validators

```bash
canined q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### List all inactive validators

```bash
canined q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### View validator details

```bash
canined q staking validator $(canined keys show wallet --bech val -a)
```

## 💲 Token management

#### Withdraw rewards from all validators

```bash
canined tx distribution withdraw-all-rewards --from wallet --chain-id jackal-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ujkl -y
```

#### Withdraw commission and rewards from your validator

```bash
canined tx distribution withdraw-rewards $(canined keys show wallet --bech val -a) --commission --from wallet --chain-id jackal-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ujkl -y
```

#### Delegate tokens to yourself

```bash
canined tx staking delegate $(canined keys show wallet --bech val -a) 1000000ujkl --from wallet --chain-id jackal-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ujkl -y
```

#### Delegate tokens to validator

```bash
canined tx staking delegate <TO_VALOPER_ADDRESS> 1000000ujkl --from wallet --chain-id jackal-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ujkl -y
```

#### Redelegate tokens to another validator

```bash
canined tx staking redelegate $(canined keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000ujkl --from wallet --chain-id jackal-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ujkl -y
```

#### Unbond tokens from your validator

```bash
canined tx staking unbond $(canined keys show wallet --bech val -a) 1000000ujkl --from wallet --chain-id jackal-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ujkl -y
```

#### Send tokens to the wallet

```bash
canined tx bank send wallet <TO_WALLET_ADDRESS> 1000000ujkl --from wallet --chain-id jackal-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ujkl -y
```

## 🗳 Governance

#### List all proposals

```bash
canined query gov proposals
```

#### View proposal by id

```bash
canined query gov proposal 1
```

#### Vote 'Yes'

```bash
canined tx gov vote 1 yes --from wallet --chain-id jackal-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ujkl -y
```

#### Vote 'No'

```bash
canined tx gov vote 1 no --from wallet --chain-id jackal-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ujkl -y
```

#### Vote 'Abstain'

```bash
canined tx gov vote 1 abstain --from wallet --chain-id jackal-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ujkl -y
```

#### Vote 'NoWithVeto'

```bash
canined tx gov vote 1 NoWithVeto --from wallet --chain-id jackal-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ujkl -y
```

## ⚡️ Utility

#### Update ports

```bash
CUSTOM_PORT=10
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.canine/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.canine/config/app.toml
```

#### Update Indexer

##### Disable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.canine/config/config.toml
```

##### Enable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.canine/config/config.toml
```

#### Update pruning

```bash
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.canine/config/app.toml
```

## 🚨 Maintenance

#### Get validator info

```bash
canined status 2>&1 | jq .ValidatorInfo
```

#### Get sync info

```bash
canined status 2>&1 | jq .SyncInfo
```

#### Get node peer

```bash
echo $(canined tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.canine/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

#### Check if validator key is correct

```bash
[[ $(canined q staking validator $(canined keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(canined status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

#### Get live peers

```bash
curl -sS http://localhost:27657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

#### Set minimum gas price

```bash
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025ujkl\"/" $HOME/.canine/config/app.toml
```

#### Enable prometheus

```bash
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.canine/config/config.toml
```

#### Reset chain data

```bash
canined tendermint unsafe-reset-all --home $HOME/.canine --keep-addr-book
```

#### Remove node

- Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your **priv_validator_key.json**!


```bash
cd $HOME
sudo systemctl stop canined
sudo systemctl disable canined
sudo rm /etc/systemd/system/canined.service
sudo systemctl daemon-reload
rm -f $(which canined)
rm -rf $HOME/.canine
rm -rf $HOME/canine-chain
```

## ⚙️ Service Management

#### Reload service configuration

```bash
sudo systemctl daemon-reload
```

#### Enable service

```bash
sudo systemctl enable canined
```

#### Disable service

```bash
sudo systemctl disable canined
```

#### Start service

```bash
sudo systemctl start canined
```

#### Stop service

```bash
sudo systemctl stop canined
```

#### Restart service

```bash
sudo systemctl restart canined
```

#### Check service status

```bash
sudo systemctl status canined
```

#### Check service logs

```bash
sudo journalctl -u canined -f --no-hostname -o cat
```
