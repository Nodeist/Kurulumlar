&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>

![](https://i.hizliresim.com/kitpt1x.png)


# Deweb Installation Guide
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

## Deweb Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Deweb fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O DWS.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Deweb/DWS && chmod +x DWS.sh && ./DWS.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
dewebd status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
dewebd keys add $DWS_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
dewebd keys add $DWS_WALLET --recover
```

To get the current wallet list:
```
dewebd keys list
```

### Save Wallet Information
Add Wallet Address:
```
DWS_WALLET_ADDRESS=$(dewebd keys show $DWS_WALLET -a)
DWS_VALOPER_ADDRESS=$(dewebd keys show $DWS_WALLET --bech val -a)
echo 'export DWS_WALLET_ADDRESS='${DWS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export DWS_VALOPER_ADDRESS='${DWS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 dws (1 dws equals 1000000 udws) and your node is in sync.

To check your wallet balance:
```
dewebd query bank balances $DWS_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
dewebd tx staking create-validator \
  --amount 1000000udws \
  --from $DWS_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(dewebd tendermint show-validator) \
  --moniker $DWS_NODENAME \
  --chain-id $DWS_ID \
  --fees 250udws
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu dewebd -o cat
```

Start Service:
```
systemctl start dewebd
```

Stop Service:
```
systemctl stop dewebd
```

Restart Service:
```
systemctl restart dewebd
```

### Node Information
Sync Information:
```
dewebd status 2>&1 | jq .SyncInfo
```

Validator Information:
```
dewebd status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
dewebd status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
dewebd tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
dewebd keys list
```

Recover wallet using Mnemonic:
```
dewebd keys add $DWS_WALLET --recover
```

Wallet Delete:
```
dewebd keys delete $DWS_WALLET
```

Show Wallet Balance:
```
dewebd query bank balances $DWS_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
dewebd tx bank send $DWS_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000udws
```

### Voting
```
dewebd tx gov vote 1 yes --from $DWS_WALLET --chain-id=$DWS_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
dewebd tx staking delegate $DWS_VALOPER_ADDRESS 10000000udws --from=$DWS_WALLET --chain-id=$DWS_ID --gas=auto --fees 250udws
```

Redelegate from validator to another validator:
```
dewebd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000udws --from=$DWS_WALLET --chain-id=$DWS_ID --gas=auto --fees 250udws
```

Withdraw all rewards:
```
dewebd tx distribution withdraw-all-rewards --from=$DWS_WALLET --chain-id=$DWS_ID --gas=auto --fees 250udws
```

Withdraw rewards with commission:
```
dewebd tx distribution withdraw-rewards $DWS_VALOPER_ADDRESS --from=$DWS_WALLET --commission --chain-id=$DWS_ID
```

### Validator Management
Change Validator Name:
```
dewebd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$DWS_ID \
--from=$DWS_WALLET
```

Get Out Of Jail(Unjail): 
```
dewebd tx slashing unjail \
  --broadcast-mode=block \
  --from=$DWS_WALLET \
  --chain-id=$DWS_ID \
  --gas=auto --fees 250udws
```

To Delete Node Completely:
```
sudo systemctl stop dewebd
sudo systemctl disable dewebd
sudo rm /etc/systemd/system/deweb* -rf
sudo rm $(which dewebd) -rf
sudo rm $HOME/.deweb* -rf
sudo rm $HOME/deweb -rf
sed -i '/DWS_/d' ~/.bash_profile
```
  