<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/neutron.png">
</p>

# Neutron Installation Guide
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

## Neutron Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Neutron fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O NTRN.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Neutron/NTRN && chmod +x NTRN.sh && ./NTRN.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
neutrond status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
neutrond keys add $NTRN_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
neutrond keys add $NTRN_WALLET --recover
```

To get the current wallet list:
```
neutrond keys list
```

### Save Wallet Information
Add Wallet Address:
```
NTRN_WALLET_ADDRESS=$(neutrond keys show $NTRN_WALLET -a)
NTRN_VALOPER_ADDRESS=$(neutrond keys show $NTRN_WALLET --bech val -a)
echo 'export NTRN_WALLET_ADDRESS='${NTRN_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export NTRN_VALOPER_ADDRESS='${NTRN_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 ntrn (1 ntrn equals 1000000 untrn) and your node is in sync.

To check your wallet balance:
```
neutrond query bank balances $NTRN_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
neutrond tx staking create-validator \
  --amount 1000000untrn \
  --from $NTRN_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(neutrond tendermint show-validator) \
  --moniker $NTRN_NODENAME \
  --chain-id $NTRN_ID \
  --fees 250untrn
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu neutrond -o cat
```

Start Service:
```
systemctl start neutrond
```

Stop Service:
```
systemctl stop neutrond
```

Restart Service:
```
systemctl restart neutrond
```

### Node Information
Sync Information:
```
neutrond status 2>&1 | jq .SyncInfo
```

Validator Information:
```
neutrond status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
neutrond status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
neutrond tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
neutrond keys list
```

Recover wallet using Mnemonic:
```
neutrond keys add $NTRN_WALLET --recover
```

Wallet Delete:
```
neutrond keys delete $NTRN_WALLET
```

Show Wallet Balance:
```
neutrond query bank balances $NTRN_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
neutrond tx bank send $NTRN_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000untrn
```

### Voting
```
neutrond tx gov vote 1 yes --from $NTRN_WALLET --chain-id=$NTRN_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
neutrond tx staking delegate $NTRN_VALOPER_ADDRESS 10000000untrn --from=$NTRN_WALLET --chain-id=$NTRN_ID --gas=auto --fees 250untrn
```

Redelegate from validator to another validator:
```
neutrond tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000untrn --from=$NTRN_WALLET --chain-id=$NTRN_ID --gas=auto --fees 250untrn
```

Withdraw all rewards:
```
neutrond tx distribution withdraw-all-rewards --from=$NTRN_WALLET --chain-id=$NTRN_ID --gas=auto --fees 250untrn
```

Withdraw rewards with commission:
```
neutrond tx distribution withdraw-rewards $NTRN_VALOPER_ADDRESS --from=$NTRN_WALLET --commission --chain-id=$NTRN_ID
```

### Validator Management
Change Validator Name:
```
neutrond tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$NTRN_ID \
--from=$NTRN_WALLET
```

Get Out Of Jail(Unjail):
```
neutrond tx slashing unjail \
  --broadcast-mode=block \
  --from=$NTRN_WALLET \
  --chain-id=$NTRN_ID \
  --gas=auto --fees 250untrn
```

To Delete Node Completely:
```
sudo systemctl stop neutrond
sudo systemctl disable neutrond
sudo rm /etc/systemd/system/neutron* -rf
sudo rm $(which neutrond) -rf
sudo rm $HOME/.neutrond* -rf
sudo rm $HOME/neutron -rf
sed -i '/NTRN_/d' ~/.bash_profile
```
