## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop routerd
cp $HOME/.routerd/data/priv_validator_state.json $HOME/.routerd/priv_validator_state.json.backup
rm -rf $HOME/.routerd/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/router/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.routerd --strip-components 2
mv $HOME/.routerd/priv_validator_state.json.backup $HOME/.routerd/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart routerd && sudo journalctl -u routerd -f --no-hostname -o cat
```
