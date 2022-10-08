&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/nag1291.png)

# Androma Installation Guide
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

## Androma Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Androma fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O AM.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Andromeda/AM && chmod +x AM.sh && ./AM.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
andromad status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
andromad keys add $AM_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
andromad keys add $AM_WALLET --recover
```

To get the current wallet list:
```
andromad keys list
```

### Save Wallet Information
Add Wallet Address:
```
AM_WALLET_ADDRESS=$(andromad keys show $AM_WALLET -a)
AM_VALOPER_ADDRESS=$(andromad keys show $AM_WALLET --bech val -a)
echo 'export AM_WALLET_ADDRESS='${AM_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export AM_VALOPER_ADDRESS='${AM_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 andr (1 andr equals 1000000 uandr) and your node is in sync.

To check your wallet balance:
```
andromad query bank balances $AM_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
andromad tx staking create-validator \
  --amount 1000000uandr \
  --from $AM_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(andromad tendermint show-validator) \
  --moniker $AM_NODENAME \
  --chain-id $AM_ID \
  --fees 250uandr
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu andromad -o cat
```

Start Service:
```
systemctl start andromad
```

Stop Service:
```
systemctl stop andromad
```

Restart Service:
```
systemctl restart andromad
```

### Node Information
Sync Information:
```
andromad status 2>&1 | jq .SyncInfo
```

Validator Information:
```
andromad status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
andromad status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
andromad tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
andromad keys list
```

Recover wallet using Mnemonic:
```
andromad keys add $AM_WALLET --recover
```

Wallet Delete:
```
andromad keys delete $AM_WALLET
```

Show Wallet Balance:
```
andromad query bank balances $AM_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
andromad tx bank send $AM_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uandr
```

### Voting
```
andromad tx gov vote 1 yes --from $AM_WALLET --chain-id=$AM_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
andromad tx staking delegate $AM_VALOPER_ADDRESS 10000000uandr --from=$AM_WALLET --chain-id=$AM_ID --gas=auto --fees 250uandr
```

Redelegate from validator to another validator:
```
andromad tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uandr --from=$AM_WALLET --chain-id=$AM_ID --gas=auto --fees 250uandr
```

Withdraw all rewards:
```
andromad tx distribution withdraw-all-rewards --from=$AM_WALLET --chain-id=$AM_ID --gas=auto --fees 250uandr
```

Withdraw rewards with commission:
```
andromad tx distribution withdraw-rewards $AM_VALOPER_ADDRESS --from=$AM_WALLET --commission --chain-id=$AM_ID
```

### Validator Management
Change Validator Name:
```
andromad tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$AM_ID \
--from=$AM_WALLET
```

Get Out Of Jail(Unjail):
```
andromad tx slashing unjail \
  --broadcast-mode=block \
  --from=$AM_WALLET \
  --chain-id=$AM_ID \
  --gas=auto --fees 250uandr
```

To Delete Node Completely:
```
sudo systemctl stop andromad
sudo systemctl disable andromad
sudo rm /etc/systemd/system/androma* -rf
sudo rm $(which andromad) -rf
sudo rm $HOME/.androma* -rf
sudo rm $HOME/testnet -rf
sed -i '/AM_/d' ~/.bash_profile
```
