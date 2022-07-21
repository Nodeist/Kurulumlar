&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/iz7y3vs.png)

# Paloma Installation Guide
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

## Paloma Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Paloma fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O PLM.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Paloma/PLM && chmod +x PLM.sh && ./PLM.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
palomad status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
palomad keys add $PLM_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
palomad keys add $PLM_WALLET --recover
```

To get the current wallet list:
```
palomad keys list
```

### Save Wallet Information
Add Wallet Address:
```
PLM_WALLET_ADDRESS=$(palomad keys show $PLM_WALLET -a)
PLM_VALOPER_ADDRESS=$(palomad keys show $PLM_WALLET --bech val -a)
echo 'export PLM_WALLET_ADDRESS='${PLM_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export PLM_VALOPER_ADDRESS='${PLM_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 grain (1 grain equals 1000000 ugrain) and your node is in sync.

To check your wallet balance:
```
palomad query bank balances $PLM_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
palomad tx staking create-validator \
  --amount 1000000ugrain \
  --from $PLM_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(palomad tendermint show-validator) \
  --moniker $PLM_NODENAME \
  --chain-id $PLM_ID \
  --fees 250ugrain
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu palomad -o cat
```

Start Service:
```
systemctl start palomad
```

Stop Service:
```
systemctl stop palomad
```

Restart Service:
```
systemctl restart palomad
```

### Node Information
Sync Information:
```
palomad status 2>&1 | jq .SyncInfo
```

Validator Information:
```
palomad status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
palomad status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
palomad tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
palomad keys list
```

Recover wallet using Mnemonic:
```
palomad keys add $PLM_WALLET --recover
```

Wallet Delete:
```
palomad keys delete $PLM_WALLET
```

Show Wallet Balance:
```
palomad query bank balances $PLM_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
palomad tx bank send $PLM_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ugrain
```

### Voting
```
palomad tx gov vote 1 yes --from $PLM_WALLET --chain-id=$PLM_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
palomad tx staking delegate $PLM_VALOPER_ADDRESS 10000000ugrain --from=$PLM_WALLET --chain-id=$PLM_ID --gas=auto --fees 250ugrain
```

Redelegate from validator to another validator:
```
palomad tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ugrain --from=$PLM_WALLET --chain-id=$PLM_ID --gas=auto --fees 250ugrain
```

Withdraw all rewards:
```
palomad tx distribution withdraw-all-rewards --from=$PLM_WALLET --chain-id=$PLM_ID --gas=auto --fees 250ugrain
```

Withdraw rewards with commission:
```
palomad tx distribution withdraw-rewards $PLM_VALOPER_ADDRESS --from=$PLM_WALLET --commission --chain-id=$PLM_ID
```

### Validator Management
Change Validator Name:
```
palomad tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$PLM_ID \
--from=$PLM_WALLET
```

Get Out Of Jail(Unjail): 
```
palomad tx slashing unjail \
  --broadcast-mode=block \
  --from=$PLM_WALLET \
  --chain-id=$PLM_ID \
  --gas=auto --fees 250ugrain
```

To Delete Node Completely:
```
sudo systemctl stop palomad
sudo systemctl disable palomad
sudo rm /etc/systemd/system/paloma* -rf
sudo rm $(which palomad) -rf
sudo rm $HOME/.paloma* -rf
sudo rm $HOME/paloma -rf
sed -i '/PLM_/d' ~/.bash_profile
```
