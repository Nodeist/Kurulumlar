## Chain explorer
[https://exp.nodeist.net/okp4](https://exp.nodeist.net/Okp4)

## Public endpoints

* api: [https://api-okp4.nodeist.net](https://api-okp4.nodeist.net)
* rpc: [https://rpc-okp4.nodeist.net](https://rpc-okp4.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/okp4/addrbook.json > $HOME/.okp4d/config/addrbook.json
```

**live-peers**
```bash
peers="d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:13656,8028015d1c6828a0b734f3b108f0853b0e19305e@157.90.176.184:26656,8cdeb85dada114c959c36bb59ce258c65ae3a09c@88.198.242.163:36656,42fbb917fca6787bc3ab774865f4bb1ef950f114@65.108.226.26:30656,78d923333e39e747c6a7fbfcc822ec6279990556@91.211.251.232:28656,d1c1b729eff9afe7dfd371f190df6282c82ccfad@65.109.89.5:31656,874373b78d2cd50e716aa464bf407581d9305655@94.250.201.130:27656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.okp4d/config/config.toml
```
