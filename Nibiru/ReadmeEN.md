<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/nibiru.png">
</p>

# Nibiru Installation Guide
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

## Nibiru Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Nibiru fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O NBR.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Nibiru/NBR && chmod +x NBR.sh && ./NBR.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
nibid status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
nibid keys add $NBR_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
nibid keys add $NBR_WALLET --recover
```

To get the current wallet list:
```
nibid keys list
```

### Save Wallet Information
Add Wallet Address:
```
NBR_WALLET_ADDRESS=$(nibid keys show $NBR_WALLET -a)
NBR_VALOPER_ADDRESS=$(nibid keys show $NBR_WALLET --bech val -a)
echo 'export NBR_WALLET_ADDRESS='${NBR_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export NBR_VALOPER_ADDRESS='${NBR_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 nibi (1 nibi equals 1000000 unibi) and your node is in sync.

To check your wallet balance:
```
nibid query bank balances $NBR_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
nibid tx staking create-validator \
  --amount 1000000unibi \
  --from $NBR_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(nibid tendermint show-validator) \
  --moniker $NBR_NODENAME \
  --chain-id $NBR_ID \
  --fees 250unibi
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu nibid -o cat
```

Start Service:
```
systemctl start nibid
```

Stop Service:
```
systemctl stop nibid
```

Restart Service:
```
systemctl restart nibid
```

### Node Information
Sync Information:
```
nibid status 2>&1 | jq .SyncInfo
```

Validator Information:
```
nibid status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
nibid status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
nibid tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
nibid keys list
```

Recover wallet using Mnemonic:
```
nibid keys add $NBR_WALLET --recover
```

Wallet Delete:
```
nibid keys delete $NBR_WALLET
```

Show Wallet Balance:
```
nibid query bank balances $NBR_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
nibid tx bank send $NBR_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000unibi
```

### Voting
```
nibid tx gov vote 1 yes --from $NBR_WALLET --chain-id=$NBR_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
nibid tx staking delegate $NBR_VALOPER_ADDRESS 10000000unibi --from=$NBR_WALLET --chain-id=$NBR_ID --gas=auto --fees 250unibi
```

Redelegate from validator to another validator:
```
nibid tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000unibi --from=$NBR_WALLET --chain-id=$NBR_ID --gas=auto --fees 250unibi
```

Withdraw all rewards:
```
nibid tx distribution withdraw-all-rewards --from=$NBR_WALLET --chain-id=$NBR_ID --gas=auto --fees 250unibi
```

Withdraw rewards with commission:
```
nibid tx distribution withdraw-rewards $NBR_VALOPER_ADDRESS --from=$NBR_WALLET --commission --chain-id=$NBR_ID
```

### Validator Management
Change Validator Name:
```
nibid tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$NBR_ID \
--from=$NBR_WALLET
```

Get Out Of Jail(Unjail):
```
nibid tx slashing unjail \
  --broadcast-mode=block \
  --from=$NBR_WALLET \
  --chain-id=$NBR_ID \
  --gas=auto --fees 250unibi
```

To Delete Node Completely:
```
sudo systemctl stop nibid
sudo systemctl disable nibid
sudo rm /etc/systemd/system/nibi* -rf
sudo rm $(which nibid) -rf
sudo rm $HOME/.nibid* -rf
sudo rm $HOME/nibiru -rf
sed -i '/NBR_/d' ~/.bash_profile
```
