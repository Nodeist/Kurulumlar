&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/n5iirpq.png)

# Mande Installation Guide
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

## Mande Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Mande fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O MND.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Mande/MND && chmod +x MND.sh && ./MND.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
mande-chaind status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
mande-chaind keys add $MND_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
mande-chaind keys add $MND_WALLET --recover
```

To get the current wallet list:
```
mande-chaind keys list
```

### Save Wallet Information
Add Wallet Address:
```
MND_WALLET_ADDRESS=$(mande-chaind keys show $MND_WALLET -a)
MND_VALOPER_ADDRESS=$(mande-chaind keys show $MND_WALLET --bech val -a)
echo 'export MND_WALLET_ADDRESS='${MND_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export MND_VALOPER_ADDRESS='${MND_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 mand (1 mand equals 1000000 umand) and your node is in sync.

To check your wallet balance:
```
mande-chaind query bank balances $MND_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
mande-chaind tx staking create-validator \
  --amount 0cred \
  --from $MND_WALLET \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --pubkey  $(mande-chaind tendermint show-validator) \
  --moniker $MND_NODENAME \
  --chain-id $MND_ID
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu mande-chaind -o cat
```

Start Service:
```
systemctl start mande-chaind
```

Stop Service:
```
systemctl stop mande-chaind
```

Restart Service:
```
systemctl restart mande-chaind
```

### Node Information
Sync Information:
```
mande-chaind status 2>&1 | jq .SyncInfo
```

Validator Information:
```
mande-chaind status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
mande-chaind status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
mande-chaind tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
mande-chaind keys list
```

Recover wallet using Mnemonic:
```
mande-chaind keys add $MND_WALLET --recover
```

Wallet Delete:
```
mande-chaind keys delete $MND_WALLET
```

Show Wallet Balance:
```
mande-chaind query bank balances $MND_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
mande-chaind tx bank send $MND_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000umand
```

### Voting
```
mande-chaind tx gov vote 1 yes --from $MND_WALLET --chain-id=$MND_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
mande-chaind tx staking delegate $MND_VALOPER_ADDRESS 10000000umand --from=$MND_WALLET --chain-id=$MND_ID --gas=auto --fees 250umand
```

Redelegate from validator to another validator:
```
mande-chaind tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000umand --from=$MND_WALLET --chain-id=$MND_ID --gas=auto --fees 250umand
```

Withdraw all rewards:
```
mande-chaind tx distribution withdraw-all-rewards --from=$MND_WALLET --chain-id=$MND_ID --gas=auto --fees 250umand
```

Withdraw rewards with commission:
```
mande-chaind tx distribution withdraw-rewards $MND_VALOPER_ADDRESS --from=$MND_WALLET --commission --chain-id=$MND_ID
```

### Validator Management
Change Validator Name:
```
mande-chaind tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$MND_ID \
--from=$MND_WALLET
```

Get Out Of Jail(Unjail):
```
mande-chaind tx slashing unjail \
  --broadcast-mode=block \
  --from=$MND_WALLET \
  --chain-id=$MND_ID \
  --gas=auto --fees 250umand
```

To Delete Node Completely:
```
sudo systemctl stop mande-chaind
sudo systemctl disable mande-chaind
sudo rm /etc/systemd/system/mande-chaind* -rf
sudo rm $(which mande-chaind) -rf
sudo rm $HOME/.mande-chain* -rf
sed -i '/MND_/d' ~/.bash_profile
```
