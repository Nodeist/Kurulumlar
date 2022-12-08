<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/kyve.png">
</p>


# Kyve Installation Guide
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

## Kyve Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Kyve fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O KYVE.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Kyve/KYVE && chmod +x KYVE.sh && ./KYVE.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
kyved status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
kyved keys add $KYVE_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
kyved keys add $KYVE_WALLET --recover
```

To get the current wallet list:
```
kyved keys list
```

### Save Wallet Information
Add Wallet Address:
```
KYVE_WALLET_ADDRESS=$(kyved keys show $KYVE_WALLET -a)
KYVE_VALOPER_ADDRESS=$(kyved keys show $KYVE_WALLET --bech val -a)
echo 'export KYVE_WALLET_ADDRESS='${KYVE_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export KYVE_VALOPER_ADDRESS='${KYVE_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 kyve (1 kyve equals 1000000 tkyve) and your node is in sync.

To check your wallet balance:
```
kyved query bank balances $KYVE_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
kyved tx staking create-validator \
  --amount 1000000tkyve \
  --from $KYVE_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(kyved tendermint show-validator) \
  --moniker $KYVE_NODENAME \
  --chain-id $KYVE_ID \
  --fees 250tkyve
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu kyved -o cat
```

Start Service:
```
systemctl start kyved
```

Stop Service:
```
systemctl stop kyved
```

Restart Service:
```
systemctl restart kyved
```

### Node Information
Sync Information:
```
kyved status 2>&1 | jq .SyncInfo
```

Validator Information:
```
kyved status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
kyved status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
kyved tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
kyved keys list
```

Recover wallet using Mnemonic:
```
kyved keys add $KYVE_WALLET --recover
```

Wallet Delete:
```
kyved keys delete $KYVE_WALLET
```

Show Wallet Balance:
```
kyved query bank balances $KYVE_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
kyved tx bank send $KYVE_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000tkyve
```

### Voting
```
kyved tx gov vote 1 yes --from $KYVE_WALLET --chain-id=$KYVE_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
kyved tx staking delegate $KYVE_VALOPER_ADDRESS 10000000tkyve --from=$KYVE_WALLET --chain-id=$KYVE_ID --gas=auto --fees 250tkyve
```

Redelegate from validator to another validator:
```
kyved tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000tkyve --from=$KYVE_WALLET --chain-id=$KYVE_ID --gas=auto --fees 250tkyve
```

Withdraw all rewards:
```
kyved tx distribution withdraw-all-rewards --from=$KYVE_WALLET --chain-id=$KYVE_ID --gas=auto --fees 250tkyve
```

Withdraw rewards with commission:
```
kyved tx distribution withdraw-rewards $KYVE_VALOPER_ADDRESS --from=$KYVE_WALLET --commission --chain-id=$KYVE_ID
```

### Validator Management
Change Validator Name:
```
kyved tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$KYVE_ID \
--from=$KYVE_WALLET
```

Get Out Of Jail(Unjail):
```
kyved tx slashing unjail \
  --broadcast-mode=block \
  --from=$KYVE_WALLET \
  --chain-id=$KYVE_ID \
  --gas=auto --fees 250tkyve
```

To Delete Node Completely:
```
sudo systemctl stop kyved
sudo systemctl disable kyved
sudo rm /etc/systemd/system/kyve* -rf
sudo rm $(which kyved) -rf
sudo rm $HOME/.kyve* -rf
sudo rm $HOME/kyve -rf
sed -i '/KYVE_/d' ~/.bash_profile
```
