## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop blockxd
cp $HOME/.blockxd/data/priv_validator_state.json $HOME/.blockxd/priv_validator_state.json.backup
rm -rf $HOME/.blockxd/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/blockx/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.blockxd --strip-components 2
mv $HOME/.blockxd/priv_validator_state.json.backup $HOME/.blockxd/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart blockxd && sudo journalctl -u blockxd -f --no-hostname -o cat
```
