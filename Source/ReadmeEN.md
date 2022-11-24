<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/source.png">
</p>

# Source Installation Guide
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

## Source Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Source fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O SRC.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Source/SRC && chmod +x SRC.sh && ./SRC.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
sourced status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
sourced keys add $SRC_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
sourced keys add $SRC_WALLET --recover
```

To get the current wallet list:
```
sourced keys list
```

### Save Wallet Information
Add Wallet Address:
```
SRC_WALLET_ADDRESS=$(sourced keys show $SRC_WALLET -a)
SRC_VALOPER_ADDRESS=$(sourced keys show $SRC_WALLET --bech val -a)
echo 'export SRC_WALLET_ADDRESS='${SRC_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export SRC_VALOPER_ADDRESS='${SRC_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 source (1 source equals 1000000 usource) and your node is in sync.

To check your wallet balance:
```
sourced query bank balances $SRC_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
sourced tx staking create-validator \
  --amount 1000000usource \
  --from $SRC_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(sourced tendermint show-validator) \
  --moniker $SRC_NODENAME \
  --chain-id $SRC_ID \
  --fees 250usource
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu sourced -o cat
```

Start Service:
```
systemctl start sourced
```

Stop Service:
```
systemctl stop sourced
```

Restart Service:
```
systemctl restart sourced
```

### Node Information
Sync Information:
```
sourced status 2>&1 | jq .SyncInfo
```

Validator Information:
```
sourced status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
sourced status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
sourced tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
sourced keys list
```

Recover wallet using Mnemonic:
```
sourced keys add $SRC_WALLET --recover
```

Wallet Delete:
```
sourced keys delete $SRC_WALLET
```

Show Wallet Balance:
```
sourced query bank balances $SRC_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
sourced tx bank send $SRC_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000usource
```

### Voting
```
sourced tx gov vote 1 yes --from $SRC_WALLET --chain-id=$SRC_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
sourced tx staking delegate $SRC_VALOPER_ADDRESS 10000000usource --from=$SRC_WALLET --chain-id=$SRC_ID --gas=auto --fees 250usource
```

Redelegate from validator to another validator:
```
sourced tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000usource --from=$SRC_WALLET --chain-id=$SRC_ID --gas=auto --fees 250usource
```

Withdraw all rewards:
```
sourced tx distribution withdraw-all-rewards --from=$SRC_WALLET --chain-id=$SRC_ID --gas=auto --fees 250usource
```

Withdraw rewards with commission:
```
sourced tx distribution withdraw-rewards $SRC_VALOPER_ADDRESS --from=$SRC_WALLET --commission --chain-id=$SRC_ID
```

### Validator Management
Change Validator Name:
```
sourced tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$SRC_ID \
--from=$SRC_WALLET
```

Get Out Of Jail(Unjail):
```
sourced tx slashing unjail \
  --broadcast-mode=block \
  --from=$SRC_WALLET \
  --chain-id=$SRC_ID \
  --gas=auto --fees 250usource
```

To Delete Node Completely:
```
sudo systemctl stop sourced
sudo systemctl disable sourced
sudo rm /etc/systemd/system/sourced* -rf
sudo rm $(which sourced) -rf
sudo rm $HOME/.source* -rf
sudo rm $HOME/source -rf
sed -i '/SRC_/d' ~/.bash_profile
```
