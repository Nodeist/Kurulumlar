## 🔑 Key management

#### Add new key

```bash
timpid keys add wallet
```

#### Recover existing key

```bash
timpid keys add wallet --recover
```

#### List all keys

```bash
timpid keys list
```

#### Delete key

```bash
timpid keys delete wallet
```

#### Export key to the file

```bash
timpid keys export wallet
```

#### Import key from the file

```bash
timpid keys import wallet wallet.backup
```

#### Query wallet balance

```bash
timpid q bank balances $(timpid keys show wallet -a)
```

## 👷 Validator management


- Please make sure you have adjusted **moniker**, **identity**, **details** and **website** to match your values.


#### Create new validator

```bash
timpid tx staking create-validator \
--amount 1000000utimpiTN \
--pubkey $(timpid tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id TimpiChainTN \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025utimpiTN \
-y
```

#### Edit existing validator

```bash
timpid tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id TimpiChainTN \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025utimpiTN \
-y
```

#### Unjail validator

```bash
timpid tx slashing unjail --from wallet --chain-id TimpiChainTN --gas-adjustment 1.4 --gas auto --gas-prices 0.025utimpiTN -y
```

#### Jail reason

```bash
timpid query slashing signing-info $(timpid tendermint show-validator)
```

#### List all active validators

```bash
timpid q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### List all inactive validators

```bash
timpid q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### View validator details

```bash
timpid q staking validator $(timpid keys show wallet --bech val -a)
```

## 💲 Token management

#### Withdraw rewards from all validators

```bash
timpid tx distribution withdraw-all-rewards --from wallet --chain-id TimpiChainTN --gas-adjustment 1.4 --gas auto --gas-prices 0.025utimpiTN -y
```

#### Withdraw commission and rewards from your validator

```bash
timpid tx distribution withdraw-rewards $(timpid keys show wallet --bech val -a) --commission --from wallet --chain-id TimpiChainTN --gas-adjustment 1.4 --gas auto --gas-prices 0.025utimpiTN -y
```

#### Delegate tokens to yourself

```bash
timpid tx staking delegate $(timpid keys show wallet --bech val -a) 1000000utimpiTN --from wallet --chain-id TimpiChainTN --gas-adjustment 1.4 --gas auto --gas-prices 0.025utimpiTN -y
```

#### Delegate tokens to validator

```bash
timpid tx staking delegate <TO_VALOPER_ADDRESS> 1000000utimpiTN --from wallet --chain-id TimpiChainTN --gas-adjustment 1.4 --gas auto --gas-prices 0.025utimpiTN -y
```

#### Redelegate tokens to another validator

```bash
timpid tx staking redelegate $(timpid keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000utimpiTN --from wallet --chain-id TimpiChainTN --gas-adjustment 1.4 --gas auto --gas-prices 0.025utimpiTN -y
```

#### Unbond tokens from your validator

```bash
timpid tx staking unbond $(timpid keys show wallet --bech val -a) 1000000utimpiTN --from wallet --chain-id TimpiChainTN --gas-adjustment 1.4 --gas auto --gas-prices 0.025utimpiTN -y
```

#### Send tokens to the wallet

```bash
timpid tx bank send wallet <TO_WALLET_ADDRESS> 1000000utimpiTN --from wallet --chain-id TimpiChainTN --gas-adjustment 1.4 --gas auto --gas-prices 0.025utimpiTN -y
```

## 🗳 Governance

#### List all proposals

```bash
timpid query gov proposals
```

#### View proposal by id

```bash
timpid query gov proposal 1
```

#### Vote 'Yes'

```bash
timpid tx gov vote 1 yes --from wallet --chain-id TimpiChainTN --gas-adjustment 1.4 --gas auto --gas-prices 0.025utimpiTN -y
```

#### Vote 'No'

```bash
timpid tx gov vote 1 no --from wallet --chain-id TimpiChainTN --gas-adjustment 1.4 --gas auto --gas-prices 0.025utimpiTN -y
```

#### Vote 'Abstain'

```bash
timpid tx gov vote 1 abstain --from wallet --chain-id TimpiChainTN --gas-adjustment 1.4 --gas auto --gas-prices 0.025utimpiTN -y
```

#### Vote 'NoWithVeto'

```bash
timpid tx gov vote 1 NoWithVeto --from wallet --chain-id TimpiChainTN --gas-adjustment 1.4 --gas auto --gas-prices 0.025utimpiTN -y
```

## ⚡️ Utility

#### Update ports

```bash
CUSTOM_PORT=56
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.TimpiChain/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.TimpiChain/config/app.toml
```

#### Update Indexer

##### Disable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.TimpiChain/config/config.toml
```

##### Enable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.TimpiChain/config/config.toml
```

#### Update pruning

```bash
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.TimpiChain/config/app.toml
```

## 🚨 Maintenance

#### Get validator info

```bash
timpid status 2>&1 | jq .ValidatorInfo
```

#### Get sync info

```bash
timpid status 2>&1 | jq .SyncInfo
```

#### Get node peer

```bash
echo $(timpid tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.TimpiChain/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

#### Check if validator key is correct

```bash
[[ $(timpid q staking validator $(timpid keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(timpid status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

#### Set minimum gas price

```bash
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025utimpiTN\"/" $HOME/.TimpiChain/config/app.toml
```

#### Enable prometheus

```bash
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.TimpiChain/config/config.toml
```

#### Reset chain data

```bash
timpid tendermint unsafe-reset-all --home $HOME/.TimpiChain --keep-addr-book
```

#### Remove node

- Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your **priv_validator_key.json**!


```bash
cd $HOME
sudo systemctl stop timpid
sudo systemctl disable timpid
sudo rm /etc/systemd/system/timpid.service
sudo systemctl daemon-reload
rm -f $(which timpid)
rm -rf $HOME/.TimpiChain
rm -rf $HOME/timpi
```

## ⚙️ Service Management

#### Reload service configuration

```bash
sudo systemctl daemon-reload
```

#### Enable service

```bash
sudo systemctl enable timpid
```

#### Disable service

```bash
sudo systemctl disable timpid
```

#### Start service

```bash
sudo systemctl start timpid
```

#### Stop service

```bash
sudo systemctl stop timpid
```

#### Restart service

```bash
sudo systemctl restart timpid
```

#### Check service status

```bash
sudo systemctl status timpid
```

#### Check service logs

```bash
sudo journalctl -u timpid -f --no-hostname -o cat
```
