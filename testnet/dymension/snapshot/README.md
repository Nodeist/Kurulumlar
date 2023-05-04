## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop dymd
cp $HOME/.dymension/data/priv_validator_state.json $HOME/.dymension/priv_validator_state.json.backup
rm -rf $HOME/.dymension/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/dymension/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.dymension --strip-components 2
mv $HOME/.dymension/priv_validator_state.json.backup $HOME/.dymension/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart dymd && sudo journalctl -u dymd -f --no-hostname -o cat
```
