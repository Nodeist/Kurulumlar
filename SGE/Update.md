<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/sge.png">
</p>

```
sudo systemctl stop sged
cd $HOME && rm -rf sge
git clone https://github.com/sge-network/sge.git && cd sge
git checkout v0.0.2
make install
sudo systemctl restart sged && journalctl -fu sged -o cat
```
