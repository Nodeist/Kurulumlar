<p style="font-size:14px" align="right">
 100$ Free VPS for 2 Month <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Join Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Visit Our Website
</p>



<p align="center">
  <img height="100" src="https://i.hizliresim.com/7wxdkbj.jpeg">
</p>

# ClanNetwork Installation Guide
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

## Clan Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Clan fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O CLAN.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Clan/CLAN && chmod +x CLAN.sh && ./CLAN.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
cland status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
cland keys add $CLAN_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
cland keys add $CLAN_WALLET --recover
```

To get the current wallet list:
```
cland keys list
```

### Save Wallet Information
Add Wallet Address:
```
CLAN_WALLET_ADDRESS=$(cland keys show $CLAN_WALLET -a)
CLAN_VALOPER_ADDRESS=$(cland keys show $CLAN_WALLET --bech val -a)
echo 'export CLAN_WALLET_ADDRESS='${CLAN_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export CLAN_VALOPER_ADDRESS='${CLAN_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 clan (1 clan equals 1000000 uclan) and your node is in sync.

To check your wallet balance:
```
cland query bank balances $CLAN_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
cland tx staking create-validator \
  --amount 1000000uclan \
  --from $CLAN_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(cland tendermint show-validator) \
  --moniker $CLAN_NODENAME \
  --chain-id $CLAN_ID \
  --fees 250uclan
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu cland -o cat
```

Start Service:
```
systemctl start cland
```

Stop Service:
```
systemctl stop cland
```

Restart Service:
```
systemctl restart cland
```

### Node Information
Sync Information:
```
cland status 2>&1 | jq .SyncInfo
```

Validator Information:
```
cland status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
cland status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
cland tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
cland keys list
```

Recover wallet using Mnemonic:
```
cland keys add $CLAN_WALLET --recover
```

Wallet Delete:
```
cland keys delete $CLAN_WALLET
```

Show Wallet Balance:
```
cland query bank balances $CLAN_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
cland tx bank send $CLAN_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000uclan
```

### Voting
```
cland tx gov vote 1 yes --from $CLAN_WALLET --chain-id=$CLAN_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
cland tx staking delegate $CLAN_VALOPER_ADDRESS 10000000uclan --from=$CLAN_WALLET --chain-id=$CLAN_ID --gas=auto --fees 250uclan
```

Redelegate from validator to another validator:
```
cland tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uclan --from=$CLAN_WALLET --chain-id=$CLAN_ID --gas=auto --fees 250uclan
```

Withdraw all rewards:
```
cland tx distribution withdraw-all-rewards --from=$CLAN_WALLET --chain-id=$CLAN_ID --gas=auto --fees 250uclan
```

Withdraw rewards with commission:
```
cland tx distribution withdraw-rewards $CLAN_VALOPER_ADDRESS --from=$CLAN_WALLET --commission --chain-id=$CLAN_ID
```

### Validator Management
Change Validator Name:
```
cland tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$CLAN_ID \
--from=$CLAN_WALLET
```

Get Out Of Jail(Unjail): 
```
cland tx slashing unjail \
  --broadcast-mode=block \
  --from=$CLAN_WALLET \
  --chain-id=$CLAN_ID \
  --gas=auto --fees 250uclan
```

To Delete Node Completely:
```
sudo systemctl stop cland
sudo systemctl disable cland
sudo rm /etc/systemd/system/clan* -rf
sudo rm $(which cland) -rf
sudo rm $HOME/.clan* -rf
sudo rm $HOME/clan-network -rf
sed -i '/CLAN_/d' ~/.bash_profile
```
