#!/bin/bash
# set -x

    delay=$1
    dossier=$2
    stdoutFile=$3
    stderrFile=$4

# if [[ $# -eq 1 ]]; then
#     delay=$1
#     verbose_mode=false
# elif [[ $# -eq 2 && $1 == "-v" || $1 == "--verbose" ]]; then
#     delay=$2
#     verbose_mode=true
# else
#     echo "Invalid arguments"
#     exit 1
#fi
echo "Hello world!"

launch=null 

for i in $* do
    echo launch
done
trap myFunction 2

myFunction(){
    echo $0
}

mkdir -p /home/$USER/$dossier 

touch $stdoutFile $stderrFile && mv -t /home/$USER/$dossier $stdoutFile $stderrFile 


echo 'user Id :' $UID

# Compile genTick.c
gcc -Wall -o genTick genTick.c

# Compile genSensorData.c
#gcc -Wall -o getSensorData genSensorData.py

# Run genTick.o with delay argument (millisecond)
#./genTick $delay

# Run genSensorData
./genTick $delay | python3 genSensorData.py | {
    while IFS= read -r line; do
        if echo $line | grep -q "Sensor_id"; then
            echo $line >> /home/$USER/$dossier/$stdoutFile
        elif echo $line | grep -q "Error#"; then
            echo $line >> /home/$USER/$dossier/$stderrFile
        fi  
    done
}
 
# if [[ $retour grep -E 'Error' ]]; then
#     do print('error')
#     done

# fi
#./genTick $delay | python3 genSensorData.py >> $dossier/$stdoutFile

# if [[ $? -ne 0 ]]; then
#     echo "error"
# fi
