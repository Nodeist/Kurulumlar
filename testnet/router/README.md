## Chain explorer
[https://exp.nodeist.net/router](https://exp.nodeist.net/Router)

## Public endpoints

* api: [https://api-router.nodeist.net](https://api-router.nodeist.net)
* rpc: [https://rpc-router.nodeist.net](https://rpc-router.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/router/addrbook.json > $HOME/.routerd/config/addrbook.json
```

**live-peers**
```bash
peers="2aa37da908789ecc7040102d2f31ddc3e143c782@13.233.136.29:26656,2bd1a4c4e355ff54fac0f92cab3b2e6d8adb1bc6@13.127.150.80:26656,1a1e29477e8f44bf9c989ac281b8dc6c6582bf9d@34.204.182.21:26656,569bd6846e80fae1d5b381e0a3a0725290d22884@43.204.133.101:26656,645f023b1f1fe36210d7c24ad0c0682f55f51416@65.2.161.80:26656,a8190578ef042021a55c740d262ba4fd275efd99@65.109.101.54:26656,17b33397e2c639e6f360af30c40353866dc5040f@47.245.25.38:26656,06952dd421e75835e8871de3f60507812156ea03@13.127.165.58:26656,af56b56b146d32a778b733aaed1fc6521f9eba95@95.214.55.138:11656,1c4907f615f850e6a2049ea0f69553e16d7dca2a@65.109.82.112:33756"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.routerd/config/config.toml
```
