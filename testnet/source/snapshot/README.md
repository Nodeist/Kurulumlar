## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop sourced
cp $HOME/.source/data/priv_validator_state.json $HOME/.source/priv_validator_state.json.backup
rm -rf $HOME/.source/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/source/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.source --strip-components 2
mv $HOME/.source/priv_validator_state.json.backup $HOME/.source/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart sourced && sudo journalctl -u sourced -f --no-hostname -o cat
```
