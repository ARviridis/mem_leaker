#!/bin/bash
## analiz proc smap 

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
# ввод времени сбора

if [[ $2 == '' ]]; then
	read -p 'vvod vremya zamera: ' tt
else tt=$2
fi

lib=$(< /proc/$pid/smaps)
sleep $tt
lib2=$(< /proc/$pid/smaps)

lib3=$(diff -u <(echo "$lib") <(echo "$lib2"))

#echo $'\n'
IFS=$'\n'
# СЧИТАТЬ ПОСТРОЙЧНО ЕСЛИ ЕСТЬ СОВПАДЕНИЯ 
for line in $lib3
do
   if [[ $line == *" Size:"* ]]; then
	szkb+=$line
	szkb+=$'\n'
	#echo $line
   fi
   if [[ $line == *" Private_Clean:"* ]]; then
	pkb+=$line
	pkb+=$'\n'
	#echo $line
   fi
   if [[ $line == *"Private_Dirty:"* ]]; then
	pkb+=$line
	pkb+=$'\n'
	#echo $line
   fi
   if [[ $line == *"Shared_Clean:"* ]]; then
	skb+=$line
	skb+=$'\n'
	#echo $line
   fi
   if [[ $line == *"Shared_Dirty:"* ]]; then
	skb+=$line
	skb+=$'\n'
	#echo $line
   fi
   if [[ $line == *"Pss:"* ]]; then
	psskb+=$line
	psskb+=$'\n'
	#echo $line
   fi
done

tkb+=$pkb
tkb+=$skb
#echo $'\n'
#СЧИТАТЬ ПОСТРОЙЧНО  СОВПАДЕНИЯ В "ОЗНАчает утечку" (в нашем приложении
# вообще показывет на сколько именилось значение занимаемой памяти)
if [ "$tkb" ]; then
	echo -e "\033[36m""Program" $(ps -p $pid -o comm=) "has memory leak""\033[0m"
    	echo  "Всего приват: "$'\n'"$pkb" 
    	echo  "Всего shared: "$'\n'"$skb" 
    	echo  "Всего proc prop pss: "$'\n'"$psskb"
    	echo  "Priv + shared: "$'\n'"$tkb" 
    	echo  "Size:"$'\n'"$szkb"
else
	echo -e "\033[36m""Program" $(ps -p $pid -o comm=) "hasn't memory leak""\033[0m"
fi
echo "info memory"
pmap -d $pid | tail -n 1
