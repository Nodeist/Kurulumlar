## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop Cardchaind
cp $HOME/.Cardchain/data/priv_validator_state.json $HOME/.Cardchain/priv_validator_state.json.backup
rm -rf $HOME/.Cardchain/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/cardchain/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.Cardchain --strip-components 2
mv $HOME/.Cardchain/priv_validator_state.json.backup $HOME/.Cardchain/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart Cardchaind && sudo journalctl -u Cardchaind -f --no-hostname -o cat
```
