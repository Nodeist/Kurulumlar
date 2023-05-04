## Chain explorer
[https://exp.nodeist.net/bonusblock](https://exp.nodeist.net/bonusblock)

## Public endpoints

* api: [https://api-bonusblock.nodeist.net](https://api-bonusblock.nodeist.net)
* rpc: [https://rpc-bonusblock.nodeist.net](https://rpc-bonusblock.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/bonusblock/addrbook.json > $HOME/.bonusblock/config/addrbook.json
```

**live-peers**
```bash
peers="d1b0bc188408a7ea559ab083488f58dd51c1a6cc@144.91.66.143:29656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.bonusblock/config/config.toml
```
