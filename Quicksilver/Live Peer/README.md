<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/quicksilver.png">
</p>


# Quicksilver Live Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=884919e20a71dc0c632739f44275897f80725159@185.16.39.51:11656,2cc493c229a4cb972dc8588c09ee8981614a426c@144.76.67.53:2390,6c31ea769b18d7b20b2d738df7778fb9fc3fc380@18.236.225.32:26656,4ccdccd18a480f13af85aa798356c1bf856f5c20@88.208.57.200:11656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.quicksilverd/config/config.toml
```
