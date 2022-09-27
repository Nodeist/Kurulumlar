&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/itxl39j.png)

# Hypersign Installation Guide
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

## Hypersign Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Hypersign fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O HS.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Hypersign/HS && chmod +x HS.sh && ./HS.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
hid-noded status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
hid-noded keys add $HS_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
hid-noded keys add $HS_WALLET --recover
```

To get the current wallet list:
```
hid-noded keys list
```

### Save Wallet Information
Add Wallet Address:
```
HS_WALLET_ADDRESS=$(hid-noded keys show $HS_WALLET -a)
HS_VALOPER_ADDRESS=$(hid-noded keys show $HS_WALLET --bech val -a)
echo 'export HS_WALLET_ADDRESS='${HS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export HS_VALOPER_ADDRESS='${HS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 hid (1 hid equals 1000000 uhid) and your node is in sync.

To check your wallet balance:
```
hid-noded query bank balances $HS_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
hid-noded tx staking create-validator \
  --amount 1000000uhid \
  --from $HS_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(hid-noded tendermint show-validator) \
  --moniker $HS_NODENAME \
  --chain-id $HS_ID \
  --fees 250uhid
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu hid-noded -o cat
```

Start Service:
```
systemctl start hid-noded
```

Stop Service:
```
systemctl stop hid-noded
```

Restart Service:
```
systemctl restart hid-noded
```

### Node Information
Sync Information:
```
hid-noded status 2>&1 | jq .SyncInfo
```

Validator Information:
```
hid-noded status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
hid-noded status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
hid-noded tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
hid-noded keys list
```

Recover wallet using Mnemonic:
```
hid-noded keys add $HS_WALLET --recover
```

Wallet Delete:
```
hid-noded keys delete $HS_WALLET
```

Show Wallet Balance:
```
hid-noded query bank balances $HS_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
hid-noded tx bank send $HS_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uhid
```

### Voting
```
hid-noded tx gov vote 1 yes --from $HS_WALLET --chain-id=$HS_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
hid-noded tx staking delegate $HS_VALOPER_ADDRESS 10000000uhid --from=$HS_WALLET --chain-id=$HS_ID --gas=auto --fees 250uhid
```

Redelegate from validator to another validator:
```
hid-noded tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uhid --from=$HS_WALLET --chain-id=$HS_ID --gas=auto --fees 250uhid
```

Withdraw all rewards:
```
hid-noded tx distribution withdraw-all-rewards --from=$HS_WALLET --chain-id=$HS_ID --gas=auto --fees 250uhid
```

Withdraw rewards with commission:
```
hid-noded tx distribution withdraw-rewards $HS_VALOPER_ADDRESS --from=$HS_WALLET --commission --chain-id=$HS_ID
```

### Validator Management
Change Validator Name:
```
hid-noded tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$HS_ID \
--from=$HS_WALLET
```

Get Out Of Jail(Unjail):
```
hid-noded tx slashing unjail \
  --broadcast-mode=block \
  --from=$HS_WALLET \
  --chain-id=$HS_ID \
  --gas=auto --fees 250uhid
```

To Delete Node Completely:
```
sudo systemctl stop hid-noded
sudo systemctl disable hid-noded
sudo rm /etc/systemd/system/hid-node* -rf
sudo rm $(which hid-noded) -rf
sudo rm $HOME/.hid-node* -rf
sudo rm $HOME/hid-node -rf
sed -i '/HS_/d' ~/.bash_profile
```
