## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop hid-noded
cp $HOME/.hid-node/data/priv_validator_state.json $HOME/.hid-node/priv_validator_state.json.backup
hid-noded tendermint unsafe-reset-all --home $HOME/.hid-node
```

### Get and configure the state sync information

```bash
SNAP_RPC="https://rpc-hypersign.nodeist.net:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.hid-node/config/config.toml

mv $HOME/.hid-node/priv_validator_state.json.backup $HOME/.hid-node/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart hid-noded && sudo journalctl -u hid-noded -f --no-hostname -o cat
```
