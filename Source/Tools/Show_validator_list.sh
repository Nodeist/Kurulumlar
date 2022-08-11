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

sourced query staking validators -o json | \
jq .validators[] | \
jq -s 'sort_by(.tokens) | reverse' | \
jq -r '["Validator", "VP"], ["----------------", "------------"], (.[] | [.description.moniker, (.tokens|tonumber/1000000)]) | @tsv' | \
column -t -s "$(printf '\t')"