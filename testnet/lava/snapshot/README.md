## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop lavad
cp $HOME/.lava/data/priv_validator_state.json $HOME/.lava/priv_validator_state.json.backup
rm -rf $HOME/.lava/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/lava/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.lava --strip-components 2
mv $HOME/.lava/priv_validator_state.json.backup $HOME/.lava/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart lavad && sudo journalctl -u lavad -f --no-hostname -o cat
```
