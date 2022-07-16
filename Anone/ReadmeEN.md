<p style="font-size:14px" align="right">
 100$ Free VPS for 2 Month <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Join Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Visit Our Website
</p>



<p align="center">
  <img height="100" src="https://i.hizliresim.com/cdpen5h.png">
</p>

# Another-1 Installation Guide
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

## Anone Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Anone fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O ANONE.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Anone/ANONE && chmod +x ANONE.sh && ./ANONE.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
anoned status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
anoned keys add $ANONE_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
anoned keys add $ANONE_WALLET --recover
```

To get the current wallet list:
```
anoned keys list
```

### Save Wallet Information
Add Wallet Address:
```
ANONE_WALLET_ADDRESS=$(anoned keys show $ANONE_WALLET -a)
ANONE_VALOPER_ADDRESS=$(anoned keys show $ANONE_WALLET --bech val -a)
echo 'export ANONE_WALLET_ADDRESS='${ANONE_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export ANONE_VALOPER_ADDRESS='${ANONE_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 an1 (1 an1 equals 1000000 uan1) and your node is in sync.

To check your wallet balance:
```
anoned query bank balances $ANONE_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
anoned tx staking create-validator \
  --amount 1000000uan1 \
  --from $ANONE_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(anoned tendermint show-validator) \
  --moniker $ANONE_NODENAME \
  --chain-id $ANONE_ID \
  --fees 250uan1
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu anoned -o cat
```

Start Service:
```
systemctl start anoned
```

Stop Service:
```
systemctl stop anoned
```

Restart Service:
```
systemctl restart anoned
```

### Node Information
Sync Information:
```
anoned status 2>&1 | jq .SyncInfo
```

Validator Information:
```
anoned status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
anoned status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
anoned tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
anoned keys list
```

Recover wallet using Mnemonic:
```
anoned keys add $ANONE_WALLET --recover
```

Wallet Delete:
```
anoned keys delete $ANONE_WALLET
```

Show Wallet Balance:
```
anoned query bank balances $ANONE_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
anoned tx bank send $ANONE_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uan1
```

### Voting
```
anoned tx gov vote 1 yes --from $ANONE_WALLET --chain-id=$ANONE_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
anoned tx staking delegate $ANONE_VALOPER_ADDRESS 10000000uan1 --from=$ANONE_WALLET --chain-id=$ANONE_ID --gas=auto --fees 250uan1
```

Redelegate from validator to another validator:
```
anoned tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uan1 --from=$ANONE_WALLET --chain-id=$ANONE_ID --gas=auto --fees 250uan1
```

Withdraw all rewards:
```
anoned tx distribution withdraw-all-rewards --from=$ANONE_WALLET --chain-id=$ANONE_ID --gas=auto --fees 250uan1
```

Withdraw rewards with commission:
```
anoned tx distribution withdraw-rewards $ANONE_VALOPER_ADDRESS --from=$ANONE_WALLET --commission --chain-id=$ANONE_ID
```

### Validator Management
Change Validator Name:
```
anoned tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$ANONE_ID \
--from=$ANONE_WALLET
```

Get Out Of Jail(Unjail): 
```
anoned tx slashing unjail \
  --broadcast-mode=block \
  --from=$ANONE_WALLET \
  --chain-id=$ANONE_ID \
  --gas=auto --fees 250uan1
```

To Delete Node Completely:
```
sudo systemctl stop anoned
sudo systemctl disable anoned
sudo rm /etc/systemd/system/anone* -rf
sudo rm $(which anoned) -rf
sudo rm $HOME/.anone* -rf
sudo rm $HOME/anone -rf
sed -i '/ANONE_/d' ~/.bash_profile
```
