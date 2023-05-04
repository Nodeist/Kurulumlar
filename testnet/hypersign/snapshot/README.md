## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop hid-noded
cp $HOME/.hid-node/data/priv_validator_state.json $HOME/.hid-node/priv_validator_state.json.backup
rm -rf $HOME/.hid-node/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/hypersign/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.hid-node --strip-components 2
mv $HOME/.hid-node/priv_validator_state.json.backup $HOME/.hid-node/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart hid-noded && sudo journalctl -u hid-noded -f --no-hostname -o cat
```
