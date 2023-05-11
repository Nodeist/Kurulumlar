## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop ojod
cp $HOME/.ojo/data/priv_validator_state.json $HOME/.ojo/priv_validator_state.json.backup
rm -rf $HOME/.ojo/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/ojo/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.ojo --strip-components 2
mv $HOME/.ojo/priv_validator_state.json.backup $HOME/.ojo/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart ojod && sudo journalctl -u ojod -f --no-hostname -o cat
```
