&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/cn8tdch.png)

# Rebus Installation Guide
## Hardware Requirements
Like any Cosmos-SDK chain, the hardware requirements are pretty modest.

### Minimum Hardware Requirements
  - 3x CPU; the higher the clock speed the better
  - 4GB of RAM
  - 80GB Disk
  - Persistent Internet connection (traffic will be minimum 10Mbps during testnet - at least 100Mbps expected for production)

### Recommended Hardware Requirements
  - 4x CPU; the higher the clock speed the better
  - 8GB of RAM
  - 200 GB storage (SSD or NVME)
  - Persistent Internet connection (traffic will be minimum 10Mbps during testnet - at least 100Mbps expected for production)

## Rebus Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Rebus fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O RBS.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Rebus/RBS && chmod +x RBS.sh && ./RBS.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
rebusd status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
rebusd keys add $RBS_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
rebusd keys add $RBS_WALLET --recover
```

To get the current wallet list:
```
rebusd keys list
```

### Save Wallet Information
Add Wallet Address:
```
RBS_WALLET_ADDRESS=$(rebusd keys show $RBS_WALLET -a)
RBS_VALOPER_ADDRESS=$(rebusd keys show $RBS_WALLET --bech val -a)
echo 'export RBS_WALLET_ADDRESS='${RBS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export RBS_VALOPER_ADDRESS='${RBS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 rebus (1 rebus equals 1000000 arebus) and your node is in sync.
Before creating a validator please make sure you have at least 1 rebus (1 rebus equals 1000000 arebus) and your node is in sync.

To check your wallet balance:
```
rebusd query bank balances $RBS_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
rebusd tx staking create-validator \
  --amount 1000000arebus \
  --from $RBS_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(rebusd tendermint show-validator) \
  --moniker $RBS_NODENAME \
  --chain-id $RBS_ID \
  --fees 250arebus
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu rebusd -o cat
```

Start Service:
```
systemctl start rebusd
```

Stop Service:
```
systemctl stop rebusd
```

Restart Service:
```
systemctl restart rebusd
```

### Node Information
Sync Information:
```
rebusd status 2>&1 | jq .SyncInfo
```

Validator Information:
```
rebusd status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
rebusd status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
rebusd tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
rebusd keys list
```

Recover wallet using Mnemonic:
```
rebusd keys add $RBS_WALLET --recover
```

Wallet Delete:
```
rebusd keys delete $RBS_WALLET
```

Show Wallet Balance:
```
rebusd query bank balances $RBS_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
rebusd tx bank send $RBS_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000arebus
```

### Voting
```
rebusd tx gov vote 1 yes --from $RBS_WALLET --chain-id=$RBS_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
rebusd tx staking delegate $RBS_VALOPER_ADDRESS 10000000arebus --from=$RBS_WALLET --chain-id=$RBS_ID --gas=auto --fees 250arebus
```

Redelegate from validator to another validator:
```
rebusd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000arebus --from=$RBS_WALLET --chain-id=$RBS_ID --gas=auto --fees 250arebus
```

Withdraw all rewards:
```
rebusd tx distribution withdraw-all-rewards --from=$RBS_WALLET --chain-id=$RBS_ID --gas=auto --fees 250arebus
```

Withdraw rewards with commission:
```
rebusd tx distribution withdraw-rewards $RBS_VALOPER_ADDRESS --from=$RBS_WALLET --commission --chain-id=$RBS_ID
```

### Validator Management
Change Validator Name:
```
rebusd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$RBS_ID \
--from=$RBS_WALLET
```

Get Out Of Jail(Unjail): 
```
rebusd tx slashing unjail \
  --broadcast-mode=block \
  --from=$RBS_WALLET \
  --chain-id=$RBS_ID \
  --gas=auto --fees 250arebus
```

To Delete Node Completely:
```
sudo systemctl stop rebusd
sudo systemctl disable rebusd
sudo rm /etc/systemd/system/rebusd* -rf
sudo rm $(which rebusd) -rf
sudo rm $HOME/.rebusd* -rf
sudo rm $HOME/rebus.core -rf
sed -i '/RBS_/d' ~/.bash_profile
```
