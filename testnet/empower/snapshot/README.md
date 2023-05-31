## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop empowerd
cp $HOME/.empowerchain/data/priv_validator_state.json $HOME/.empowerchain/priv_validator_state.json.backup
rm -rf $HOME/.empowerchain/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/empower/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.empowerchain --strip-components 2
mv $HOME/.empowerchain/priv_validator_state.json.backup $HOME/.empowerchain/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart empowerd && sudo journalctl -u empowerd -f --no-hostname -o cat
```
