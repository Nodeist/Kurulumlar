&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/lkac2p2.png)

# Terp Installation Guide
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

## Terp Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Terp fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O TERP.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Terp/TERP && chmod +x TERP.sh && ./TERP.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
terpd status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
terpd keys add $TERP_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
terpd keys add $TERP_WALLET --recover
```

To get the current wallet list:
```
terpd keys list
```

### Save Wallet Information
Add Wallet Address:
```
TERP_WALLET_ADDRESS=$(terpd keys show $TERP_WALLET -a)
TERP_VALOPER_ADDRESS=$(terpd keys show $TERP_WALLET --bech val -a)
echo 'export TERP_WALLET_ADDRESS='${TERP_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export TERP_VALOPER_ADDRESS='${TERP_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 terpx (1 terpx equals 1000000 uterpx) and your node is in sync.

To check your wallet balance:
```
terpd query bank balances $TERP_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
terpd tx staking create-validator \
  --amount 1000000uterpx \
  --from $TERP_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(terpd tendermint show-validator) \
  --moniker $TERP_NODENAME \
  --chain-id $TERP_ID \
  --fees 250uterpx
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu terpd -o cat
```

Start Service:
```
systemctl start terpd
```

Stop Service:
```
systemctl stop terpd
```

Restart Service:
```
systemctl restart terpd
```

### Node Information
Sync Information:
```
terpd status 2>&1 | jq .SyncInfo
```

Validator Information:
```
terpd status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
terpd status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
terpd tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
terpd keys list
```

Recover wallet using Mnemonic:
```
terpd keys add $TERP_WALLET --recover
```

Wallet Delete:
```
terpd keys delete $TERP_WALLET
```

Show Wallet Balance:
```
terpd query bank balances $TERP_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
terpd tx bank send $TERP_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uterpx
```

### Voting
```
terpd tx gov vote 1 yes --from $TERP_WALLET --chain-id=$TERP_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
terpd tx staking delegate $TERP_VALOPER_ADDRESS 10000000uterpx --from=$TERP_WALLET --chain-id=$TERP_ID --gas=auto --fees 250uterpx
```

Redelegate from validator to another validator:
```
terpd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uterpx --from=$TERP_WALLET --chain-id=$TERP_ID --gas=auto --fees 250uterpx
```

Withdraw all rewards:
```
terpd tx distribution withdraw-all-rewards --from=$TERP_WALLET --chain-id=$TERP_ID --gas=auto --fees 250uterpx
```

Withdraw rewards with commission:
```
terpd tx distribution withdraw-rewards $TERP_VALOPER_ADDRESS --from=$TERP_WALLET --commission --chain-id=$TERP_ID
```

### Validator Management
Change Validator Name:
```
terpd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$TERP_ID \
--from=$TERP_WALLET
```

Get Out Of Jail(Unjail):
```
terpd tx slashing unjail \
  --broadcast-mode=block \
  --from=$TERP_WALLET \
  --chain-id=$TERP_ID \
  --gas=auto --fees 250uterpx
```

To Delete Node Completely:
```
sudo systemctl stop terpd
sudo systemctl disable terpd
sudo rm /etc/systemd/system/terp* -rf
sudo rm $(which terpd) -rf
sudo rm $HOME/.terp* -rf
sudo rm $HOME/terp-core -rf
sed -i '/TERP_/d' ~/.bash_profile
```
