<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/jackal.png">
</p>


# Jackal Live Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:37656,9b2bbd5121265ebbf9003341e8a2e0abdbc24b67@46.228.199.8:26656,5eedbfbe64b942f4ab54db3842acf3bfab034c24@161.97.74.88:46656,09d9127972ded9e22f9f11833ed7fcfa149cf1fa@65.109.92.240:19126,0394449cab5a29f24dd4f37683d3b7622f27c0fc@65.108.206.118:61156,94b63fddfc78230f51aeb7ac34b9fb86bd042a77@95.217.89.23:30567
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.canine/config/config.toml

```
