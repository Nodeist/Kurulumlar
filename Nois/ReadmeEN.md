&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/jtwg72s.png)

# Nois Installation Guide
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

## Nois Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Nois fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O NOIS.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Nois/NOIS && chmod +x NOIS.sh && ./NOIS.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
noisd status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
noisd keys add $NOIS_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
noisd keys add $NOIS_WALLET --recover
```

To get the current wallet list:
```
noisd keys list
```

### Save Wallet Information
Add Wallet Address:
```
NOIS_WALLET_ADDRESS=$(noisd keys show $NOIS_WALLET -a)
NOIS_VALOPER_ADDRESS=$(noisd keys show $NOIS_WALLET --bech val -a)
echo 'export NOIS_WALLET_ADDRESS='${NOIS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export NOIS_VALOPER_ADDRESS='${NOIS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 nois (1 nois equals 1000000 unois) and your node is in sync.

To check your wallet balance:
```
noisd query bank balances $NOIS_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
noisd tx staking create-validator \
  --amount 1000000unois \
  --from $NOIS_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(noisd tendermint show-validator) \
  --moniker $NOIS_NODENAME \
  --chain-id $NOIS_ID \
  --fees 250unois
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu noisd -o cat
```

Start Service:
```
systemctl start noisd
```

Stop Service:
```
systemctl stop noisd
```

Restart Service:
```
systemctl restart noisd
```

### Node Information
Sync Information:
```
noisd status 2>&1 | jq .SyncInfo
```

Validator Information:
```
noisd status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
noisd status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
noisd tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
noisd keys list
```

Recover wallet using Mnemonic:
```
noisd keys add $NOIS_WALLET --recover
```

Wallet Delete:
```
noisd keys delete $NOIS_WALLET
```

Show Wallet Balance:
```
noisd query bank balances $NOIS_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
noisd tx bank send $NOIS_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000unois
```

### Voting
```
noisd tx gov vote 1 yes --from $NOIS_WALLET --chain-id=$NOIS_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
noisd tx staking delegate $NOIS_VALOPER_ADDRESS 10000000unois --from=$NOIS_WALLET --chain-id=$NOIS_ID --gas=auto --fees 250unois
```

Redelegate from validator to another validator:
```
noisd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000unois --from=$NOIS_WALLET --chain-id=$NOIS_ID --gas=auto --fees 250unois
```

Withdraw all rewards:
```
noisd tx distribution withdraw-all-rewards --from=$NOIS_WALLET --chain-id=$NOIS_ID --gas=auto --fees 250unois
```

Withdraw rewards with commission:
```
noisd tx distribution withdraw-rewards $NOIS_VALOPER_ADDRESS --from=$NOIS_WALLET --commission --chain-id=$NOIS_ID
```

### Validator Management
Change Validator Name:
```
noisd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$NOIS_ID \
--from=$NOIS_WALLET
```

Get Out Of Jail(Unjail):
```
noisd tx slashing unjail \
  --broadcast-mode=block \
  --from=$NOIS_WALLET \
  --chain-id=$NOIS_ID \
  --gas=auto --fees 250unois
```

To Delete Node Completely:
```
sudo systemctl stop noisd
sudo systemctl disable noisd
sudo rm /etc/systemd/system/nois* -rf
sudo rm $(which noisd) -rf
sudo rm $HOME/.nois* -rf
sudo rm $HOME/full-node -rf
sed -i '/NOIS_/d' ~/.bash_profile
```
