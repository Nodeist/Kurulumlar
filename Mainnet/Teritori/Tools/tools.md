<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/teritori.png">
</p>

# Teritori Useful Tools
## Always Vote No
Create a reusable shell script such as Always_Vote_No.sh with the following code and then run the script.
```
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

wallet="second" # your wallet name
current_proposal=$(teritorid q gov proposals -o json | jq -r '.proposals[] | select(.status == "PROPOSAL_STATUS_VOTING_PERIOD") | .proposal_id' | tail -n 1)

echo "Last proposal is: $current_proposal"

while true
do
  last_proposal=$(teritorid q gov proposals -o json | jq -r '.proposals[] | select(.status == "PROPOSAL_STATUS_VOTING_PERIOD") | .proposal_id' | tail -n 1)

  if [[ $current_proposal -lt $last_proposal ]]
  then
    echo "New proposal: $last_proposal"
    echo "Voting NO..."
    teritorid tx gov vote $last_proposal no --from $wallet -y

    current_proposal=$last_proposal
  fi

  sleep 2
done
```

## Always Vote Yes
Create a reusable shell script such as Always_Vote_Yes.sh with the following code and then run the script.
```
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

wallet="second" # your wallet name
current_proposal=$(teritorid q gov proposals -o json | jq -r '.proposals[] | select(.status == "PROPOSAL_STATUS_VOTING_PERIOD") | .proposal_id' | tail -n 1)

	echo "Last proposal is: $current_proposal"

	while true
	do
		last_proposal=$(teritorid q gov proposals -o json | jq -r '.proposals[] | select(.status == "PROPOSAL_STATUS_VOTING_PERIOD") | .proposal_id' | tail -n 1)

			if [[ $current_proposal -lt $last_proposal ]]
			then
				echo "New proposal: $last_proposal"
				echo "Voting YES..."
				teritorid tx gov vote $last_proposal yes --from $wallet -y

				current_proposal=$last_proposal
			fi

			sleep 2
		done
```

## Autostake
Create a reusable shell script such as Autostake.sh with the following code and then run the script.
```
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

ADDRESS="walletadress"
VALIDATOR="valoperadress"
KEY_NAME="walletname"
PASS="walletpass"
CHAIN_ID="chainid"
GAS_VALUE="auto"
#FEE_VALUE=""

############ AUTO DELEGATION #########

# Withdraw
while :
do
	echo $PASS | teritorid tx distribution withdraw-rewards "${VALIDATOR}"  --from "${KEY_NAME}" --commission --chain-id=${CHAIN_ID} --gas="${GAS_VALUE}" -y

	sleep 20s

	AVAILABLE_COIN=$(teritorid query bank balances ${ADDRESS} --output json | jq -r '.balances | map(select(.denom == "utori")) | .[].amount' | tr -cd [:digit:])
	KEEP_FOR_FEES=100000
	AMOUNT=$(($AVAILABLE_COIN - $KEEP_FOR_FEES))
	AMOUNT_FINAL=$AMOUNT"utori"


	# Delegate
	echo $PASS | teritorid tx staking delegate "${VALIDATOR}" "${AMOUNT_FINAL}" --from "${KEY_NAME}" --chain-id=${CHAIN_ID} -y
	date
	sleep 90s
done;
```

## Show Validator List
Create a reusable shell script such as Show_validator_list.sh with the following code and then run the script.
```
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

teritorid query staking validators -o json | \
jq .validators[] | \
jq -s 'sort_by(.tokens) | reverse' | \
jq -r '["Validator", "VP"], ["----------------", "------------"], (.[] | [.description.moniker, (.tokens|tonumber/1000000)]) | @tsv' | \
column -t -s "$(printf '\t')"
```


## Voting Power Checker
Create a reusable shell script such as Votingpower_Checker.sh with the following code and then run the script.
```
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

vp=$(teritorid status | jq '.ValidatorInfo.VotingPower')
if [[ $vp = "0" ]]
then
	status="JAILED"
else
	status="OK"
fi

echo "Voting Power: ${vp} [${status}]"
```
