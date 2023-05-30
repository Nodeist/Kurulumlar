## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop althea
cp $HOME/.althea/data/priv_validator_state.json $HOME/.althea/priv_validator_state.json.backup
althea tendermint unsafe-reset-all --home $HOME/.althea
```

### Get and configure the state sync information

```bash
SNAP_RPC="https://rpc-althea.nodeist.net:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.althea/config/config.toml

mv $HOME/.althea/priv_validator_state.json.backup $HOME/.althea/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart althea && sudo journalctl -u althea -f --no-hostname -o cat
```
