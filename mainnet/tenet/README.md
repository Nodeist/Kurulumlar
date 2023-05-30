## Chain explorer
[https://exp.nodeist.net/tenet](https://exp.nodeist.net/Tenet)

## Public endpoints

* api: [https://api-tenet.nodeist.net](https://api-tenet.nodeist.net)
* rpc: [https://rpc-tenet.nodeist.net](https://rpc-tenet.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/tenet/addrbook.json > $HOME/.tenetd/config/addrbook.json
```

**live-peers**
```bash
peers="f648944b0da4613caca6426064ec740586a74ddc@157.90.36.48:27166,73663dda0862b32b406a1fbc082e7023bd83e25c@176.9.54.69:26656,9e6d9040cd29e16287c66eab64dd1da92c231d95@164.90.188.179:26656,bfac3f303430ffa520f7a7592b95357a47050ba2@209.38.244.11:26656,89757803f40da51678451735445ad40d5b15e059@134.65.192.54:26656,1a2971826f68be094eae5cc4f19c71a11736cb84@172.104.238.109:26656,31f37574cd759bff7789080c4cb01dbb9cffef9a@162.19.234.110:26656,92e8534db088c30c25b320b08c44b8c3d8098722@57.128.96.155:22456,cd45ac92164ceb542b556aa845916fba5df9c3fa@161.35.83.28:26656,9054705b4c58a9ba7853a3e43ee1f0cf900b4bfb@144.126.236.41:26656,f8432cc5094870c96f34a0ebb36ffb0d38a53ad4@164.92.209.223:26656,ca9244bb137b8445be55e871b55d4ec0a2d5749c@174.138.63.156:26656,af771137a0ec5f3699ad09a4c3bedf1603655776@45.33.69.112:26656,99a16873ea23d8262817340c6110f8b44f8294fd@18.188.170.181:31320,6cceba286b498d4a1931f85e35ea0fa433373057@169.155.170.17:26656,79d85e533ed411e5c227ec91ec382560b35855a6@137.184.180.148:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.tenetd/config/config.toml
```
