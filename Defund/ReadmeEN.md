&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>

![](https://i.hizliresim.com/4mmj0u4.png)


# Defund Installation Guide
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

## Defund Full Node Installation Steps
### Automatic Installation with a Single Script
You can set up your Defund fullnode in a few minutes using the automated script below.
You will be asked for your node name (NODENAME) during the script!

```
wget -O FETF.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Defund/FETF && chmod +x FETF.sh && ./FETF.sh
```

### Post-Installation Steps

You should make sure your validator syncs blocks.
You can use the following command to check the sync status.
```
defundd status 2>&1 | jq .SyncInfo
```

### Creating a Wallet
You can use the following command to create a new wallet. Do not forget to save the reminder (mnemonic).
```
defundd keys add $FETF_WALLET
```

(OPTIONAL) To recover your wallet using mnemonic:
```
defundd keys add $FETF_WALLET --recover
```

To get the current wallet list:
```
defundd keys list
```

### Save Wallet Information
Add Wallet Address:
```
FETF_WALLET_ADDRESS=$(defundd keys show $FETF_WALLET -a)
FETF_VALOPER_ADDRESS=$(defundd keys show $FETF_WALLET --bech val -a)
echo 'export FETF_WALLET_ADDRESS='${FETF_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export FETF_VALOPER_ADDRESS='${FETF_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Create validator
Before creating a validator please make sure you have at least 1 fetf (1 fetf equals 1000000 ufetf) and your node is in sync.

To check your wallet balance:
```
defundd query bank balances $FETF_WALLET_ADDRESS
```
> If you can't see your balance in your wallet, chances are your node is still syncing. Please wait for the sync to finish and then continue.

Creating a Validator:
```
defundd tx staking create-validator \
  --amount 1000000ufetf \
  --from $FETF_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(defundd tendermint show-validator) \
  --moniker $FETF_NODENAME \
  --chain-id $FETF_ID \
  --fees 250ufetf
```



## Useful Commands
### Service Management
Check Logs:
```
journalctl -fu defundd -o cat
```

Start Service:
```
systemctl start defundd
```

Stop Service:
```
systemctl stop defundd
```

Restart Service:
```
systemctl restart defundd
```

### Node Information
Sync Information:
```
defundd status 2>&1 | jq .SyncInfo
```

Validator Information:
```
defundd status 2>&1 | jq .ValidatorInfo
```

Node Information:
```
defundd status 2>&1 | jq .NodeInfo
```

Show Node ID:
```
defundd tendermint show-node-id
```

### Wallet Transactions
List Wallets:
```
defundd keys list
```

Recover wallet using Mnemonic:
```
defundd keys add $FETF_WALLET --recover
```

Wallet Delete:
```
defundd keys delete $FETF_WALLET
```

Show Wallet Balance:
```
defundd query bank balances $FETF_WALLET_ADDRESS
```

Cüzdandan Cüzdana Bakiye Transferi:
```
defundd tx bank send $FETF_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000ufetf
```

### Voting
```
defundd tx gov vote 1 yes --from $FETF_WALLET --chain-id=$FETF_ID
```

### Stake, Delegation and Rewards
Delegate Process:
```
defundd tx staking delegate $FETF_VALOPER_ADDRESS 10000000ufetf --from=$FETF_WALLET --chain-id=$FETF_ID --gas=auto --fees 250ufetf
```

Redelegate from validator to another validator:
```
defundd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ufetf --from=$FETF_WALLET --chain-id=$FETF_ID --gas=auto --fees 250ufetf
```

Withdraw all rewards:
```
defundd tx distribution withdraw-all-rewards --from=$FETF_WALLET --chain-id=$FETF_ID --gas=auto --fees 250ufetf
```

Withdraw rewards with commission:
```
defundd tx distribution withdraw-rewards $FETF_VALOPER_ADDRESS --from=$FETF_WALLET --commission --chain-id=$FETF_ID
```

### Validator Management
Change Validator Name:
```
defundd tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$FETF_ID \
--from=$FETF_WALLET
```

Get Out Of Jail(Unjail): 
```
defundd tx slashing unjail \
  --broadcast-mode=block \
  --from=$FETF_WALLET \
  --chain-id=$FETF_ID \
  --gas=auto --fees 250ufetf
```

To Delete Node Completely:
```
sudo systemctl stop defundd
sudo systemctl disable defundd
sudo rm /etc/systemd/system/anone* -rf
sudo rm $(which defundd) -rf
sudo rm $HOME/.anone* -rf
sudo rm $HOME/anone -rf
sed -i '/FETF_/d' ~/.bash_profile
```
  