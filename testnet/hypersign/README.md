## Chain explorer
[https://exp.nodeist.net/hypersign](https://exp.nodeist.net/Hypersign)

## Public endpoints

* api: [https://api-hypersign.nodeist.net](https://api-hypersign.nodeist.net)
* rpc: [https://rpc-hypersign.nodeist.net](https://rpc-hypersign.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/hypersign/addrbook.json > $HOME/.hid-node/config/addrbook.json
```

**live-peers**
```bash
peers="a275d8018f683f279bf5167a72d294bfacafa839@178.63.102.172:41656,23eff008c88dcc60ef9a71f2fb469c472679c35e@136.243.88.91:5040,934324c3b4318d8438954d19a82673a3d218951b@142.132.209.236:10956,e8e764fa9ecc5727038099205798520c547d7019@51.178.65.184:25656,ec5127072c252f7246fb66f7e7762423a23ff6bd@154.12.228.93:31656,d92268c246e02a54103f7098b901b876c88f006e@5.161.130.108:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:13156,d7c9b9a3c3a6c5f4ccdfb37a8358755b277271c1@3.110.226.164:26656,0c6758a3f4554bbc67da73993bbb697764c5c534@38.242.142.227:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.hid-node/config/config.toml
```
