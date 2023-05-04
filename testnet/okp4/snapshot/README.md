## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop okp4d
cp $HOME/.okp4d/data/priv_validator_state.json $HOME/.okp4d/priv_validator_state.json.backup
rm -rf $HOME/.okp4d/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/okp4/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.okp4d --strip-components 2
mv $HOME/.okp4d/priv_validator_state.json.backup $HOME/.okp4d/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart okp4d && sudo journalctl -u okp4d -f --no-hostname -o cat
```
