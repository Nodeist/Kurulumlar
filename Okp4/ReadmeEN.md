<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/okp4.png">
</p>

# Okp4 Installation Guide
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

## Okp4 Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Okp4 fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O OKP.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Okp4/OKP && chmod +x OKP.sh && ./OKP.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
okp4d status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
okp4d keys add $OKP_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
okp4d keys add $OKP_WALLET --recover
```

To get the current wallet list:
```
okp4d keys list
```

### Save Wallet Information
Add Wallet Address:
```
OKP_WALLET_ADDRESS=$(okp4d keys show $OKP_WALLET -a)
OKP_VALOPER_ADDRESS=$(okp4d keys show $OKP_WALLET --bech val -a)
echo 'export OKP_WALLET_ADDRESS='${OKP_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export OKP_VALOPER_ADDRESS='${OKP_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 know (1 know equals 1000000 uknow) and your node is in sync.

To check your wallet balance:
```
okp4d query bank balances $OKP_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
okp4d tx staking create-validator \
  --amount 1000000uknow \
  --from $OKP_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(okp4d tendermint show-validator) \
  --moniker $OKP_NODENAME \
  --chain-id $OKP_ID \
  --fees 250uknow
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu okp4d -o cat
```

Start Service:
```
systemctl start okp4d
```

Stop Service:
```
systemctl stop okp4d
```

Restart Service:
```
systemctl restart okp4d
```

### Node Information
Sync Information:
```
okp4d status 2>&1 | jq .SyncInfo
```

Validator Information:
```
okp4d status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
okp4d status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
okp4d tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
okp4d keys list
```

Recover wallet using Mnemonic:
```
okp4d keys add $OKP_WALLET --recover
```

Wallet Delete:
```
okp4d keys delete $OKP_WALLET
```

Show Wallet Balance:
```
okp4d query bank balances $OKP_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
okp4d tx bank send $OKP_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uknow
```

### Voting
```
okp4d tx gov vote 1 yes --from $OKP_WALLET --chain-id=$OKP_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
okp4d tx staking delegate $OKP_VALOPER_ADDRESS 10000000uknow --from=$OKP_WALLET --chain-id=$OKP_ID --gas=auto --fees 250uknow
```

Redelegate from validator to another validator:
```
okp4d tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uknow --from=$OKP_WALLET --chain-id=$OKP_ID --gas=auto --fees 250uknow
```

Withdraw all rewards:
```
okp4d tx distribution withdraw-all-rewards --from=$OKP_WALLET --chain-id=$OKP_ID --gas=auto --fees 250uknow
```

Withdraw rewards with commission:
```
okp4d tx distribution withdraw-rewards $OKP_VALOPER_ADDRESS --from=$OKP_WALLET --commission --chain-id=$OKP_ID
```

### Validator Management
Change Validator Name:
```
okp4d tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$OKP_ID \
--from=$OKP_WALLET
```

Get Out Of Jail(Unjail):
```
okp4d tx slashing unjail \
  --broadcast-mode=block \
  --from=$OKP_WALLET \
  --chain-id=$OKP_ID \
  --gas=auto --fees 250uknow
```

To Delete Node Completely:
```
sudo systemctl stop okp4d
sudo systemctl disable okp4d
sudo rm /etc/systemd/system/okp4* -rf
sudo rm $(which okp4d) -rf
sudo rm $HOME/.okp4d* -rf
sudo rm $HOME/okp4d -rf
sed -i '/OKP_/d' ~/.bash_profile
```
