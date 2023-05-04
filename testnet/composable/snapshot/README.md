## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop banksyd
cp $HOME/.banksy/data/priv_validator_state.json $HOME/.banksy/priv_validator_state.json.backup
rm -rf $HOME/.banksy/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/composable/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.banksy --strip-components 2
mv $HOME/.banksy/priv_validator_state.json.backup $HOME/.banksy/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart banksyd && sudo journalctl -u banksyd -f --no-hostname -o cat
```
