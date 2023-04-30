## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop realio-networkd
cp $HOME/.realio-network/data/priv_validator_state.json $HOME/.realio-network/priv_validator_state.json.backup
rm -rf $HOME/.realio-network/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/realio/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.realio-network --strip-components 2
mv $HOME/.realio-network/priv_validator_state.json.backup $HOME/.realio-network/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl start realio-networkd && sudo journalctl -u realio-networkd -f --no-hostname -o cat
```
