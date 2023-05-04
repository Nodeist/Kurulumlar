## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop cascadiad
cp $HOME/.cascadiad/data/priv_validator_state.json $HOME/.cascadiad/priv_validator_state.json.backup
rm -rf $HOME/.cascadiad/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/cascadia/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.cascadiad --strip-components 2
mv $HOME/.cascadiad/priv_validator_state.json.backup $HOME/.cascadiad/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart cascadiad && sudo journalctl -u cascadiad -f --no-hostname -o cat
```
