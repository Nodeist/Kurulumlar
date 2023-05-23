## Chain explorer
[https://exp.nodeist.net/humans](https://exp.nodeist.net/humans)

## Public endpoints

* api: [https://api-humans.nodeist.net](https://api-humans.nodeist.net)
* rpc: [https://rpc-humans.nodeist.net](https://rpc-humans.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/humans/addrbook.json > $HOME/.humansd/config/addrbook.json
```

**live-peers**
```bash
peers="78dd8371dae4f081e76a32f9b5e90037737a341a@162.19.239.112:26656,9406c6184876b0678e7c5a705899437791a80ed7@136.243.88.91:7130,895b004f4d1ff0c353cb1bbc0a08e2ab13effccf@94.16.117.238:22656,c5b7f96ac776034107a7f7a546a2c065de081c09@89.58.19.91:26656,fa3cc9935503c3e8179b1eef1c1fde20e3354ca3@51.159.172.34:26656,9b3f1541f87cd52abb9cec0ef291bc228247f2a0@91.229.23.155:26656,14cad9ecd2b421c9035e52e5d779fbe84bddd134@65.109.82.112:2936,296c2d0589ada1e97a3959a069e23388877759ed@65.109.156.208:02656,a8502a57d8dedda0e08c6bdb892a64f41309b811@65.108.41.172:28456,cdf456fbe774e55aa794eeaa5280a78f1cf0738b@65.108.66.34:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.humansd/config/config.toml
```
