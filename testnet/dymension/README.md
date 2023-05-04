## Chain explorer
[https://exp.nodeist.net/dymension](https://exp.nodeist.net/dymension)

## Public endpoints

* api: [https://api-dymension.nodeist.net](https://api-dymension.nodeist.net)
* rpc: [https://rpc-dymension.nodeist.net](https://rpc-dymension.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/dymension/addrbook.json > $HOME/.dymension/config/addrbook.json
```

**live-peers**
```bash
peers="e5226fa166386f9055908194a4942c06b7003ab5@65.108.192.123:42656,adf394846dc942b1fd03f6e310eda60b5eda7848@195.201.197.4:32656,8d5eac1042bac34cddd25d7601789fc03cb3f3a9@168.119.213.113:46656,96ffe4b68c3f97cbeae4b4362634bf1054c7aeeb@142.132.151.99:15658,802b8783727af8094d81f9cb0bf2ad9cc3d32aa0@193.46.243.144:26656,4d2ec1e61d61550fc5bfacc57e971ff9b6181152@135.181.180.29:26656,7f928378eecafe22fe1e93d9f63db181cec3f8a3@145.239.143.76:11256,8f84d324a2d266e612d06db4a793b0d001ee62a0@38.146.3.200:20556,44df333024cebe9b8e8361ac67feaa930ec6dc1f@65.109.85.170:54656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.dymension/config/config.toml
```
