## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop noisd
cp $HOME/.noisd/data/priv_validator_state.json $HOME/.noisd/priv_validator_state.json.backup
rm -rf $HOME/.noisd/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/nois/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.noisd --strip-components 2
mv $HOME/.noisd/priv_validator_state.json.backup $HOME/.noisd/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart noisd && sudo journalctl -u noisd -f --no-hostname -o cat
```
