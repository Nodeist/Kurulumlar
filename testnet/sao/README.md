## Chain explorer
[https://exp.nodeist.net/sao](https://exp.nodeist.net/Sao)

## Public endpoints

* api: [https://api-sao.nodeist.net](https://api-sao.nodeist.net)
* rpc: [https://rpc-sao.nodeist.net](https://rpc-sao.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/sao/addrbook.json > $HOME/.sao/config/addrbook.json
```

**live-peers**
```bash
peers="87aae9e66b092c79c6e5e1a7c64ec21128359f7e@144.76.97.251:37656,c6425d191599ad2ac0f6cddaf088df0fa5110c2f@65.108.78.101:26656,b8b0ad82927e46e480a18201b77cd716870d1511@46.101.132.190:26656,1ed54d64859edbfe8109155c0cf6bdb04e592cb6@142.132.248.253:65528,4245cbb64c958bb29a73048e37f8ccc68314b931@115.73.213.74:26656,4fa89d8492cdef5b7f887c4002b3df70d1283063@65.21.134.202:15756,a36a32d394005be2be4d49c998ff0d3e4768858f@8.214.46.204:26656,6940cf462e90af92828024d087d8ed0a7006d7ff@199.175.98.110:26656,5b1a021a6ed3274dc2c855490ad8fe45e03ace99@65.108.75.107:21656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.sao/config/config.toml
```
