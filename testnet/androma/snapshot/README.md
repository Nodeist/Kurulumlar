## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop andromad
cp $HOME/.androma/data/priv_validator_state.json $HOME/.androma/priv_validator_state.json.backup
rm -rf $HOME/.androma/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/androma/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.androma --strip-components 2
mv $HOME/.androma/priv_validator_state.json.backup $HOME/.androma/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart andromad && sudo journalctl -u andromad -f --no-hostname -o cat
```
