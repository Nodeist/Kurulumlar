echo "=================================================="
echo -e "\033[0;35m"
echo " | \ | |         | |    (_)   | |  ";
echo " |  \| | ___   __| | ___ _ ___| |_ ";
echo " |     |/ _ \ / _  |/ _ \ / __| __| ";
echo " | |\  | (_) | (_| |  __/ \__ \ |_ ";
echo " |_| \_|\___/ \__,_|\___|_|___/\__| ";
echo -e "\e[0m"
echo "=================================================="

sleep 2

sudo systemctl stop kujirad

kujirad tendermint unsafe-reset-all --home ~/.kujira/
SEEDS="2c0be5d48f1eb2ff7bd3e2a0b5b483835064b85a@95.216.7.241:41001,5a70fdcf1f51bb38920f655597ce5fc90b8b88b8@136.244.29.116:41656"
PEERS="9813378d0dceb86e57018bfdfbade9d863f6f3c8@3.38.73.119:26656,ccffabe81f2de8a81e171f93fe1209392bf9993f@65.108.234.59:26656,7878121e8fa201c836c8c0a95b6a9c7ac6e5b101@141.95.151.171:26656,0743497e30049ac8d59fee5b2ab3a49c3824b95c@198.244.200.196:26656,2efead362f0fc7b7fce0a64d05b56c5b28d5c2b4@164.92.209.72:36346,d24ee4b38c1ead082a7bcf8006617b640d3f5ab9@91.196.166.13:26656,5d0f0bc1c2d60f1d273165c5c8cefc3965c3d3c9@65.108.233.175:26656,35af92154fdb2ac19f3f010c26cca9e5c175d054@65.108.238.61:27656,e65c2e27ea06b795a25f3ce813ed2062371705b8@213.239.212.121:13656,f6d0d3ac0c748a343368705c37cf51140a95929b@146.59.81.204:36656,ecafd5cadaf3526a588550a7bc343ce2670c988d@185.16.39.231:26656,afc247bceddc0eeeb6cf62db6fb4f985b03dd3b0@65.108.74.21:26656,94b124a422113f1871c3ea750097842004e4a095@18.222.185.33:26656,3c6e0c7b8be14ccf1717d84f3c11dcc1d2bfcba9@65.108.232.149:30095,f709e13a7fbbd34afe000e5534bf024fc981a16b@65.108.76.242:31095,00d610b86d500740bd41c9db0955865680138fdb@5.9.98.56:32095,76b2b62f39d121c8248e6f61543c13830fd756af@77.68.22.110:26656,01d708d4124f30700c05c97947ae10231d8755f7@95.217.197.100:26655,45b9c4b982c8ecf0ab3a0fd3b28bcbe016a286f1@65.21.237.113:26656,635da0eabda2beea41af03f613c9ee242b81462d@52.54.117.83:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.kujira/config/config.toml

sudo systemctl restart kujirad && sudo journalctl -u kujirad -f -o cat
