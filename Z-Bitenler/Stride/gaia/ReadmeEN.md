&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/qa5txaz.png)


# Gaia Installation Guide
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

## Gaia Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Gaia fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O GAIA.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Stride/gaia/GAIA && chmod +x GAIA.sh && ./GAIA.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
gaiad status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
gaiad keys add $GAIA_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
gaiad keys add $GAIA_WALLET --recover
```

To get the current wallet list:
```
gaiad keys list
```

### Save Wallet Information
Add Wallet Address:
```
GAIA_WALLET_ADDRESS=$(gaiad keys show $GAIA_WALLET -a)
GAIA_VALOPER_ADDRESS=$(gaiad keys show $GAIA_WALLET --bech val -a)
echo 'export GAIA_WALLET_ADDRESS='${GAIA_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export GAIA_VALOPER_ADDRESS='${GAIA_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 atom (1 atom equals 1000000 uatom) and your node is in sync.

To check your wallet balance:
```
gaiad query bank balances $GAIA_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
gaiad tx staking create-validator \
  --amount 1000000uatom \
  --from $GAIA_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(gaiad tendermint show-validator) \
  --moniker $GAIA_NODENAME \
  --chain-id $GAIA_ID \
  --fees 250uatom
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu gaiad -o cat
```

Start Service:
```
systemctl start gaiad
```

Stop Service:
```
systemctl stop gaiad
```

Restart Service:
```
systemctl restart gaiad
```

### Node Information
Sync Information:
```
gaiad status 2>&1 | jq .SyncInfo
```

Validator Information:
```
gaiad status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
gaiad status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
gaiad tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
gaiad keys list
```

Recover wallet using Mnemonic:
```
gaiad keys add $GAIA_WALLET --recover
```

Wallet Delete:
```
gaiad keys delete $GAIA_WALLET
```

Show Wallet Balance:
```
gaiad query bank balances $GAIA_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
gaiad tx bank send $GAIA_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uatom
```

### Voting
```
gaiad tx gov vote 1 yes --from $GAIA_WALLET --chain-id=$GAIA_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
gaiad tx staking delegate $GAIA_VALOPER_ADDRESS 10000000uatom --from=$GAIA_WALLET --chain-id=$GAIA_ID --gas=auto --fees 250uatom
```

Redelegate from validator to another validator:
```
gaiad tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uatom --from=$GAIA_WALLET --chain-id=$GAIA_ID --gas=auto --fees 250uatom
```

Withdraw all rewards:
```
gaiad tx distribution withdraw-all-rewards --from=$GAIA_WALLET --chain-id=$GAIA_ID --gas=auto --fees 250uatom
```

Withdraw rewards with commission:
```
gaiad tx distribution withdraw-rewards $GAIA_VALOPER_ADDRESS --from=$GAIA_WALLET --commission --chain-id=$GAIA_ID
```

### Validator Management
Change Validator Name:
```
gaiad tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$GAIA_ID \
--from=$GAIA_WALLET
```

Get Out Of Jail(Unjail): 
```
gaiad tx slashing unjail \
  --broadcast-mode=block \
  --from=$GAIA_WALLET \
  --chain-id=$GAIA_ID \
  --gas=auto --fees 250uatom
```

To Delete Node Completely:
```
sudo systemctl stop gaiad
sudo systemctl disable gaiad
sudo rm /etc/systemd/system/gaia* -rf
sudo rm $(which gaiad) -rf
sudo rm $HOME/.gaia* -rf
sudo rm $HOME/gaia -rf
sed -i '/GAIA_/d' ~/.bash_profile
```
  