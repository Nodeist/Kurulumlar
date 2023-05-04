## Chain explorer
[https://exp.nodeist.net/cardchain](https://exp.nodeist.net/cardchain)

## Public endpoints

* api: [https://api-cardchain.nodeist.net](https://api-cardchain.nodeist.net)
* rpc: [https://rpc-cardchain.nodeist.net](https://rpc-cardchain.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/cardchain/addrbook.json > $HOME/.Cardchain/config/addrbook.json
```

**live-peers**
```bash
peers="5f71d8b873cf04b8bf515569f2fcf4dd479f353b@161.97.89.239:27656,345d8149cbda76ae42142a78df7bbc90f5fc26f2@149.102.142.176:26656,99dcfbba34316285fceea8feb0b644c4dc67c53b@195.201.197.4:31656,b2897d1cf10082ffaa66390cbf3ec70df1b0426d@116.202.227.117:18656,d5fbf52331f8a8851557cd0eabf444850cef5646@135.181.133.16:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.Cardchain/config/config.toml
```
