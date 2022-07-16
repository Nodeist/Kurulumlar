<p style="font-size:14px" align="right">
 100$ Free VPS for 2 Month <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Join Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Visit Our Website
</p>



<p align="center">
  <img height="100" src="https://i.hizliresim.com/5oh0erz.png">
</p>

# Celestia Installation Guide
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

## Celestia Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Celestia fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O TIA.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Celestia/TIA && chmod +x TIA.sh && ./TIA.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
celestia-appd status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
celestia-appd keys add $TIA_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
celestia-appd keys add $TIA_WALLET --recover
```

To get the current wallet list:
```
celestia-appd keys list
```

### Save Wallet Information
Add Wallet Address:
```
TIA_WALLET_ADDRESS=$(celestia-appd keys show $TIA_WALLET -a)
TIA_VALOPER_ADDRESS=$(celestia-appd keys show $TIA_WALLET --bech val -a)
echo 'export TIA_WALLET_ADDRESS='${TIA_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export TIA_VALOPER_ADDRESS='${TIA_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 tia (1 tia equals 1000000 utia) and your node is in sync.

To check your wallet balance:
```
celestia-appd query bank balances $TIA_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
celestia-appd tx staking create-validator \
  --amount 1000000utia \
  --from $TIA_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(celestia-appd tendermint show-validator) \
  --moniker $TIA_NODENAME \
  --chain-id $TIA_ID \
  --fees 250utia
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu celestia-appd -o cat
```

Start Service:
```
systemctl start celestia-appd
```

Stop Service:
```
systemctl stop celestia-appd
```

Restart Service:
```
systemctl restart celestia-appd
```

### Node Information
Sync Information:
```
celestia-appd status 2>&1 | jq .SyncInfo
```

Validator Information:
```
celestia-appd status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
celestia-appd status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
celestia-appd tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
celestia-appd keys list
```

Recover wallet using Mnemonic:
```
celestia-appd keys add $TIA_WALLET --recover
```

Wallet Delete:
```
celestia-appd keys delete $TIA_WALLET
```

Show Wallet Balance:
```
celestia-appd query bank balances $TIA_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
celestia-appd tx bank send $TIA_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000utia
```

### Voting
```
celestia-appd tx gov vote 1 yes --from $TIA_WALLET --chain-id=$TIA_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
celestia-appd tx staking delegate $TIA_VALOPER_ADDRESS 10000000utia --from=$TIA_WALLET --chain-id=$TIA_ID --gas=auto --fees 250utia
```

Redelegate from validator to another validator:
```
celestia-appd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utia --from=$TIA_WALLET --chain-id=$TIA_ID --gas=auto --fees 250utia
```

Withdraw all rewards:
```
celestia-appd tx distribution withdraw-all-rewards --from=$TIA_WALLET --chain-id=$TIA_ID --gas=auto --fees 250utia
```

Withdraw rewards with commission:
```
celestia-appd tx distribution withdraw-rewards $TIA_VALOPER_ADDRESS --from=$TIA_WALLET --commission --chain-id=$TIA_ID
```

### Verifier Management
Change Validator Name:
```
celestia-appd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$TIA_ID \
--from=$TIA_WALLET
```

Get Out Of Jail(Unjail): 
```
celestia-appd tx slashing unjail \
  --broadcast-mode=block \
  --from=$TIA_WALLET \
  --chain-id=$TIA_ID \
  --gas=auto --fees 250utia
```

To Delete Node Completely:
```
sudo systemctl stop celestia-appd
sudo systemctl disable celestia-appd
sudo rm /etc/systemd/system/anone* -rf
sudo rm $(which celestia-appd) -rf
sudo rm $HOME/.anone* -rf
sudo rm $HOME/anone -rf
sed -i '/TIA_/d' ~/.bash_profile
```
