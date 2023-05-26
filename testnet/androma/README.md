## Chain explorer
[https://exp.nodeist.net/androma](https://exp.nodeist.net/Androma)

## Public endpoints

* api: [https://api-androma.nodeist.net](https://api-androma.nodeist.net)
* rpc: [https://rpc-androma.nodeist.net](https://rpc-androma.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/androma/addrbook.json > $HOME/.androma/config/addrbook.json
```

**live-peers**
```bash
peers="3410d8c308510223c1fc15a1bb33a0ba8d85a2e2@203.96.179.106:26656,6ca9cc12c3448b22fc51f8ba11eb62b7cb667f04@65.108.132.239:26856,db2a0a0cf06a4cdaf158bfc4919fa520ca02f7c4@135.181.116.109:27786,93ef47cee8857dc069d61404b64c0f1d18bf0b26@65.108.226.26:21656,83324c67e7ec69e249beaaef5d91cf0f1f5014ce@65.108.224.156:17656,f1e10a9358b84f86159c47bcdb74b663fc1f54ee@65.108.226.183:15056,152e12336f6b39ee9ce1bbb16edfe647ba4dd4d6@65.109.92.241:4176,fc6f7914e4beb4b5278e7ba32ec2abde97cd8082@65.109.28.177:26656,6dbdf310876528a45e0f094df1160439f33a1bcf@65.109.87.135:10656,76b1343da5f76dcbef3c50c49f2811eab95129cf@65.108.195.235:23656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.androma/config/config.toml
```
