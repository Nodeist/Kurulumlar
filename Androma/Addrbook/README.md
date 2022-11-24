<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/androma.png">
</p>


# Addrbook for Androma

Sometimes node operators will face peering issues with the rest of the network. Often it can be solved with a good seed node or a list of stable persistent peers.

However, when everything else fails, you can choose to trust our `addrbook.json` file to bootstrap your node's connection with the network.

Stop your node, download and replace your `addrbook.json` with the steps below, and restart your node.


```
wget -O addrbook.json https://snapshots.nodeist.net/t/androma/addrbook.json --inet4-only
mv addrbook.json ~/.androma/config
```
