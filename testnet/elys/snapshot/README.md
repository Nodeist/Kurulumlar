## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop elysd
cp $HOME/.elys/data/priv_validator_state.json $HOME/.elys/priv_validator_state.json.backup
rm -rf $HOME/.elys/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/elys/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.elys --strip-components 2
mv $HOME/.elys/priv_validator_state.json.backup $HOME/.elys/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart elysd && sudo journalctl -u elysd -f --no-hostname -o cat
```
