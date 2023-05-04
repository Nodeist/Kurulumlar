## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop bonus-blockd
cp $HOME/.bonusblock/data/priv_validator_state.json $HOME/.bonusblock/priv_validator_state.json.backup
rm -rf $HOME/.bonusblock/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/bonusblock/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.bonusblock --strip-components 2
mv $HOME/.bonusblock/priv_validator_state.json.backup $HOME/.bonusblock/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart bonus-blockd && sudo journalctl -u bonus-blockd -f --no-hostname -o cat
```
