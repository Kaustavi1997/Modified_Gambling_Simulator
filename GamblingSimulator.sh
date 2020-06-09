#! /bin/bash -x

STAKE_PER_DAY=100
BET_PER_GAME=1

resultPerGame=-1
simulateOneGame(){
	WIN=1
	LOSE=0

	check=$((RANDOM%2))
	if [ $check -eq $WIN ];
	then
		resultPerGame=$BET_PER_GAME
	else
		resultPerGame=-$BET_PER_GAME
	fi
}
simulateOneGame
echo $resultPerGame
currentAmount=$STAKE_PER_DAY
read -p "Percentage of Stake:" s;
simulateOneDayTillResignHelper(){
	a=$(echo "$s / 100" | bc -l );
	percentageAmountOnStakePerDay=$(echo "$a * $STAKE_PER_DAY" | bc -l );
	intPercentageAmountOnStakePerDay=${percentageAmountOnStakePerDay%.*}
	lowerLimit=$(($STAKE_PER_DAY - $intPercentageAmountOnStakePerDay))
	upperLimit=$(($STAKE_PER_DAY + $intPercentageAmountOnStakePerDay))
	while [ $currentAmount -gt $lowerLimit -a $currentAmount -lt $upperLimit ]
	do
		simulateOneGame
		currentAmount=$(($currentAmount+$resultPerGame))
	done
}
simulateOneDayTillResign(){
	simulateOneDayTillResignHelper
	echo "Resign for the day"
	echo $currentAmount
}
simulateOneDayTillResign


