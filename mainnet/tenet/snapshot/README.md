## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop tenetd
cp $HOME/.tenetd/data/priv_validator_state.json $HOME/.tenetd/priv_validator_state.json.backup
rm -rf $HOME/.tenetd/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/tenet/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.tenetd --strip-components 2
mv $HOME/.tenetd/priv_validator_state.json.backup $HOME/.tenetd/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart tenetd && sudo journalctl -u tenetd -f --no-hostname -o cat
```
