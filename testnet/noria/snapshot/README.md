## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop noriad
cp $HOME/.noria/data/priv_validator_state.json $HOME/.noria/priv_validator_state.json.backup
rm -rf $HOME/.noria/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/noria/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.noria --strip-components 2
mv $HOME/.noria/priv_validator_state.json.backup $HOME/.noria/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart noriad && sudo journalctl -u noriad -f --no-hostname -o cat
```
