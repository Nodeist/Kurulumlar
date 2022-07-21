
&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>

![](https://i.hizliresim.com/gsu0zju.png)

# Sei Installation Guide
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

## Sei Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Sei fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O SEI.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Sei/SEI && chmod +x SEI.sh && ./SEI.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
seid status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
seid keys add $SEI_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
seid keys add $SEI_WALLET --recover
```

To get the current wallet list:
```
seid keys list
```

### Save Wallet Information
Add Wallet Address:
```
SEI_WALLET_ADDRESS=$(seid keys show $SEI_WALLET -a)
SEI_VALOPER_ADDRESS=$(seid keys show $SEI_WALLET --bech val -a)
echo 'export SEI_WALLET_ADDRESS='${SEI_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export SEI_VALOPER_ADDRESS='${SEI_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 sei (1 sei equals 1000000 usei) and your node is in sync.

To check your wallet balance:
```
seid query bank balances $SEI_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
seid tx staking create-validator \
  --amount 1000000usei \
  --from $SEI_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(seid tendermint show-validator) \
  --moniker $SEI_NODENAME \
  --chain-id $SEI_ID \
  --fees 250usei
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu seid -o cat
```

Start Service:
```
systemctl start seid
```

Stop Service:
```
systemctl stop seid
```

Restart Service:
```
systemctl restart seid
```

### Node Information
Sync Information:
```
seid status 2>&1 | jq .SyncInfo
```

Validator Information:
```
seid status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
seid status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
seid tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
seid keys list
```

Recover wallet using Mnemonic:
```
seid keys add $SEI_WALLET --recover
```

Wallet Delete:
```
seid keys delete $SEI_WALLET
```

Show Wallet Balance:
```
seid query bank balances $SEI_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
seid tx bank send $SEI_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000usei
```

### Voting
```
seid tx gov vote 1 yes --from $SEI_WALLET --chain-id=$SEI_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
seid tx staking delegate $SEI_VALOPER_ADDRESS 10000000usei --from=$SEI_WALLET --chain-id=$SEI_ID --gas=auto --fees 250usei
```

Redelegate from validator to another validator:
```
seid tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000usei --from=$SEI_WALLET --chain-id=$SEI_ID --gas=auto --fees 250usei
```

Withdraw all rewards:
```
seid tx distribution withdraw-all-rewards --from=$SEI_WALLET --chain-id=$SEI_ID --gas=auto --fees 250usei
```

Withdraw rewards with commission:
```
seid tx distribution withdraw-rewards $SEI_VALOPER_ADDRESS --from=$SEI_WALLET --commission --chain-id=$SEI_ID
```

### Validator Management
Change Validator Name:
```
seid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$SEI_ID \
--from=$SEI_WALLET
```

Get Out Of Jail(Unjail): 
```
seid tx slashing unjail \
  --broadcast-mode=block \
  --from=$SEI_WALLET \
  --chain-id=$SEI_ID \
  --gas=auto --fees 250usei
```

To Delete Node Completely:
```
sudo systemctl stop seid
sudo systemctl disable seid
sudo rm /etc/systemd/system/seid* -rf
sudo rm $(which seid) -rf
sudo rm $HOME/.sei* -rf
sudo rm $HOME/sei-chain -rf
sed -i '/SEI_/d' ~/.bash_profile
```
