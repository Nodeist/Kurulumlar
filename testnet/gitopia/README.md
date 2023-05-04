## Chain explorer
[https://exp.nodeist.net/gitopia](https://exp.nodeist.net/gitopia)

## Public endpoints

* api: [https://api-gitopia.nodeist.net](https://api-gitopia.nodeist.net)
* rpc: [https://rpc-gitopia.nodeist.net](https://rpc-gitopia.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/gitopia/addrbook.json > $HOME/.gitopia/config/addrbook.json
```

**live-peers**
```bash
peers="93c4c73375b5f52020e7e7bd3f901ee28f07e6b7@109.123.243.66:41656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:14156,66f94651fb02f277c90c605a38df549d3c0a9269@75.119.151.217:26656,4e4f87cfa1993f4f3f7645c41f469987cafdf960@85.10.202.135:12656,619a23818cddd40d0b9f57e9754b719da13609bc@65.108.108.52:24656,5b1c25f4dff541f77f1532c457f73ca7ee2e4c18@194.163.170.225:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.gitopia/config/config.toml
```
