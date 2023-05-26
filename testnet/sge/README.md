## Chain explorer
[https://exp.nodeist.net/sge](https://exp.nodeist.net/Sge)

## Public endpoints

* api: [https://api-sge.nodeist.net](https://api-sge.nodeist.net)
* rpc: [https://rpc-sge.nodeist.net](https://rpc-sge.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/sge/addrbook.json > $HOME/.sge/config/addrbook.json
```

**live-peers**
```bash
peers="62b76a24869829fb3be53c25891ba37eca5994bd@95.217.224.252:26656,b29612454715a6dc0d1f0c42b426bf30f1d27738@78.46.99.50:24656,14823c9230ac2eb50fd48b7313e8ddd4c13207c6@94.130.219.37:26000,cfa86646e5eb05e111e7dde27750ff8ebe67d165@89.117.56.126:23956,43b05a6bab7ca735397e9fae2cb0ad99977cf482@34.83.191.67:26656,ddcd5fda167e6b45208faed8fd7e2f0640b4185c@52.44.14.245:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.sge/config/config.toml
```
