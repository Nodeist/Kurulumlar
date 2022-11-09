&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/qtutnf0.png)

# Gitopia Installation Guide
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

## Gitopia Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Gitopia fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O GTP.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Gitopia/Gitopiagt && chmod +x GTP.sh && ./GTP.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
gitopiad status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
gitopiad keys add $GTP_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
gitopiad keys add $GTP_WALLET --recover
```

To get the current wallet list:
```
gitopiad keys list
```

### Save Wallet Information
Add Wallet Address:
```
GTP_WALLET_ADDRESS=$(gitopiad keys show $GTP_WALLET -a)
GTP_VALOPER_ADDRESS=$(gitopiad keys show $GTP_WALLET --bech val -a)
echo 'export GTP_WALLET_ADDRESS='${GTP_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export GTP_VALOPER_ADDRESS='${GTP_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 tlore (1 tlore equals 1000000 utlore) and your node is in sync.

To check your wallet balance:
```
gitopiad query bank balances $GTP_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
gitopiad tx staking create-validator \
  --amount 1000000utlore \
  --from $GTP_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(gitopiad tendermint show-validator) \
  --moniker $GTP_NODENAME \
  --chain-id $GTP_ID \
  --fees 250utlore
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu gitopiad -o cat
```

Start Service:
```
systemctl start gitopiad
```

Stop Service:
```
systemctl stop gitopiad
```

Restart Service:
```
systemctl restart gitopiad
```

### Node Information
Sync Information:
```
gitopiad status 2>&1 | jq .SyncInfo
```

Validator Information:
```
gitopiad status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
gitopiad status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
gitopiad tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
gitopiad keys list
```

Recover wallet using Mnemonic:
```
gitopiad keys add $GTP_WALLET --recover
```

Wallet Delete:
```
gitopiad keys delete $GTP_WALLET
```

Show Wallet Balance:
```
gitopiad query bank balances $GTP_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
gitopiad tx bank send $GTP_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000utlore
```

### Voting
```
gitopiad tx gov vote 1 yes --from $GTP_WALLET --chain-id=$GTP_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
gitopiad tx staking delegate $GTP_VALOPER_ADDRESS 10000000utlore --from=$GTP_WALLET --chain-id=$GTP_ID --gas=auto --fees 250utlore
```

Redelegate from validator to another validator:
```
gitopiad tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utlore --from=$GTP_WALLET --chain-id=$GTP_ID --gas=auto --fees 250utlore
```

Withdraw all rewards:
```
gitopiad tx distribution withdraw-all-rewards --from=$GTP_WALLET --chain-id=$GTP_ID --gas=auto --fees 250utlore
```

Withdraw rewards with commission:
```
gitopiad tx distribution withdraw-rewards $GTP_VALOPER_ADDRESS --from=$GTP_WALLET --commission --chain-id=$GTP_ID
```

### Validator Management
Change Validator Name:
```
gitopiad tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$GTP_ID \
--from=$GTP_WALLET
```

Get Out Of Jail(Unjail):
```
gitopiad tx slashing unjail \
  --broadcast-mode=block \
  --from=$GTP_WALLET \
  --chain-id=$GTP_ID \
  --gas=auto --fees 250utlore
```

To Delete Node Completely:
```
sudo systemctl stop gitopiad
sudo systemctl disable gitopiad
sudo rm /etc/systemd/system/gitopia* -rf
sudo rm $(which gitopiad) -rf
sudo rm $HOME/.gitopia* -rf
sudo rm $HOME/gitopiad -rf
sed -i '/GTP_/d' ~/.bash_profile
```
