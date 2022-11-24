<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/realio.png">
</p>


# Realio Live Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=ab53d7f40ebfb8ce6131de2f8e9eaf1fc0c546cd@142.132.248.253:142.132.248.253:56656,14d9a7fe2a86fe429c66f8137ca49fb98f574a97@65.108.69.68:26959,1dcf307315f780d8287ce44c26fe57598bf51333@144.76.97.251:31656,15f4ad4ca9b2e48db810223a36ddd76b6d0745f0@51.83.35.216:51.83.35.216:26656,dfb576b6f9557938cfb9c33ca71c9759798d4c8b@65.109.17.86:65.109.17.86:39656,704eb376ec58ce6b4d1df7dfd7f0be7e79d5f200@65.108.142.47:26556,20385a897f7523a165ed9df444142d397f992a1f@65.21.170.3:65.21.170.3:37656,2539246ebf9359e2fbc9402f6af66520532e6169@134.209.165.247:26656,3bd4080934277762848e8bbd126d2eaccb7cbffc@135.181.20.30:135.181.20.30:46656,595e000363dad0f9d515b6150af394f21cdb03b7@38.242.221.64:38.242.221.64:35656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.realio-network/config/config.toml
```
