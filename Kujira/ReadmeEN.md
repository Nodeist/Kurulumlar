<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/kujira.png">
</p>

# Kujira Installation Guide
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

## Kujira Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Kujira fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O KUJI.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Kujira/KUJI && chmod +x KUJI.sh && ./KUJI.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
kujirad status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
kujirad keys add $KUJI_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
kujirad keys add $KUJI_WALLET --recover
```

To get the current wallet list:
```
kujirad keys list
```

### Save Wallet Information
Add Wallet Address:
```
KUJI_WALLET_ADDRESS=$(kujirad keys show $KUJI_WALLET -a)
KUJI_VALOPER_ADDRESS=$(kujirad keys show $KUJI_WALLET --bech val -a)
echo 'export KUJI_WALLET_ADDRESS='${KUJI_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export KUJI_VALOPER_ADDRESS='${KUJI_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 kuji (1 kuji equals 1000000 ukuji) and your node is in sync.

To check your wallet balance:
```
kujirad query bank balances $KUJI_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
kujirad tx staking create-validator \
  --amount 1000000ukuji \
  --from $KUJI_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(kujirad tendermint show-validator) \
  --moniker $KUJI_NODENAME \
  --chain-id $KUJI_ID \
  --fees 250ukuji
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu kujirad -o cat
```

Start Service:
```
systemctl start kujirad
```

Stop Service:
```
systemctl stop kujirad
```

Restart Service:
```
systemctl restart kujirad
```

### Node Information
Sync Information:
```
kujirad status 2>&1 | jq .SyncInfo
```

Validator Information:
```
kujirad status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
kujirad status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
kujirad tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
kujirad keys list
```

Recover wallet using Mnemonic:
```
kujirad keys add $KUJI_WALLET --recover
```

Wallet Delete:
```
kujirad keys delete $KUJI_WALLET
```

Show Wallet Balance:
```
kujirad query bank balances $KUJI_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
kujirad tx bank send $KUJI_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ukuji
```

### Voting
```
kujirad tx gov vote 1 yes --from $KUJI_WALLET --chain-id=$KUJI_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
kujirad tx staking delegate $KUJI_VALOPER_ADDRESS 10000000ukuji --from=$KUJI_WALLET --chain-id=$KUJI_ID --gas=auto --fees 250ukuji
```

Redelegate from validator to another validator:
```
kujirad tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ukuji --from=$KUJI_WALLET --chain-id=$KUJI_ID --gas=auto --fees 250ukuji
```

Withdraw all rewards:
```
kujirad tx distribution withdraw-all-rewards --from=$KUJI_WALLET --chain-id=$KUJI_ID --gas=auto --fees 250ukuji
```

Withdraw rewards with commission:
```
kujirad tx distribution withdraw-rewards $KUJI_VALOPER_ADDRESS --from=$KUJI_WALLET --commission --chain-id=$KUJI_ID
```

### Validator Management
Change Validator Name:
```
kujirad tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$KUJI_ID \
--from=$KUJI_WALLET
```

Get Out Of Jail(Unjail):
```
kujirad tx slashing unjail \
  --broadcast-mode=block \
  --from=$KUJI_WALLET \
  --chain-id=$KUJI_ID \
  --gas=auto --fees 250ukuji
```

To Delete Node Completely:
```
sudo systemctl stop kujirad
sudo systemctl disable kujirad
sudo rm /etc/systemd/system/kujira* -rf
sudo rm $(which kujirad) -rf
sudo rm $HOME/.kujira* -rf
sudo rm $HOME/core -rf
sed -i '/KUJI_/d' ~/.bash_profile
```
