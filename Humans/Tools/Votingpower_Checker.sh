#!/bin/bash
echo "=================================================="
echo "   _  ______  ___  __________________";
echo "  / |/ / __ \/ _ \/ __/  _/ __/_  __/";
echo " /    / /_/ / // / _/_/ /_\ \  / /   ";
echo "/_/|_/\____/____/___/___/___/ /_/    ";
echo -e "\e[0m"
echo "=================================================="                                     


sleep 2


set -e

vp=$(dewebd status | jq '.ValidatorInfo.VotingPower')
if [[ $vp = "0" ]]
then
	status="JAILED"
else
	status="OK"
fi

echo "Voting Power: ${vp} [${status}]"