## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop humansd
cp $HOME/.humansd/data/priv_validator_state.json $HOME/.humansd/priv_validator_state.json.backup
rm -rf $HOME/.humansd/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/humans/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.humansd --strip-components 2
mv $HOME/.humansd/priv_validator_state.json.backup $HOME/.humansd/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart humansd && sudo journalctl -u humansd -f --no-hostname -o cat
```
