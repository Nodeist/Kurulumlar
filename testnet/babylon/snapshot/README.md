## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop babylond
cp $HOME/.babylond/data/priv_validator_state.json $HOME/.babylond/priv_validator_state.json.backup
rm -rf $HOME/.babylond/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/babylon/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.babylond --strip-components 2
mv $HOME/.babylond/priv_validator_state.json.backup $HOME/.babylond/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart babylond && sudo journalctl -u babylond -f --no-hostname -o cat
```
