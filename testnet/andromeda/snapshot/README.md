## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop andromedad
cp $HOME/.andromedad/data/priv_validator_state.json $HOME/.andromedad/priv_validator_state.json.backup
rm -rf $HOME/.andromedad/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/andromeda/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.andromedad --strip-components 2
mv $HOME/.andromedad/priv_validator_state.json.backup $HOME/.andromedad/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart andromedad && sudo journalctl -u andromedad -f --no-hostname -o cat
```
