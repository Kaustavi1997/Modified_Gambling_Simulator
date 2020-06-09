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


