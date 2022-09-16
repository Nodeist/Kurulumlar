#!/bin/bash
echo "=================================================="
echo "   _  ______  ___  __________________";
echo "  / |/ / __ \/ _ \/ __/  _/ __/_  __/";
echo " /    / /_/ / // / _/_/ /_\ \  / /   ";
echo "/_/|_/\____/____/___/___/___/ /_/    ";
echo -e "\e[0m"
echo "=================================================="                                     


sleep 2

############ SET PROPERTIES #########

ADDRESS="kujira13vyvwfc5es7wx723z5j0xtgagy4k42s60g9r63"
VALIDATOR="kujiravaloper13vyvwfc5es7wx723z5j0xtgagy4k42s6gaksx7"
KEY_NAME="wallet"
PASS="walletpass"
CHAIN_ID="kaiyo-1"
GAS_VALUE="auto"
#FEE_VALUE=""

############ AUTO DELEGATION #########

# Withdraw
while :
do
	echo $PASS | kujirad tx distribution withdraw-rewards "${VALIDATOR}"  --from "${KEY_NAME}" --commission --chain-id=${CHAIN_ID} --gas="${GAS_VALUE}" -y
	
	sleep 20s
	
	AVAILABLE_COIN=$(kujirad query bank balances ${ADDRESS} --output json | jq -r '.balances | map(select(.denom == "ukuji")) | .[].amount' | tr -cd [:digit:])
	KEEP_FOR_FEES=100000
	AMOUNT=$(($AVAILABLE_COIN - $KEEP_FOR_FEES))
	AMOUNT_FINAL=$AMOUNT"ukuji"
	
	
	# Delegate
	echo $PASS | kujirad tx staking delegate "${VALIDATOR}" "${AMOUNT_FINAL}" --from "${KEY_NAME}" --chain-id=${CHAIN_ID} -y
	date
	sleep 36000s
done;
