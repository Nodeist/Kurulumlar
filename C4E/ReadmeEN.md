<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/c4e.png">
</p>

# C4E Installation Guide
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

## C4E Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your C4E fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O C4E.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/C4E/C4E && chmod +x C4E.sh && ./C4E.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
c4ed status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
c4ed keys add $C4E_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
c4ed keys add $C4E_WALLET --recover
```

To get the current wallet list:
```
c4ed keys list
```

### Save Wallet Information
Add Wallet Address:
```
C4E_WALLET_ADDRESS=$(c4ed keys show $C4E_WALLET -a)
C4E_VALOPER_ADDRESS=$(c4ed keys show $C4E_WALLET --bech val -a)
echo 'export C4E_WALLET_ADDRESS='${C4E_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export C4E_VALOPER_ADDRESS='${C4E_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 c4e (1 c4e equals 1000000 uc4e) and your node is in sync.

To check your wallet balance:
```
c4ed query bank balances $C4E_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
c4ed tx staking create-validator \
  --amount 1000000c4e \
  --from $C4E_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(c4ed tendermint show-validator) \
  --moniker $C4E_NODENAME \
  --chain-id $C4E_ID \
  --fees 250uc4e
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu c4ed -o cat
```

Start Service:
```
systemctl start c4ed
```

Stop Service:
```
systemctl stop c4ed
```

Restart Service:
```
systemctl restart c4ed
```

### Node Information
Sync Information:
```
c4ed status 2>&1 | jq .SyncInfo
```

Validator Information:
```
c4ed status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
c4ed status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
c4ed tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
c4ed keys list
```

Recover wallet using Mnemonic:
```
c4ed keys add $C4E_WALLET --recover
```

Wallet Delete:
```
c4ed keys delete $C4E_WALLET
```

Show Wallet Balance:
```
c4ed query bank balances $C4E_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
c4ed tx bank send $C4E_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uc4e
```

### Voting
```
c4ed tx gov vote 1 yes --from $C4E_WALLET --chain-id=$C4E_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
c4ed tx staking delegate $C4E_VALOPER_ADDRESS 10000000uc4e --from=$C4E_WALLET --chain-id=$C4E_ID --gas=auto --fees 250uc4e
```

Redelegate from validator to another validator:
```
c4ed tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uc4e --from=$C4E_WALLET --chain-id=$C4E_ID --gas=auto --fees 250uc4e
```

Withdraw all rewards:
```
c4ed tx distribution withdraw-all-rewards --from=$C4E_WALLET --chain-id=$C4E_ID --gas=auto --fees 250uc4e
```

Withdraw rewards with commission:
```
c4ed tx distribution withdraw-rewards $C4E_VALOPER_ADDRESS --from=$C4E_WALLET --commission --chain-id=$C4E_ID
```

### Validator Management
Change Validator Name:
```
c4ed tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$C4E_ID \
--from=$C4E_WALLET
```

Get Out Of Jail(Unjail):
```
c4ed tx slashing unjail \
  --broadcast-mode=block \
  --from=$C4E_WALLET \
  --chain-id=$C4E_ID \
  --gas=auto --fees 250uc4e
```

To Delete Node Completely:
```
sudo systemctl stop c4ed
sudo systemctl disable c4ed
sudo rm /etc/systemd/system/c4ed* -rf
sudo rm $(which c4ed) -rf
sudo rm $HOME/c4e-chain* -rf
sudo rm $HOME/.c4e -rf
sed -i '/C4E_/d' ~/.bash_profile
```
