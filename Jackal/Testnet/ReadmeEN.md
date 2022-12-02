<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/jackal.png">
</p>


# Jackal Installation Guide
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

## Jackal Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Jackal fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O JKL.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Jackal/JKL && chmod +x JKL.sh && ./JKL.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
canined status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
canined keys add $JKL_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
canined keys add $JKL_WALLET --recover
```

To get the current wallet list:
```
canined keys list
```

### Save Wallet Information
Add Wallet Address:
```
JKL_WALLET_ADDRESS=$(canined keys show $JKL_WALLET -a)
JKL_VALOPER_ADDRESS=$(canined keys show $JKL_WALLET --bech val -a)
echo 'export JKL_WALLET_ADDRESS='${JKL_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export JKL_VALOPER_ADDRESS='${JKL_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 jkl (1 jkl equals 1000000 ujkl) and your node is in sync.

To check your wallet balance:
```
canined query bank balances $JKL_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
canined tx staking create-validator \
  --amount 1000000ujkl \
  --from $JKL_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(canined tendermint show-validator) \
  --moniker $JKL_NODENAME \
  --chain-id $JKL_ID \
  --fees 250ujkl
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu canined -o cat
```

Start Service:
```
systemctl start canined
```

Stop Service:
```
systemctl stop canined
```

Restart Service:
```
systemctl restart canined
```

### Node Information
Sync Information:
```
canined status 2>&1 | jq .SyncInfo
```

Validator Information:
```
canined status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
canined status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
canined tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
canined keys list
```

Recover wallet using Mnemonic:
```
canined keys add $JKL_WALLET --recover
```

Wallet Delete:
```
canined keys delete $JKL_WALLET
```

Show Wallet Balance:
```
canined query bank balances $JKL_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
canined tx bank send $JKL_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ujkl
```

### Voting
```
canined tx gov vote 1 yes --from $JKL_WALLET --chain-id=$JKL_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
canined tx staking delegate $JKL_VALOPER_ADDRESS 10000000ujkl --from=$JKL_WALLET --chain-id=$JKL_ID --gas=auto --fees 250ujkl
```

Redelegate from validator to another validator:
```
canined tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ujkl --from=$JKL_WALLET --chain-id=$JKL_ID --gas=auto --fees 250ujkl
```

Withdraw all rewards:
```
canined tx distribution withdraw-all-rewards --from=$JKL_WALLET --chain-id=$JKL_ID --gas=auto --fees 250ujkl
```

Withdraw rewards with commission:
```
canined tx distribution withdraw-rewards $JKL_VALOPER_ADDRESS --from=$JKL_WALLET --commission --chain-id=$JKL_ID
```

### Validator Management
Change Validator Name:
```
canined tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$JKL_ID \
--from=$JKL_WALLET
```

Get Out Of Jail(Unjail):
```
canined tx slashing unjail \
  --broadcast-mode=block \
  --from=$JKL_WALLET \
  --chain-id=$JKL_ID \
  --gas=auto --fees 250ujkl
```

To Delete Node Completely:
```
sudo systemctl stop canined
sudo systemctl disable canined
sudo rm /etc/systemd/system/canined* -rf
sudo rm $(which canined) -rf
sudo rm $HOME/.canine* -rf
sudo rm $HOME/canine-chain -rf
sed -i '/JKL_/d' ~/.bash_profile
```
