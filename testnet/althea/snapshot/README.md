## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop althea
cp $HOME/.althea/data/priv_validator_state.json $HOME/.althea/priv_validator_state.json.backup
rm -rf $HOME/.althea/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/althea/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.althea --strip-components 2
mv $HOME/.althea/priv_validator_state.json.backup $HOME/.althea/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart althea && sudo journalctl -u althea -f --no-hostname -o cat
```
