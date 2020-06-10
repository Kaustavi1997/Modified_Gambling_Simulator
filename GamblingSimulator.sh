#! /bin/bash 

STAKE_PER_DAY=100
BET_PER_GAME=1
DAYS_PER_MONTH=20

resultPerGame=-1
totalWin=0
totalLose=0
betForAGame(){
	
	WIN=1

	check=$((RANDOM%2))
	if [ $check -eq $WIN ];
	then
		resultPerGame=$BET_PER_GAME
	else
		resultPerGame=-$BET_PER_GAME
	fi
}
echo $resultPerGame
percentageCalculation(){
	a=$(echo "$s / 100" | bc -l );
	percentageAmountOnStakePerDay=$(echo "$a * $STAKE_PER_DAY" | bc -l );
	intPercentageAmountOnStakePerDay=${percentageAmountOnStakePerDay%.*}
	lowerLimit=$(($STAKE_PER_DAY - $intPercentageAmountOnStakePerDay))
	upperLimit=$(($STAKE_PER_DAY + $intPercentageAmountOnStakePerDay))
}
currentAmount=$STAKE_PER_DAY
read -p "Percentage of Stake:" s;
betForOneDayHelper(){
	percentageCalculation
	while [ $currentAmount -gt $lowerLimit -a $currentAmount -lt $upperLimit ]
	do
		betForAGame
		currentAmount=$(($currentAmount+$resultPerGame))
	done
}
betForOneDay(){
	betForOneDayHelper
	echo "Resign for the day"
	echo $currentAmount
}
betForOneDay


betTwentyDaysHelper(){
	
	
	for (( i=0; i<DAYS_PER_MONTH; i++ ))
	do
		currentAmount=$STAKE_PER_DAY
		betForOneDayHelper
		if [ $currentAmount -gt $STAKE_PER_DAY ]
		then
			winAmountPerDay=$(($currentAmount - $STAKE_PER_DAY))
			totalWin=$(($totalWin + $winAmountPerDay))
		else
			loseAmountPerDay=$(($STAKE_PER_DAY-$currentAmount))
			totalLose=$(($totalLose + $loseAmountPerDay))
		fi
	done
}

betTwentyDays(){
	betTwentyDaysHelper
	echo $totalWin
	echo $totalLose
	if [ $totalWin -gt $totalLose ]
	then
		winBy=$(($totalWin-$totalLose))
		echo "Total Amount won : $winBy"
	else
		lostBy=$(($totalLose-$totalWin))
		echo "Total Amount lost : $lostBy"
	fi
}

betTwentyDays

echo "Per Day Outcome"

PerDayOutcome(){
	arr=()
	for (( i=1; i<=DAYS_PER_MONTH; i++ ))
	do
		currentAmount=$STAKE_PER_DAY
		betForOneDayHelper
		arr+=($currentAmount)
	done
	for (( i=0; i<DAYS_PER_MONTH; i++ ))
	do
		echo "Day $(($i+1)) : ${arr[$i]}"
	done

}
PerDayOutcome

echo "Per Day Total Difference"

LuckiestUnluckiestDay(){
	totalDiffAmountTillNow=0
	maxCurrentDiffAmount=-10000
	minCurrentDiffAmount=10000
	luckiestDay=0
	unluckiestDay=0
	for (( i=1; i<=DAYS_PER_MONTH; i++ ))
	do
		currentAmount=$STAKE_PER_DAY	
		betForOneDayHelper
		diff=$(($currentAmount-$STAKE_PER_DAY))
		totalDiffAmountTillNow=$(($totalDiffAmountTillNow+$diff))
		if [ $totalDiffAmountTillNow -gt $maxCurrentDiffAmount ]
		then
			maxCurrentDiffAmount=$totalDiffAmountTillNow
			luckiestDay=$i
		fi
		if [ $totalDiffAmountTillNow -lt $minCurrentDiffAmount ]
		then
			minCurrentDiffAmount=$totalDiffAmountTillNow
			unluckiestDay=$i
		fi
		echo "Day $i : $totalDiffAmountTillNow"
	done
	echo "luckiest_day : $luckiestDay  Amount : $maxCurrentDiffAmount"
	echo "unluckiest_day : $unluckiestDay  Amount : $minCurrentDiffAmount"
}
LuckiestUnluckiestDay


playContinueNextMonth(){
	totalWin=0 //Here I have to initialize or else it is taking previous values
	totalLose=0
	monthNo=0	
	while [ $1=1 ]
	do
		monthNo=$(($monthNo+1))
		betTwentyDaysHelper
		echo $monthNo
		echo $totalWin
		echo $totalLose

		if [ $totalWin -gt $totalLose ]
		then
			winBy=$(($totalWin-$totalLose))
			echo "Total Amount won : $winBy"
			echo "Continue Playing"
			totalWin=0
			totalLose=0
			continue
		else
			lostBy=$(($totalLose-$totalWin))
			echo "Total Amount lost : $lostBy"
			echo "Stop Playing"
			break
		fi
	done
}
playContinueNextMonth
