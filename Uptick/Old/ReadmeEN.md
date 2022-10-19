&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/nro1l6b.jpeg)


# Uptick Installation Guide
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

## Uptick Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Uptick fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O UPTICK.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Z-Bitenler/Uptick/UPTICK && chmod +x UPTICK.sh && ./UPTICK.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
uptickd status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
uptickd keys add $UPTICK_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
uptickd keys add $UPTICK_WALLET --recover
```

To get the current wallet list:
```
uptickd keys list
```

### Save Wallet Information
Add Wallet Address:
```
UPTICK_WALLET_ADDRESS=$(uptickd keys show $UPTICK_WALLET -a)
UPTICK_VALOPER_ADDRESS=$(uptickd keys show $UPTICK_WALLET --bech val -a)
echo 'export UPTICK_WALLET_ADDRESS='${UPTICK_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export UPTICK_VALOPER_ADDRESS='${UPTICK_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 uptick (1 uptick equals 1000000 auptick) and your node is in sync.

To check your wallet balance:
```
uptickd query bank balances $UPTICK_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
uptickd tx staking create-validator \
  --amount 1000000auptick \
  --from $UPTICK_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(uptickd tendermint show-validator) \
  --moniker $UPTICK_NODENAME \
  --chain-id $UPTICK_ID \
  --fees 250auptick
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu uptickd -o cat
```

Start Service:
```
systemctl start uptickd
```

Stop Service:
```
systemctl stop uptickd
```

Restart Service:
```
systemctl restart uptickd
```

### Node Information
Sync Information:
```
uptickd status 2>&1 | jq .SyncInfo
```

Validator Information:
```
uptickd status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
uptickd status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
uptickd tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
uptickd keys list
```

Recover wallet using Mnemonic:
```
uptickd keys add $UPTICK_WALLET --recover
```

Wallet Delete:
```
uptickd keys delete $UPTICK_WALLET
```

Show Wallet Balance:
```
uptickd query bank balances $UPTICK_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
uptickd tx bank send $UPTICK_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000auptick
```

### Voting
```
uptickd tx gov vote 1 yes --from $UPTICK_WALLET --chain-id=$UPTICK_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
uptickd tx staking delegate $UPTICK_VALOPER_ADDRESS 10000000auptick --from=$UPTICK_WALLET --chain-id=$UPTICK_ID --gas=auto --fees 250auptick
```

Redelegate from validator to another validator:
```
uptickd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000auptick --from=$UPTICK_WALLET --chain-id=$UPTICK_ID --gas=auto --fees 250auptick
```

Withdraw all rewards:
```
uptickd tx distribution withdraw-all-rewards --from=$UPTICK_WALLET --chain-id=$UPTICK_ID --gas=auto --fees 250auptick
```

Withdraw rewards with commission:
```
uptickd tx distribution withdraw-rewards $UPTICK_VALOPER_ADDRESS --from=$UPTICK_WALLET --commission --chain-id=$UPTICK_ID
```

### Validator Management
Change Validator Name:
```
uptickd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$UPTICK_ID \
--from=$UPTICK_WALLET
```

Get Out Of Jail(Unjail): 
```
uptickd tx slashing unjail \
  --broadcast-mode=block \
  --from=$UPTICK_WALLET \
  --chain-id=$UPTICK_ID \
  --gas=auto --fees 250auptick
```

To Delete Node Completely:
```
sudo systemctl stop uptickd
sudo systemctl disable uptickd
sudo rm /etc/systemd/system/uptick* -rf
sudo rm $(which uptickd) -rf
sudo rm $HOME/.uptickd* -rf
sudo rm $HOME/uptick -rf
sed -i '/UPTICK_/d' ~/.bash_profile
```
  