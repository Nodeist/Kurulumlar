## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop gitopiad
cp $HOME/.gitopia/data/priv_validator_state.json $HOME/.gitopia/priv_validator_state.json.backup
rm -rf $HOME/.gitopia/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/gitopia/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.gitopia --strip-components 2
mv $HOME/.gitopia/priv_validator_state.json.backup $HOME/.gitopia/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart gitopiad && sudo journalctl -u gitopiad -f --no-hostname -o cat
```
