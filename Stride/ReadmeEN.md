<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/stride.png">
</p>

# Stride Installation Guide
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

## Stride Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Stride fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O STRD.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Stride/STRD && chmod +x STRD.sh && ./STRD.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
strided status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
strided keys add $STRD_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
strided keys add $STRD_WALLET --recover
```

To get the current wallet list:
```
strided keys list
```

### Save Wallet Information
Add Wallet Address:
```
STRD_WALLET_ADDRESS=$(strided keys show $STRD_WALLET -a)
STRD_VALOPER_ADDRESS=$(strided keys show $STRD_WALLET --bech val -a)
echo 'export STRD_WALLET_ADDRESS='${STRD_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export STRD_VALOPER_ADDRESS='${STRD_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 strd (1 strd equals 1000000 ustrd) and your node is in sync.

To check your wallet balance:
```
strided query bank balances $STRD_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
strided tx staking create-validator \
  --amount 1000000ustrd \
  --from $STRD_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(strided tendermint show-validator) \
  --moniker $STRD_NODENAME \
  --chain-id $STRD_ID \
  --fees 250ustrd
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu strided -o cat
```

Start Service:
```
systemctl start strided
```

Stop Service:
```
systemctl stop strided
```

Restart Service:
```
systemctl restart strided
```

### Node Information
Sync Information:
```
strided status 2>&1 | jq .SyncInfo
```

Validator Information:
```
strided status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
strided status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
strided tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
strided keys list
```

Recover wallet using Mnemonic:
```
strided keys add $STRD_WALLET --recover
```

Wallet Delete:
```
strided keys delete $STRD_WALLET
```

Show Wallet Balance:
```
strided query bank balances $STRD_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
strided tx bank send $STRD_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ustrd
```

### Voting
```
strided tx gov vote 1 yes --from $STRD_WALLET --chain-id=$STRD_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
strided tx staking delegate $STRD_VALOPER_ADDRESS 10000000ustrd --from=$STRD_WALLET --chain-id=$STRD_ID --gas=auto --fees 250ustrd
```

Redelegate from validator to another validator:
```
strided tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ustrd --from=$STRD_WALLET --chain-id=$STRD_ID --gas=auto --fees 250ustrd
```

Withdraw all rewards:
```
strided tx distribution withdraw-all-rewards --from=$STRD_WALLET --chain-id=$STRD_ID --gas=auto --fees 250ustrd
```

Withdraw rewards with commission:
```
strided tx distribution withdraw-rewards $STRD_VALOPER_ADDRESS --from=$STRD_WALLET --commission --chain-id=$STRD_ID
```

### Validator Management
Change Validator Name:
```
strided tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$STRD_ID \
--from=$STRD_WALLET
```

Get Out Of Jail(Unjail):
```
strided tx slashing unjail \
  --broadcast-mode=block \
  --from=$STRD_WALLET \
  --chain-id=$STRD_ID \
  --gas=auto --fees 250ustrd
```

To Delete Node Completely:
```
sudo systemctl stop strided
sudo systemctl disable strided
sudo rm /etc/systemd/system/stride* -rf
sudo rm $(which strided) -rf
sudo rm $HOME/.stride* -rf
sudo rm $HOME/stride -rf
sed -i '/STRD_/d' ~/.bash_profile
```
