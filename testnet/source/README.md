## Chain explorer
[https://exp.nodeist.net/source](https://exp.nodeist.net/Source)

## Public endpoints

* api: [https://api-source.nodeist.net](https://api-source.nodeist.net)
* rpc: [https://rpc-source.nodeist.net](https://rpc-source.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/source/addrbook.json > $HOME/.source/config/addrbook.json
```

**live-peers**
```bash
peers="cac254555deea35a70c821abd7f3e7db47a46d55@65.109.92.241:20056,5fb7f75e3a97fa0f936020b62daf1e67281f7f16@65.109.92.240:20056,db69700d8b0c277183ab1ec34d79a083c2578d32@65.21.145.209:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:12856,d960215e0788fcfc04b9e2e824e5751bf1efe7fc@65.108.82.152:26656,b24ae5d099d5564a227aa7b1a8278293b8db0cfa@185.255.131.27:26656,cba9a7c35b554596577e9708d405eb83b1f2a6d2@65.21.248.172:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.source/config/config.toml
```
