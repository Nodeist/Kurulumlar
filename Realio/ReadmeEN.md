<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/realio.png">
</p>

# Realio Installation Guide
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

## Realio Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Realio fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O RLO.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Realio/RLO && chmod +x RLO.sh && ./RLO.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
realio-networkd status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
realio-networkd keys add $RLO_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
realio-networkd keys add $RLO_WALLET --recover
```

To get the current wallet list:
```
realio-networkd keys list
```

### Save Wallet Information
Add Wallet Address:
```
RLO_WALLET_ADDRESS=$(realio-networkd keys show $RLO_WALLET -a)
RLO_VALOPER_ADDRESS=$(realio-networkd keys show $RLO_WALLET --bech val -a)
echo 'export RLO_WALLET_ADDRESS='${RLO_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export RLO_VALOPER_ADDRESS='${RLO_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 rio (1 rio equals 1000000 ario) and your node is in sync.

To check your wallet balance:
```
realio-networkd query bank balances $RLO_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
realio-networkd tx staking create-validator \
  --amount 1000000ario \
  --from $RLO_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(realio-networkd tendermint show-validator) \
  --moniker $RLO_NODENAME \
  --chain-id $RLO_ID \
  --fees 250ario
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu realio-networkd -o cat
```

Start Service:
```
systemctl start realio-networkd
```

Stop Service:
```
systemctl stop realio-networkd
```

Restart Service:
```
systemctl restart realio-networkd
```

### Node Information
Sync Information:
```
realio-networkd status 2>&1 | jq .SyncInfo
```

Validator Information:
```
realio-networkd status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
realio-networkd status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
realio-networkd tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
realio-networkd keys list
```

Recover wallet using Mnemonic:
```
realio-networkd keys add $RLO_WALLET --recover
```

Wallet Delete:
```
realio-networkd keys delete $RLO_WALLET
```

Show Wallet Balance:
```
realio-networkd query bank balances $RLO_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
realio-networkd tx bank send $RLO_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ario
```

### Voting
```
realio-networkd tx gov vote 1 yes --from $RLO_WALLET --chain-id=$RLO_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
realio-networkd tx staking delegate $RLO_VALOPER_ADDRESS 10000000ario --from=$RLO_WALLET --chain-id=$RLO_ID --gas=auto --fees 250ario
```

Redelegate from validator to another validator:
```
realio-networkd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ario --from=$RLO_WALLET --chain-id=$RLO_ID --gas=auto --fees 250ario
```

Withdraw all rewards:
```
realio-networkd tx distribution withdraw-all-rewards --from=$RLO_WALLET --chain-id=$RLO_ID --gas=auto --fees 250ario
```

Withdraw rewards with commission:
```
realio-networkd tx distribution withdraw-rewards $RLO_VALOPER_ADDRESS --from=$RLO_WALLET --commission --chain-id=$RLO_ID
```

### Validator Management
Change Validator Name:
```
realio-networkd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$RLO_ID \
--from=$RLO_WALLET
```

Get Out Of Jail(Unjail):
```
realio-networkd tx slashing unjail \
  --broadcast-mode=block \
  --from=$RLO_WALLET \
  --chain-id=$RLO_ID \
  --gas=auto --fees 250ario
```

To Delete Node Completely:
```
sudo systemctl stop realio-networkd
sudo systemctl disable realio-networkd
sudo rm /etc/systemd/system/realio-network* -rf
sudo rm $(which realio-networkd) -rf
sudo rm $HOME/.realio-network* -rf
sudo rm $HOME/realio-network -rf
sed -i '/RLO_/d' ~/.bash_profile
```
