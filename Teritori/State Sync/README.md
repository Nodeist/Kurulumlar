<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/teritori.png">
</p>


# Teritori State Sync
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
systemctl stop teritorid
teritorid tendermint unsafe-reset-all --home $HOME/.teritorid --keep-addr-book
SNAP_RPC="https://rpc-teritori.nodeist.net:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.teritorid/config/config.toml
```

The above `unsafe-reset-all` command reset your `wasm` folder inside the data folder. You can download our `wasm` folder to fix it.
```
rm -r ~/.teritorid/data/wasm
wget -O wasmonly.tar.lz4 https://snapshots.nodeist.net/teritori/wasmonly.tar.lz4 --inet4-only
lz4 -c -d wasmonly.tar.lz4  | tar -x -C $HOME/.teritorid/data
rm wasmonly.tar.lz4
```

Restart the node:
```
systemctl restart teritorid && journalctl -fu teritorid -o cat
```
