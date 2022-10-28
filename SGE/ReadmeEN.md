&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/jr9si78.png)

# SGE Installation Guide
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

## SGE Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your SGE fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O SGE.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/SGE/SGE && chmod +x SGE.sh && ./SGE.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
sged status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
sged keys add $SGE_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
sged keys add $SGE_WALLET --recover
```

To get the current wallet list:
```
sged keys list
```

### Save Wallet Information
Add Wallet Address:
```
SGE_WALLET_ADDRESS=$(sged keys show $SGE_WALLET -a)
SGE_VALOPER_ADDRESS=$(sged keys show $SGE_WALLET --bech val -a)
echo 'export SGE_WALLET_ADDRESS='${SGE_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export SGE_VALOPER_ADDRESS='${SGE_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 sge (1 sge equals 1000000 usge) and your node is in sync.

To check your wallet balance:
```
sged query bank balances $SGE_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
sged tx staking create-validator \
  --amount 1000000usge \
  --from $SGE_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(sged tendermint show-validator) \
  --moniker $SGE_NODENAME \
  --chain-id $SGE_ID \
  --fees 250usge
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu sged -o cat
```

Start Service:
```
systemctl start sged
```

Stop Service:
```
systemctl stop sged
```

Restart Service:
```
systemctl restart sged
```

### Node Information
Sync Information:
```
sged status 2>&1 | jq .SyncInfo
```

Validator Information:
```
sged status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
sged status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
sged tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
sged keys list
```

Recover wallet using Mnemonic:
```
sged keys add $SGE_WALLET --recover
```

Wallet Delete:
```
sged keys delete $SGE_WALLET
```

Show Wallet Balance:
```
sged query bank balances $SGE_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
sged tx bank send $SGE_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000usge
```

### Voting
```
sged tx gov vote 1 yes --from $SGE_WALLET --chain-id=$SGE_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
sged tx staking delegate $SGE_VALOPER_ADDRESS 10000000usge --from=$SGE_WALLET --chain-id=$SGE_ID --gas=auto --fees 250usge
```

Redelegate from validator to another validator:
```
sged tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000usge --from=$SGE_WALLET --chain-id=$SGE_ID --gas=auto --fees 250usge
```

Withdraw all rewards:
```
sged tx distribution withdraw-all-rewards --from=$SGE_WALLET --chain-id=$SGE_ID --gas=auto --fees 250usge
```

Withdraw rewards with commission:
```
sged tx distribution withdraw-rewards $SGE_VALOPER_ADDRESS --from=$SGE_WALLET --commission --chain-id=$SGE_ID
```

### Validator Management
Change Validator Name:
```
sged tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$SGE_ID \
--from=$SGE_WALLET
```

Get Out Of Jail(Unjail):
```
sged tx slashing unjail \
  --broadcast-mode=block \
  --from=$SGE_WALLET \
  --chain-id=$SGE_ID \
  --gas=auto --fees 250usge
```

To Delete Node Completely:
```
sudo systemctl stop sged
sudo systemctl disable sged
sudo rm /etc/systemd/system/sge* -rf
sudo rm $(which sged) -rf
sudo rm $HOME/.sge* -rf
sudo rm $HOME/sge -rf
sed -i '/SGE_/d' ~/.bash_profile
```
