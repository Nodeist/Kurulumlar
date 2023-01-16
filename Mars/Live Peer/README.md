<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/mars.png">
</p>


# Mars Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
b60d9649dd154c169dcf08f47af7c1528c159818@104.248.41.168,7342199e80976b052d8506cc5a56d1f9a1cbb486@65.21.89.54:65.21.89.54:26653,719cf7e8f7640a48c782599475d4866b401f2d34@51.254.197.170,9847d03c789d9c87e84611ebc3d6df0e6123c0cc@91.194.30.203,cec7501f438e2700573cdd9d45e7fb5116ba74b9@176.9.51.55,fe8d614aa5899a97c11d0601ef50c3e7ce17d57b@65.108.233.109,e12bc490096d1b5f4026980f05a118c82e81df2a@85.17.6.142,6bf4d284761f63d9c609deb1cb37d74d43b6aca7@207.180.253.242,8f50c04195cc82d0da34e33cfeb0daa694b14479@65.108.105.48
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=b60d9649dd154c169dcf08f47af7c1528c159818@104.248.41.168,7342199e80976b052d8506cc5a56d1f9a1cbb486@65.21.89.54:65.21.89.54:26653,719cf7e8f7640a48c782599475d4866b401f2d34@51.254.197.170,9847d03c789d9c87e84611ebc3d6df0e6123c0cc@91.194.30.203,cec7501f438e2700573cdd9d45e7fb5116ba74b9@176.9.51.55,fe8d614aa5899a97c11d0601ef50c3e7ce17d57b@65.108.233.109,e12bc490096d1b5f4026980f05a118c82e81df2a@85.17.6.142,6bf4d284761f63d9c609deb1cb37d74d43b6aca7@207.180.253.242,8f50c04195cc82d0da34e33cfeb0daa694b14479@65.108.105.48
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.mars/config/config.toml
```
