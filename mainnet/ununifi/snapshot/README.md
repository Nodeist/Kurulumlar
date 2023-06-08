## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop ununifid
cp $HOME/.ununifi/data/priv_validator_state.json $HOME/.ununifi/priv_validator_state.json.backup
rm -rf $HOME/.ununifi/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/ununifi/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.ununifi --strip-components 2
mv $HOME/.ununifi/priv_validator_state.json.backup $HOME/.ununifi/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart ununifid && sudo journalctl -u ununifid -f --no-hostname -o cat
```
