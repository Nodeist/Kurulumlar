## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop elysd
cp $HOME/.elys/data/priv_validator_state.json $HOME/.elys/priv_validator_state.json.backup
elysd tendermint unsafe-reset-all --home $HOME/.elys
```

### Get and configure the state sync information

```bash
SNAP_RPC="https://rpc-elys.nodeist.net:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.elys/config/config.toml

mv $HOME/.elys/priv_validator_state.json.backup $HOME/.elys/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart elysd && sudo journalctl -u elysd -f --no-hostname -o cat
```
