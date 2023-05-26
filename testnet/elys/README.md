## Chain explorer
[https://exp.nodeist.net/elys](https://exp.nodeist.net/Elys)

## Public endpoints

* api: [https://api-elys.nodeist.net](https://api-elys.nodeist.net)
* rpc: [https://rpc-elys.nodeist.net](https://rpc-elys.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/elys/addrbook.json > $HOME/.elys/config/addrbook.json
```

**live-peers**
```bash
peers="0ea4e8352215aad85ff33a20a3bf4acf49070662@64.226.117.34:21956,fed5ba77a69a4e75f44588f794999e9ca0c6b440@45.67.217.22:21956,5f15c422f789fb7c1929f859006d43c27aa61ec0@31.220.84.183:27656,d9f2e28e398d42fe7ca8ed322ee168b3e867bc95@65.108.199.222:34656,5c2a752c9b1952dbed075c56c600c3a79b58c395@178.211.139.77:27296,a346d8325a9c3cd40e32236eb6de031d1a2d895e@95.217.107.96:26156,8dd419e6ed9117dbc793a1a59f7eca3d2c615fb3@65.109.157.236:60556,18842ea01d32c76aa7d1668a734ffbac231f1fe6@81.6.58.121:26656,3f30f68cb08e4dae5dd76c5ce77e6e1a15084346@212.95.51.215:56656,cdf9ae8529aa00e6e6703b28f3dcfdd37e07b27c@37.187.154.66:26656,89c4d6fa66c4e4517742e564cd6ba1532496fd43@65.108.108.52:32656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:15356,78aa6b222ae1f619bef03a9d98cb958dfcccc3a8@46.4.5.45:22056,8aa0021c45a64f736e2192f5e520c768bc9fbae2@46.101.132.190:26656,b06c8ad5bb82d577acd0060242e225980db88377@65.108.225.70:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.elys/config/config.toml
```
