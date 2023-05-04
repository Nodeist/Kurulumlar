## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop Cardchaind
cp $HOME/.Cardchain/data/priv_validator_state.json $HOME/.Cardchain/priv_validator_state.json.backup
Cardchaind tendermint unsafe-reset-all --home $HOME/.Cardchain
```

### Get and configure the state sync information

```bash
SNAP_RPC="https://rpc-cardchain.nodeist.net:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.Cardchain/config/config.toml

mv $HOME/.Cardchain/priv_validator_state.json.backup $HOME/.Cardchain/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart Cardchaind && sudo journalctl -u Cardchaind -f --no-hostname -o cat
```
