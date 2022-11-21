&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/5yr9202.png)

# Acrechain Installation Guide
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

## Acrechain Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Acrechain fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O ACRE.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Acrechain/ACRE && chmod +x ACRE.sh && ./ACRE.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
acred status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
acred keys add $ACRE_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
acred keys add $ACRE_WALLET --recover
```

To get the current wallet list:
```
acred keys list
```

### Save Wallet Information
Add Wallet Address:
```
ACRE_WALLET_ADDRESS=$(acred keys show $ACRE_WALLET -a)
ACRE_VALOPER_ADDRESS=$(acred keys show $ACRE_WALLET --bech val -a)
echo 'export ACRE_WALLET_ADDRESS='${ACRE_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export ACRE_VALOPER_ADDRESS='${ACRE_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 acre (1 acre equals 1000000 uacre) and your node is in sync.

To check your wallet balance:
```
acred query bank balances $ACRE_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
acred tx staking create-validator \
  --amount 1000000uacre \
  --from $ACRE_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(acred tendermint show-validator) \
  --moniker $ACRE_NODENAME \
  --chain-id $ACRE_ID \
  --fees 250uacre
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu acred -o cat
```

Start Service:
```
systemctl start acred
```

Stop Service:
```
systemctl stop acred
```

Restart Service:
```
systemctl restart acred
```

### Node Information
Sync Information:
```
acred status 2>&1 | jq .SyncInfo
```

Validator Information:
```
acred status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
acred status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
acred tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
acred keys list
```

Recover wallet using Mnemonic:
```
acred keys add $ACRE_WALLET --recover
```

Wallet Delete:
```
acred keys delete $ACRE_WALLET
```

Show Wallet Balance:
```
acred query bank balances $ACRE_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
acred tx bank send $ACRE_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uacre
```

### Voting
```
acred tx gov vote 1 yes --from $ACRE_WALLET --chain-id=$ACRE_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
acred tx staking delegate $ACRE_VALOPER_ADDRESS 10000000uacre --from=$ACRE_WALLET --chain-id=$ACRE_ID --gas=auto --fees 250uacre
```

Redelegate from validator to another validator:
```
acred tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uacre --from=$ACRE_WALLET --chain-id=$ACRE_ID --gas=auto --fees 250uacre
```

Withdraw all rewards:
```
acred tx distribution withdraw-all-rewards --from=$ACRE_WALLET --chain-id=$ACRE_ID --gas=auto --fees 250uacre
```

Withdraw rewards with commission:
```
acred tx distribution withdraw-rewards $ACRE_VALOPER_ADDRESS --from=$ACRE_WALLET --commission --chain-id=$ACRE_ID
```

### Validator Management
Change Validator Name:
```
acred tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$ACRE_ID \
--from=$ACRE_WALLET
```

Get Out Of Jail(Unjail):
```
acred tx slashing unjail \
  --broadcast-mode=block \
  --from=$ACRE_WALLET \
  --chain-id=$ACRE_ID \
  --gas=auto --fees 250uacre
```

To Delete Node Completely:
```
sudo systemctl stop acred
sudo systemctl disable acred
sudo rm /etc/systemd/system/acre* -rf
sudo rm $(which acred) -rf
sudo rm $HOME/.acred* -rf
sudo rm $HOME/acrechain -rf
sed -i '/ACRE_/d' ~/.bash_profile
```
