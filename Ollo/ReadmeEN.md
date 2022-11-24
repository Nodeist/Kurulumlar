<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/ollo.png">
</p>

# Ollo Installation Guide
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

## Ollo Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Ollo fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O OLLO.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Ollo/OLLO && chmod +x OLLO.sh && ./OLLO.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
ollod status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
ollod keys add $OLLO_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
ollod keys add $OLLO_WALLET --recover
```

To get the current wallet list:
```
ollod keys list
```

### Save Wallet Information
Add Wallet Address:
```
OLLO_WALLET_ADDRESS=$(ollod keys show $OLLO_WALLET -a)
OLLO_VALOPER_ADDRESS=$(ollod keys show $OLLO_WALLET --bech val -a)
echo 'export OLLO_WALLET_ADDRESS='${OLLO_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export OLLO_VALOPER_ADDRESS='${OLLO_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 tollo (1 tollo equals 1000000 utollo) and your node is in sync.

To check your wallet balance:
```
ollod query bank balances $OLLO_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
ollod tx staking create-validator \
  --amount 1000000utollo \
  --from $OLLO_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(ollod tendermint show-validator) \
  --moniker $OLLO_NODENAME \
  --chain-id $OLLO_ID \
  --fees 250utollo
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu ollod -o cat
```

Start Service:
```
systemctl start ollod
```

Stop Service:
```
systemctl stop ollod
```

Restart Service:
```
systemctl restart ollod
```

### Node Information
Sync Information:
```
ollod status 2>&1 | jq .SyncInfo
```

Validator Information:
```
ollod status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
ollod status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
ollod tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
ollod keys list
```

Recover wallet using Mnemonic:
```
ollod keys add $OLLO_WALLET --recover
```

Wallet Delete:
```
ollod keys delete $OLLO_WALLET
```

Show Wallet Balance:
```
ollod query bank balances $OLLO_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
ollod tx bank send $OLLO_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000utollo
```

### Voting
```
ollod tx gov vote 1 yes --from $OLLO_WALLET --chain-id=$OLLO_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
ollod tx staking delegate $OLLO_VALOPER_ADDRESS 10000000utollo --from=$OLLO_WALLET --chain-id=$OLLO_ID --gas=auto --fees 250utollo
```

Redelegate from validator to another validator:
```
ollod tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utollo --from=$OLLO_WALLET --chain-id=$OLLO_ID --gas=auto --fees 250utollo
```

Withdraw all rewards:
```
ollod tx distribution withdraw-all-rewards --from=$OLLO_WALLET --chain-id=$OLLO_ID --gas=auto --fees 250utollo
```

Withdraw rewards with commission:
```
ollod tx distribution withdraw-rewards $OLLO_VALOPER_ADDRESS --from=$OLLO_WALLET --commission --chain-id=$OLLO_ID
```

### Validator Management
Change Validator Name:
```
ollod tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$OLLO_ID \
--from=$OLLO_WALLET
```

Get Out Of Jail(Unjail):
```
ollod tx slashing unjail \
  --broadcast-mode=block \
  --from=$OLLO_WALLET \
  --chain-id=$OLLO_ID \
  --gas=auto --fees 250utollo
```

To Delete Node Completely:
```
sudo systemctl stop ollod
sudo systemctl disable ollod
sudo rm /etc/systemd/system/ollo* -rf
sudo rm $(which ollod) -rf
sudo rm $HOME/.ollo* -rf
sudo rm $HOME/ollo -rf
sed -i '/OLLO_/d' ~/.bash_profile
```
