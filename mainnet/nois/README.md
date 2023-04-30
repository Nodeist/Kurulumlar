## Chain explorer
[https://exp.nodeist.net/nois](https://exp.nodeist.net/nois)

## Public endpoints

* api: [https://api-nois.nodeist.net](https://api-nois.nodeist.net)
* rpc: [https://rpc-nois.nodeist.net](https://rpc-nois.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/nois/addrbook.json > $HOME/.noisd/config/addrbook.json
```

**live-peers**
```bash
peers="00852ba0bfdf20aac74369b1a5c43e50668c9738@135.181.128.114:17356,d2041f5d812b4fb196d5210a287448b68fe7bef9@95.217.104.49:51656,8ec2fee6c37c07cc5af57ec870015a0191d4707d@65.108.65.36:51656,ad53e98a88aa0c6f724b457ad6575b83c5f4a02b@167.235.15.19:30656,9d21af60ad2568ffcb55a0bd0eb03b6cfa2644c5@49.12.120.113:26656,374615fcb23cfbd30a59a2b904cf675d9b93b7e0@78.46.61.117:01656,497dff4750970f8d142c9c61da4acee0e3ff76c4@141.95.155.224:12156,288e7a14ccac3cdc1d8ab20335d4c48edf5930f2@84.46.250.136:17356,3784e5ecd7f703c8a37427463e9c7c7b31389345@142.132.211.91:51656,732fe2553e152d37b29653ee07324fdbfd5ef961@95.217.200.26:36656,379c0e32463be66e5cf8d13d62eb87ddb1a702c2@142.132.152.46:47656,1eef6409922688e5bf6f00891537552b9ba5540f@135.181.119.59:51656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.noisd/config/config.toml
```
