&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)



### Minimum Hardware Requirements
- 2x CPU; the higher the clock speed the better
- 4GB of RAM
- 50GB Disk
- Persistent Internet connection (traffic will be minimal during testnet; 10Mbps - at least 100Mbps expected for production)

# Setup

```
wget -O Nodeistsui.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Sui/Nodeistsui.sh && chmod +x Nodeistsui.sh && ./Nodeistsui.sh
```


# Post-Installation Steps
### Check the status of your node:
```
curl -s -X POST http://127.0.0.1:9000 -H 'Content-Type: application/json' -d '{ "jsonrpc":"2.0", "method":"rpc.discover","id":1}' | jq .result.info
```


The result should be similar to this:
```
{
"title": "Sui JSON-RPC",
"description": "Sui JSON-RPC API for interaction with the Sui network gateway.",
"contact": {
"name": "Mysten Labs",
"url": "https://mystenlabs.com",
"email": "build@mystenlabs.com"
},
"license": {
"name": "Apache-2.0",
"url": "https://raw.githubusercontent.com/MystenLabs/sui/main/LICENSE"
},
"version": "0.1.0"
}
```


Get information about the 5 most recent transactions:
```
curl --location --request POST 'http://127.0.0.1:9000/' --header 'Content-Type: application/json' \
--data-raw '{ "jsonrpc":"2.0", "id":1, "method":"sui_getRecentTransactions", "params":[5] }' | jq .
```

Get details about the specified action:
```
curl --location --request POST 'http://127.0.0.1:9000/' --header 'Content-Type: application/json' \
--data-raw '{ "jsonrpc":"2.0", "id":1, "method":"sui_getTransaction", "params":["<RECENT_TXN_FROM_ABOVE>"] }' | jq .
```

## Post install
After installing your sui node you need to register it in [Sui Discord](https://discord.gg/yYZpFJ5DQC):
1) Go to `#📋node-ip-application` channel
2) Submit your node endpoint url
```
http://<YOUR_NODE_IP>:9000/
```

## Check your node health
Enter your node IP at https://node.sui.zvalid.com/

The healthy node should look like this:
![image](https://i.hizliresim.com/qs9m96i.png)

## Create wallet
```
echo -e "y\n" | sui client
```
> !Please backup your wallet key files located in the `$HOME/.sui/sui_config/` directory!

## Fund your wallet
1. Get your wallet address:
```
sui client active-address
```

2. Go to [Sui Discord](https://discord.gg/sui) `#devnet-faucet` and fund your wallet
```
!faucet <WALLETADRESS>
```

Check your balance at:
```
https://explorer.devnet.sui.io/addresses/<WALLETADDRESS>
```


## Operations with objects
### Merge two objects into one object
```
JSON=$(sui client gas --json | jq -r)
FIRST_OBJECT_ID=$(sui client gas --json | jq -r .[0].id.id)
SECOND_OBJECT_ID=$(sui client gas --json | jq -r .[1].id.id)
sui client merge-coin --primary-coin ${FIRST_OBJECT_ID} --coin-to-merge ${SECOND_OBJECT_ID} --gas-budget 1000
```

You should see the output like this:
```
----- Certificate ----
Transaction Hash: t3BscscUH2tMnMRfzYyc4Nr9HZ65nXuaL87BicUwXVo=
Transaction Signature: OCIYOWRPLSwpLG0bAmDTMixvE3IcyJgcRM5TEXJAOWvDv1xDmPxm99qQEJJQb0iwCgEfDBl74Q3XI6yD+AK7BQ==@U6zbX7hNmQ0SeZMheEKgPQVGVmdE5ikRQZIeDKFXwt8=
Signed Authorities Bitmap: RoaringBitmap<[0, 2, 3]>
Transaction Kind : Call
Package ID : 0x2
Module : coin
Function : join
Arguments : ["0x530720be83c5e8dffde5f602d2f36e467a24f6de", "0xb66106ac8bc9bf8ec58a5949da934febc6d7837c"]
Type Arguments : ["0x2::sui::SUI"]
----- Merge Coin Results ----
Updated Coin : Coin { id: 0x530720be83c5e8dffde5f602d2f36e467a24f6de, value: 100000 }
Updated Gas : Coin { id: 0xc0a3fa96f8e52395fa659756a6821c209428b3d9, value: 49560 }
```

Let's check the list of objects:
```
sui client gas
```

>This is just one of the actions that can be done at this time. Other examples can be found on the [official website](https://docs.sui.io/build/wallet).

## Useful commands for sui fullnode
Check custom node status
```
docker ps -a
```

Check the node logs
```
docker logs -f sui-fullnode-1 --tail 50
```

To delete the node
```
cd $HOME/sui && docker-compose down --volumes
cd $HOME && rm -rf sui
```

## useful commands for sui
Check sui version
```
sui --version
```

Update sui version
```
wget -qO Update.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Sui/Tools/Update.sh && chmod +x Update.sh && ./Update.sh
```

## Recover your keys
Copy your keys to `$HOME/.sui/sui_config/` and restart node

## Delete your node
```
rm -rf /usr/local/bin/{sui,sui-node,sui-faucet} 
cd $HOME/.sui && docker-compose down --volumes 
cd $HOME && rm -rf .sui
```


### Node Logs:
```
journalctl -u suid -f -o cat
```

### Restart Node:
```
sudo systemctl restart suid
```

### Stop Node:
```
sudo systemctl stop suid
```

### Delete Node:
```
sudo systemctl stop suid
sudo systemctl disable suid
rm -rf ~/sui /var/sui/
rm /etc/systemd/suid.service
```
