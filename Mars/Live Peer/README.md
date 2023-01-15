cd /var/www/html/snap/t/mars/
du -h mars.tar.lz4 | tee -a /var/www/html/snap/t/mars/log.txt
cd

sleep 2

systemctl stop marsd
cd $HOME/cosmprund
./build/cosmprund prune ~/.mars/data
cd
tar -cf - $HOME/.mars/data | lz4 - /var/www/html/snap/t/mars/mars.tar.lz4 -f
sudo systemctl start marsd

rm -rf /var/www/html/snap/t/mars/log.txt
set -e
now_date() {
    echo -n $(TZ=":Europe/Moscow" date '+%d-%m-%Y')
}
log_this() {
    YEL='\033[1;33m' # yellow
    NC='\033[0m'     # No Color
    local logging="$@"
    printf "|$(now_date)| $logging\n" | tee -a /var/www/html/snap/t/mars/log.txt
}

LAST_BLOCK_HEIGHT=$(curl -s https://mars-testnet.nodejumper.io:443/status | jq -r .result.sync_info.latest_block_height)
log_this "LAST_BLOCK_HEIGHT ${LAST_BLOCK_HEIGHT}"
cd /var/www/html/snap/t/mars/
du -h mars.tar.lz4 | tee -a /var/www/html/snap/t/mars/log.txt
cd
