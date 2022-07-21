&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/k29umk7.png)


# Quicksilver Installation Guide
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

## Quicksilver Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Quicksilver fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O QCK.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Z-Bitenler/Quicksilver/QCK && chmod +x QCK.sh && ./QCK.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
quicksilverd status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
quicksilverd keys add $QCK_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
quicksilverd keys add $QCK_WALLET --recover
```

To get the current wallet list:
```
quicksilverd keys list
```

### Save Wallet Information
Add Wallet Address:
```
QCK_WALLET_ADDRESS=$(quicksilverd keys show $QCK_WALLET -a)
QCK_VALOPER_ADDRESS=$(quicksilverd keys show $QCK_WALLET --bech val -a)
echo 'export QCK_WALLET_ADDRESS='${QCK_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export QCK_VALOPER_ADDRESS='${QCK_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 qck (1 qck equals 1000000 uqck) and your node is in sync.

To check your wallet balance:
```
quicksilverd query bank balances $QCK_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
quicksilverd tx staking create-validator \
  --amount 1000000uqck \
  --from $QCK_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(quicksilverd tendermint show-validator) \
  --moniker $QCK_NODENAME \
  --chain-id $QCK_ID \
  --fees 250uqck
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu quicksilverd -o cat
```

Start Service:
```
systemctl start quicksilverd
```

Stop Service:
```
systemctl stop quicksilverd
```

Restart Service:
```
systemctl restart quicksilverd
```

### Node Information
Sync Information:
```
quicksilverd status 2>&1 | jq .SyncInfo
```

Validator Information:
```
quicksilverd status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
quicksilverd status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
quicksilverd tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
quicksilverd keys list
```

Recover wallet using Mnemonic:
```
quicksilverd keys add $QCK_WALLET --recover
```

Wallet Delete:
```
quicksilverd keys delete $QCK_WALLET
```

Show Wallet Balance:
```
quicksilverd query bank balances $QCK_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
quicksilverd tx bank send $QCK_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uqck
```

### Voting
```
quicksilverd tx gov vote 1 yes --from $QCK_WALLET --chain-id=$QCK_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
quicksilverd tx staking delegate $QCK_VALOPER_ADDRESS 10000000uqck --from=$QCK_WALLET --chain-id=$QCK_ID --gas=auto --fees 250uqck
```

Redelegate from validator to another validator:
```
quicksilverd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uqck --from=$QCK_WALLET --chain-id=$QCK_ID --gas=auto --fees 250uqck
```

Withdraw all rewards:
```
quicksilverd tx distribution withdraw-all-rewards --from=$QCK_WALLET --chain-id=$QCK_ID --gas=auto --fees 250uqck
```

Withdraw rewards with commission:
```
quicksilverd tx distribution withdraw-rewards $QCK_VALOPER_ADDRESS --from=$QCK_WALLET --commission --chain-id=$QCK_ID
```

### Validator Management
Change Validator Name:
```
quicksilverd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$QCK_ID \
--from=$QCK_WALLET
```

Get Out Of Jail(Unjail): 
```
quicksilverd tx slashing unjail \
  --broadcast-mode=block \
  --from=$QCK_WALLET \
  --chain-id=$QCK_ID \
  --gas=auto --fees 250uqck
```

To Delete Node Completely:
```
sudo systemctl stop quicksilverd
sudo systemctl disable quicksilverd
sudo rm /etc/systemd/system/quicksilver* -rf
sudo rm $(which quicksilverd) -rf
sudo rm $HOME/.quicksilverd* -rf
sudo rm $HOME/quicksilver -rf
sed -i '/QCK_/d' ~/.bash_profile
```
  