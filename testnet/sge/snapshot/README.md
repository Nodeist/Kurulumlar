## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop sged
cp $HOME/.sge/data/priv_validator_state.json $HOME/.sge/priv_validator_state.json.backup
rm -rf $HOME/.sge/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/sge/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.sge --strip-components 2
mv $HOME/.sge/priv_validator_state.json.backup $HOME/.sge/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart sged && sudo journalctl -u sged -f --no-hostname -o cat
```
