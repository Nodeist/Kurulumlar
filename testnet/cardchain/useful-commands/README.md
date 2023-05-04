## 🔑 Key management

#### Add new key

```bash
Cardchaind keys add wallet
```

#### Recover existing key

```bash
Cardchaind keys add wallet --recover
```

#### List all keys

```bash
Cardchaind keys list
```

#### Delete key

```bash
Cardchaind keys delete wallet
```

#### Export key to the file

```bash
Cardchaind keys export wallet
```

#### Import key from the file

```bash
Cardchaind keys import wallet wallet.backup
```

#### Query wallet balance

```bash
Cardchaind q bank balances $(Cardchaind keys show wallet -a)
```

## 👷 Validator management


- Please make sure you have adjusted **moniker**, **identity**, **details** and **website** to match your values.


#### Create new validator

```bash
Cardchaind tx staking create-validator \
--amount 1000000ubpf \
--pubkey $(Cardchaind tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id testnet3 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025ubpf \
-y
```

#### Edit existing validator

```bash
Cardchaind tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id testnet3 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025ubpf \
-y
```

#### Unjail validator

```bash
Cardchaind tx slashing unjail --from wallet --chain-id testnet3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubpf -y
```

#### Jail reason

```bash
Cardchaind query slashing signing-info $(Cardchaind tendermint show-validator)
```

#### List all active validators

```bash
Cardchaind q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### List all inactive validators

```bash
Cardchaind q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

#### View validator details

```bash
Cardchaind q staking validator $(Cardchaind keys show wallet --bech val -a)
```

## 💲 Token management

#### Withdraw rewards from all validators

```bash
Cardchaind tx distribution withdraw-all-rewards --from wallet --chain-id testnet3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubpf -y
```

#### Withdraw commission and rewards from your validator

```bash
Cardchaind tx distribution withdraw-rewards $(Cardchaind keys show wallet --bech val -a) --commission --from wallet --chain-id testnet3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubpf -y
```

#### Delegate tokens to yourself

```bash
Cardchaind tx staking delegate $(Cardchaind keys show wallet --bech val -a) 1000000ubpf --from wallet --chain-id testnet3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubpf -y
```

#### Delegate tokens to validator

```bash
Cardchaind tx staking delegate <TO_VALOPER_ADDRESS> 1000000ubpf --from wallet --chain-id testnet3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubpf -y
```

#### Redelegate tokens to another validator

```bash
Cardchaind tx staking redelegate $(Cardchaind keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000ubpf --from wallet --chain-id testnet3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubpf -y
```

#### Unbond tokens from your validator

```bash
Cardchaind tx staking unbond $(Cardchaind keys show wallet --bech val -a) 1000000ubpf --from wallet --chain-id testnet3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubpf -y
```

#### Send tokens to the wallet

```bash
Cardchaind tx bank send wallet <TO_WALLET_ADDRESS> 1000000ubpf --from wallet --chain-id testnet3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubpf -y
```

## 🗳 Governance

#### List all proposals

```bash
Cardchaind query gov proposals
```

#### View proposal by id

```bash
Cardchaind query gov proposal 1
```

#### Vote 'Yes'

```bash
Cardchaind tx gov vote 1 yes --from wallet --chain-id testnet3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubpf -y
```

#### Vote 'No'

```bash
Cardchaind tx gov vote 1 no --from wallet --chain-id testnet3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubpf -y
```

#### Vote 'Abstain'

```bash
Cardchaind tx gov vote 1 abstain --from wallet --chain-id testnet3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubpf -y
```

#### Vote 'NoWithVeto'

```bash
Cardchaind tx gov vote 1 NoWithVeto --from wallet --chain-id testnet3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025ubpf -y
```

## ⚡️ Utility

#### Update ports

```bash
CUSTOM_PORT=60
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.Cardchain/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.Cardchain/config/app.toml
```

#### Update Indexer

##### Disable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.Cardchain/config/config.toml
```

##### Enable indexer

```bash
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.Cardchain/config/config.toml
```

#### Update pruning

```bash
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.Cardchain/config/app.toml
```

## 🚨 Maintenance

#### Get validator info

```bash
Cardchaind status 2>&1 | jq .ValidatorInfo
```

#### Get sync info

```bash
Cardchaind status 2>&1 | jq .SyncInfo
```

#### Get node peer

```bash
echo $(Cardchaind tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.Cardchain/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

#### Check if validator key is correct

```bash
[[ $(Cardchaind q staking validator $(Cardchaind keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(Cardchaind status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

#### Set minimum gas price

```bash
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025ubpf\"/" $HOME/.Cardchain/config/app.toml
```

#### Enable prometheus

```bash
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.Cardchain/config/config.toml
```

#### Reset chain data

```bash
Cardchaind tendermint unsafe-reset-all --home $HOME/.Cardchain --keep-addr-book
```

#### Remove node

- Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your **priv_validator_key.json**!


```bash
cd $HOME
sudo systemctl stop Cardchaind
sudo systemctl disable Cardchaind
sudo rm /etc/systemd/system/Cardchaind.service
sudo systemctl daemon-reload
rm -f $(which Cardchaind)
rm -rf $HOME/.Cardchain
rm -rf $HOME/Cardchain
```

## ⚙️ Service Management

#### Reload service configuration

```bash
sudo systemctl daemon-reload
```

#### Enable service

```bash
sudo systemctl enable Cardchaind
```

#### Disable service

```bash
sudo systemctl disable Cardchaind
```

#### Start service

```bash
sudo systemctl start Cardchaind
```

#### Stop service

```bash
sudo systemctl stop Cardchaind
```

#### Restart service

```bash
sudo systemctl restart Cardchaind
```

#### Check service status

```bash
sudo systemctl status Cardchaind
```

#### Check service logs

```bash
sudo journalctl -u Cardchaind -f --no-hostname -o cat
```
