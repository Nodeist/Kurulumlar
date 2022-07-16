<p style="font-size:14px" align="right">
 100$ Free VPS for 2 Month <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Join Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Visit Our Website
</p>



<p align="center">
    <img height="100" src="https://i.hizliresim.com/qii2z30.jpeg">
</p>

# CrowdControl Installation Guide
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

## CrowdControl Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your CrowdControl fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O CC.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/CrowdControl/CC && chmod +x CC.sh && ./CC.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
Cardchain status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
Cardchain keys add $CC_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
Cardchain keys add $CC_WALLET --recover
```

To get the current wallet list:
```
Cardchain keys list
```

### Save Wallet Information
Add Wallet Address:
```
CC_WALLET_ADDRESS=$(Cardchain keys show $CC_WALLET -a)
CC_VALOPER_ADDRESS=$(Cardchain keys show $CC_WALLET --bech val -a)
echo 'export CC_WALLET_ADDRESS='${CC_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export CC_VALOPER_ADDRESS='${CC_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 bpf (1 bpf equals 1000000 ubpf) and your node is in sync.

To check your wallet balance:
```
Cardchain query bank balances $CC_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
Cardchain tx staking create-validator \
  --amount 1000000ubpf \
  --from $CC_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(Cardchain tendermint show-validator) \
  --moniker $CC_NODENAME \
  --chain-id $CC_ID \
  --fees 250ubpf
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu Cardchain -o cat
```

Start Service:
```
systemctl start Cardchain
```

Stop Service:
```
systemctl stop Cardchain
```

Restart Service:
```
systemctl restart Cardchain
```

### Node Information
Sync Information:
```
Cardchain status 2>&1 | jq .SyncInfo
```

Validator Information:
```
Cardchain status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
Cardchain status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
Cardchain tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
Cardchain keys list
```

Recover wallet using Mnemonic:
```
Cardchain keys add $CC_WALLET --recover
```

Wallet Delete:
```
Cardchain keys delete $CC_WALLET
```

Show Wallet Balance:
```
Cardchain query bank balances $CC_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
Cardchain tx bank send $CC_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ubpf
```

### Voting
```
Cardchain tx gov vote 1 yes --from $CC_WALLET --chain-id=$CC_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
Cardchain tx staking delegate $CC_VALOPER_ADDRESS 10000000ubpf --from=$CC_WALLET --chain-id=$CC_ID --gas=auto --fees 250ubpf
```

Redelegate from validator to another validator:
```
Cardchain tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ubpf --from=$CC_WALLET --chain-id=$CC_ID --gas=auto --fees 250ubpf
```

Withdraw all rewards:
```
Cardchain tx distribution withdraw-all-rewards --from=$CC_WALLET --chain-id=$CC_ID --gas=auto --fees 250ubpf
```

Withdraw rewards with commission:
```
Cardchain tx distribution withdraw-rewards $CC_VALOPER_ADDRESS --from=$CC_WALLET --commission --chain-id=$CC_ID
```

### Validator Management
Change Validator Name:
```
Cardchain tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$CC_ID \
--from=$CC_WALLET
```

Get Out Of Jail(Unjail): 
```
Cardchain tx slashing unjail \
  --broadcast-mode=block \
  --from=$CC_WALLET \
  --chain-id=$CC_ID \
  --gas=auto --fees 250ubpf
```

To Delete Node Completely:
```
sudo systemctl stop Cardchain
sudo systemctl disable Cardchain
sudo rm /etc/systemd/system/Cardchain* -rf
sudo rm $(which Cardchain) -rf
sudo rm $HOME/.Cardchain* -rf
sudo rm $HOME/Cardchain -rf
sed -i '/CC_/d' ~/.bash_profile
```
