## 🔑 Key management

#### Add new key

```bash
blockxd keys add wallet
```

#### Recover existing key

```bash
blockxd keys add wallet --recover
```

#### List all keys

```bash
blockxd keys list
```

#### Delete key

```bash
blockxd keys delete wallet
```

#### Export key to the file

```bash
blockxd keys export wallet
```

#### Import key from the file

```bash
blockxd keys import wallet wallet.backup
```

#### Query wallet balance

```bash
blockxd q bank balances $(blockxd keys show wallet -a)
```

## 👷 Validator management


- Please make sure you have adjusted **moniker**, **identity**, **details** and **website** to match your values.


#### Create new validator

```bash
blockxd tx staking create-validator \
--amount 1000000abcx \
--pubkey $(blockxd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id blockx_12345-2 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025abcx \
-y
```

#### Edit existing validator

```bash
blockxd tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id blockx_12345-2 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025abcx \
-y
```

#### Unjail validator

```bash
blockxd tx slashing unjail --from wallet --chain-id blockx_12345-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025abcx -y
```

#### Jail reason

```bash
blockxd query slashing signing-info $(blockxd tendermint show-validator)
```

#### List all active validators

```bash
blockxd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### List all inactive validators

```bash
blockxd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### View validator details

```bash
blockxd q staking validator $(blockxd keys show wallet --bech val -a)
```

## 💲 Token management

#### Withdraw rewards from all validators

```bash
blockxd tx distribution withdraw-all-rewards --from wallet --chain-id blockx_12345-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025abcx -y
```

#### Withdraw commission and rewards from your validator

```bash
blockxd tx distribution withdraw-rewards $(blockxd keys show wallet --bech val -a) --commission --from wallet --chain-id blockx_12345-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025abcx -y
```

#### Delegate tokens to yourself

```bash
blockxd tx staking delegate $(blockxd keys show wallet --bech val -a) 1000000abcx --from wallet --chain-id blockx_12345-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025abcx -y
```

#### Delegate tokens to validator

```bash
blockxd tx staking delegate <TO_VALOPER_ADDRESS> 1000000abcx --from wallet --chain-id blockx_12345-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025abcx -y
```

#### Redelegate tokens to another validator

```bash
blockxd tx staking redelegate $(blockxd keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000abcx --from wallet --chain-id blockx_12345-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025abcx -y
```

#### Unbond tokens from your validator

```bash
blockxd tx staking unbond $(blockxd keys show wallet --bech val -a) 1000000abcx --from wallet --chain-id blockx_12345-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025abcx -y
```

#### Send tokens to the wallet

```bash
blockxd tx bank send wallet <TO_WALLET_ADDRESS> 1000000abcx --from wallet --chain-id blockx_12345-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025abcx -y
```

## 🗳 Governance

#### List all proposals

```bash
blockxd query gov proposals
```

#### View proposal by id

```bash
blockxd query gov proposal 1
```

#### Vote 'Yes'

```bash
blockxd tx gov vote 1 yes --from wallet --chain-id blockx_12345-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025abcx -y
```

#### Vote 'No'

```bash
blockxd tx gov vote 1 no --from wallet --chain-id blockx_12345-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025abcx -y
```

#### Vote 'Abstain'

```bash
blockxd tx gov vote 1 abstain --from wallet --chain-id blockx_12345-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025abcx -y
```

#### Vote 'NoWithVeto'

```bash
blockxd tx gov vote 1 NoWithVeto --from wallet --chain-id blockx_12345-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025abcx -y
```

## ⚡️ Utility

#### Update ports

```bash
CUSTOM_PORT=57
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.blockxd/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.blockxd/config/app.toml
```

#### Update Indexer

##### Disable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.blockxd/config/config.toml
```

##### Enable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.blockxd/config/config.toml
```

#### Update pruning

```bash
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.blockxd/config/app.toml
```

## 🚨 Maintenance

#### Get validator info

```bash
blockxd status 2>&1 | jq .ValidatorInfo
```

#### Get sync info

```bash
blockxd status 2>&1 | jq .SyncInfo
```

#### Get node peer

```bash
echo $(blockxd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.blockxd/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

#### Check if validator key is correct

```bash
[[ $(blockxd q staking validator $(blockxd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(blockxd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

#### Set minimum gas price

```bash
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025abcx\"/" $HOME/.blockxd/config/app.toml
```

#### Enable prometheus

```bash
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.blockxd/config/config.toml
```

#### Reset chain data

```bash
blockxd tendermint unsafe-reset-all --home $HOME/.blockxd --keep-addr-book
```

#### Remove node

- Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your **priv_validator_key.json**!


```bash
cd $HOME
sudo systemctl stop blockxd
sudo systemctl disable blockxd
sudo rm /etc/systemd/system/blockxd.service
sudo systemctl daemon-reload
rm -f $(which blockxd)
rm -rf $HOME/.blockxd
rm -rf $HOME/blockx
```

## ⚙️ Service Management

#### Reload service configuration

```bash
sudo systemctl daemon-reload
```

#### Enable service

```bash
sudo systemctl enable blockxd
```

#### Disable service

```bash
sudo systemctl disable blockxd
```

#### Start service

```bash
sudo systemctl start blockxd
```

#### Stop service

```bash
sudo systemctl stop blockxd
```

#### Restart service

```bash
sudo systemctl restart blockxd
```

#### Check service status

```bash
sudo systemctl status blockxd
```

#### Check service logs

```bash
sudo journalctl -u blockxd -f --no-hostname -o cat
```
