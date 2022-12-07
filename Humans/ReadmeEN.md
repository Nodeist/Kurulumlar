<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/humans.png">
</p>


# Humans Installation Guide
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

## Humans Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Humans fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O HMN.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Humans/HMN && chmod +x HMN.sh && ./HMN.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
humansd status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
humansd keys add $HMN_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
humansd keys add $HMN_WALLET --recover
```

To get the current wallet list:
```
humansd keys list
```

### Save Wallet Information
Add Wallet Address:
```
HMN_WALLET_ADDRESS=$(humansd keys show $HMN_WALLET -a)
HMN_VALOPER_ADDRESS=$(humansd keys show $HMN_WALLET --bech val -a)
echo 'export HMN_WALLET_ADDRESS='${HMN_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export HMN_VALOPER_ADDRESS='${HMN_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 heart (1 heart equals 1000000 uheart) and your node is in sync.

To check your wallet balance:
```
humansd query bank balances $HMN_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
humansd tx staking create-validator \
  --amount 1000000uheart \
  --from $HMN_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(humansd tendermint show-validator) \
  --moniker $HMN_NODENAME \
  --chain-id $HMN_ID \
  --fees 250uheart
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu humansd -o cat
```

Start Service:
```
systemctl start humansd
```

Stop Service:
```
systemctl stop humansd
```

Restart Service:
```
systemctl restart humansd
```

### Node Information
Sync Information:
```
humansd status 2>&1 | jq .SyncInfo
```

Validator Information:
```
humansd status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
humansd status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
humansd tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
humansd keys list
```

Recover wallet using Mnemonic:
```
humansd keys add $HMN_WALLET --recover
```

Wallet Delete:
```
humansd keys delete $HMN_WALLET
```

Show Wallet Balance:
```
humansd query bank balances $HMN_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
humansd tx bank send $HMN_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uheart
```

### Voting
```
humansd tx gov vote 1 yes --from $HMN_WALLET --chain-id=$HMN_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
humansd tx staking delegate $HMN_VALOPER_ADDRESS 10000000uheart --from=$HMN_WALLET --chain-id=$HMN_ID --gas=auto --fees 250uheart
```

Redelegate from validator to another validator:
```
humansd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uheart --from=$HMN_WALLET --chain-id=$HMN_ID --gas=auto --fees 250uheart
```

Withdraw all rewards:
```
humansd tx distribution withdraw-all-rewards --from=$HMN_WALLET --chain-id=$HMN_ID --gas=auto --fees 250uheart
```

Withdraw rewards with commission:
```
humansd tx distribution withdraw-rewards $HMN_VALOPER_ADDRESS --from=$HMN_WALLET --commission --chain-id=$HMN_ID
```

### Validator Management
Change Validator Name:
```
humansd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$HMN_ID \
--from=$HMN_WALLET
```

Get Out Of Jail(Unjail):
```
humansd tx slashing unjail \
  --broadcast-mode=block \
  --from=$HMN_WALLET \
  --chain-id=$HMN_ID \
  --gas=auto --fees 250uheart
```

To Delete Node Completely:
```
sudo systemctl stop humansd
sudo systemctl disable humansd
sudo rm /etc/systemd/system/humans* -rf
sudo rm $(which humansd) -rf
sudo rm $HOME/.humans* -rf
sudo rm $HOME/humans -rf
sed -i '/HMN_/d' ~/.bash_profile
```
