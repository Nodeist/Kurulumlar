<p align="center">
<img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/joe.png">
</p>


# Joe Installation Guide
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

## Joe Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Joe fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O JOE.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Joe/JOE && chmod +x JOE.sh && ./JOE.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
joed status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
joed keys add $JOE_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
joed keys add $JOE_WALLET --recover
```

To get the current wallet list:
```
joed keys list
```

### Save Wallet Information
Add Wallet Address:
```
JOE_WALLET_ADDRESS=$(joed keys show $JOE_WALLET -a)
JOE_VALOPER_ADDRESS=$(joed keys show $JOE_WALLET --bech val -a)
echo 'export JOE_WALLET_ADDRESS='${JOE_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export JOE_VALOPER_ADDRESS='${JOE_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 joe (1 joe equals 1000000 ujoe) and your node is in sync.

To check your wallet balance:
```
joed query bank balances $JOE_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
joed tx staking create-validator \
  --amount 1000000ujoe \
  --from $JOE_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(joed tendermint show-validator) \
  --moniker $JOE_NODENAME \
  --chain-id $JOE_ID \
  --fees 250ujoe
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu joed -o cat
```

Start Service:
```
systemctl start joed
```

Stop Service:
```
systemctl stop joed
```

Restart Service:
```
systemctl restart joed
```

### Node Information
Sync Information:
```
joed status 2>&1 | jq .SyncInfo
```

Validator Information:
```
joed status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
joed status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
joed tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
joed keys list
```

Recover wallet using Mnemonic:
```
joed keys add $JOE_WALLET --recover
```

Wallet Delete:
```
joed keys delete $JOE_WALLET
```

Show Wallet Balance:
```
joed query bank balances $JOE_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
joed tx bank send $JOE_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ujoe
```

### Voting
```
joed tx gov vote 1 yes --from $JOE_WALLET --chain-id=$JOE_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
joed tx staking delegate $JOE_VALOPER_ADDRESS 10000000ujoe --from=$JOE_WALLET --chain-id=$JOE_ID --gas=auto --fees 250ujoe
```

Redelegate from validator to another validator:
```
joed tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ujoe --from=$JOE_WALLET --chain-id=$JOE_ID --gas=auto --fees 250ujoe
```

Withdraw all rewards:
```
joed tx distribution withdraw-all-rewards --from=$JOE_WALLET --chain-id=$JOE_ID --gas=auto --fees 250ujoe
```

Withdraw rewards with commission:
```
joed tx distribution withdraw-rewards $JOE_VALOPER_ADDRESS --from=$JOE_WALLET --commission --chain-id=$JOE_ID
```

### Validator Management
Change Validator Name:
```
joed tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$JOE_ID \
--from=$JOE_WALLET
```

Get Out Of Jail(Unjail):
```
joed tx slashing unjail \
  --broadcast-mode=block \
  --from=$JOE_WALLET \
  --chain-id=$JOE_ID \
  --gas=auto --fees 250ujoe
```

To Delete Node Completely:
```
sudo systemctl stop joed
sudo systemctl disable joed
sudo rm /etc/systemd/system/joed* -rf
sudo rm $(which joed) -rf
sudo rm $HOME/.joed* -rf
sudo rm $HOME/joe -rf
sed -i '/JOE_/d' ~/.bash_profile
```
