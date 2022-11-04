&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/odbvf0a.png)

# Loyal Installation Guide
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

## Loyal Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Loyal fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O LYL.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Loyal/LYL && chmod +x LYL.sh && ./LYL.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following comlyl to check the sync status.
```
loyald status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following comlyl to create a new wallet. Do not forget to save the reminder (mnemonic).
```
loyald keys add $LYL_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
loyald keys add $LYL_WALLET --recover
```

To get the current wallet list:
```
loyald keys list
```

### Save Wallet Information
Add Wallet Address:
```
LYL_WALLET_ADDRESS=$(loyald keys show $LYL_WALLET -a)
LYL_VALOPER_ADDRESS=$(loyald keys show $LYL_WALLET --bech val -a)
echo 'export LYL_WALLET_ADDRESS='${LYL_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export LYL_VALOPER_ADDRESS='${LYL_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 lyl (1 lyl equals 1000000 ulyl) and your node is in sync.

To check your wallet balance:
```
loyald query bank balances $LYL_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
loyald tx staking create-validator \
  --amount 10000000ulyl \
  --from $LYL_WALLET \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --pubkey  $(loyald tendermint show-validator) \
  --moniker $LYL_NODENAME \
  --chain-id $LYL_ID
```



## Useful Comlyls
### Service Management
Check Logs:
```
journalctl -fu loyald -o cat
```

Start Service:
```
systemctl start loyald
```

Stop Service:
```
systemctl stop loyald
```

Restart Service:
```
systemctl restart loyald
```

### Node Information
Sync Information:
```
loyald status 2>&1 | jq .SyncInfo
```

Validator Information:
```
loyald status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
loyald status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
loyald tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
loyald keys list
```

Recover wallet using Mnemonic:
```
loyald keys add $LYL_WALLET --recover
```

Wallet Delete:
```
loyald keys delete $LYL_WALLET
```

Show Wallet Balance:
```
loyald query bank balances $LYL_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
loyald tx bank send $LYL_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ulyl
```

### Voting
```
loyald tx gov vote 1 yes --from $LYL_WALLET --chain-id=$LYL_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
loyald tx staking delegate $LYL_VALOPER_ADDRESS 10000000ulyl --from=$LYL_WALLET --chain-id=$LYL_ID --gas=auto --fees 250ulyl
```

Redelegate from validator to another validator:
```
loyald tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ulyl --from=$LYL_WALLET --chain-id=$LYL_ID --gas=auto --fees 250ulyl
```

Withdraw all rewards:
```
loyald tx distribution withdraw-all-rewards --from=$LYL_WALLET --chain-id=$LYL_ID --gas=auto --fees 250ulyl
```

Withdraw rewards with commission:
```
loyald tx distribution withdraw-rewards $LYL_VALOPER_ADDRESS --from=$LYL_WALLET --commission --chain-id=$LYL_ID
```

### Validator Management
Change Validator Name:
```
loyald tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$LYL_ID \
--from=$LYL_WALLET
```

Get Out Of Jail(Unjail):
```
loyald tx slashing unjail \
  --broadcast-mode=block \
  --from=$LYL_WALLET \
  --chain-id=$LYL_ID \
  --gas=auto --fees 250ulyl
```

To Delete Node Completely:
```
sudo systemctl stop loyald
sudo systemctl disable loyald
sudo rm /etc/systemd/system/loyald* -rf
sudo rm $(which loyald) -rf
sudo rm $HOME/.loyal* -rf
sudo rm $HOME/loyal* -rf
sed -i '/LYL_/d' ~/.bash_profile
```
