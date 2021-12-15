#!/bin/bash
## analiz proc smap V2
trap "exit 3 \
	" INT TERM
for ((i=0; i <= 5 ; i++))
do
	printf "\033[1B"
	printf "\033[K"
done
printf "\033[3A"
if [[ $1 == '' ]]; then
	read -p 'vvod pid or name_process: ' pid
else pid=$1
fi
# проверка на ввод
if [[ $pid =~ ^[0-9]+$ ]]; then
	ps -o pid= -p $pid
	if [ $? -eq 0 ]; then
    		echo "Process already running." 
	else
		pgrep -n $pid
		if [ $? -eq 0 ]; then
			pid=$(pgrep -n $pid)
   			echo "Process already running." $pid
		else
			echo "Process not find."
			exit 0
		fi
	fi
else
	pgrep -n $pid
	if [ $? -eq 0 ]; then
		pid=$(pgrep -n $pid)
 		echo "Process already running." $pid
	else
		echo "Process not find."
		exit 0
	fi
fi

# ввод времени/задержки сбора/скорости обновления
if [[ $2 == '' ]]; then
	tt=2
	#read -p 'vvod vremya zamera: ' tt
else tt=$2
fi
shag=0
lib=$(< /proc/$pid/smaps)

for (( ;; ))
do
	sleep $tt
	printf "\033[K"
	for ((i=0; i <= 2 ; i++))
	do
		printf "\033[1B"
		printf "\033[K"
	done
	printf "\033[3A" 	
	lib2=$(< /proc/$pid/smaps)
	lib3=$(diff -u <(echo "$lib") <(echo "$lib2")) #-s
	IFS=$'\n'
	 
	pkbnach=0
	pkbprishl=0

	for line in $lib3
	do
	   if [[ $line == *"-Private_Clean:"* || $line == *"-Private_Dirty:"* || $line == *"-Shared_Clean:"* || $line == *"-Shared_Dirty:"* ]]; then		
		let "pkbnach=$pkbnach+`echo $line| tr -cd '[[:digit:]]' `"
		#echo $pkbnach "-Private_Di_pkbnach"
	   fi
	   if [[ $line == *"+Private_Clean:"* || $line == *"+Private_Dirty:"* || $line == *"+Shared_Clean:"* || $line == *"+Shared_Dirty:"* ]]; then
		let "pkbprishl=$pkbprishl+`echo $line| tr -cd '[[:digit:]]' `"
		#echo $pkbprishl "+Private_Di_pkbprishl"
	   fi
	done
	let "pkb2 = $pkbprishl - $pkbnach " # как раз находим приращение
	# по сути если приращение не отрицательное то утечка
	echo $pkb2 приращение
	#производная направление ><=0 # приращение согласно единице в шаг
	# кеф крутости изменения
	shag=`echo "$shag + $tt" | bc`
	proizvidn=$(bc<<<"scale=1;$pkb2 / $shag")
	echo $proizvidn kef speed
	if [ $(echo "$proizvidn > 0" | bc) -eq 1 ]; then
		echo -e "\033[36m""Process" $(ps -p $pid -o comm=) "may have a memory leak""\033[0m"
	fi
	if [ $(echo "$proizvidn == 0" | bc) -eq 1 ]; then
		echo -e "\033[36m""Program" $(ps -p $pid -o comm=) "hasn't memory leak""\033[0m"
	fi
	if [ $(echo "$proizvidn < 0" | bc) -eq 1 ]; then
		echo -e "\033[36m""Program" $(ps -p $pid -o comm=) "hasn't memory leak""\033[0m"
	fi
	echo "info memory"
	pmap -d $pid | tail -n 1
	printf "\033[5A"	
done