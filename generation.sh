#!/bin/bash

# set -x

delay=$1
folder=$2
stdoutFile=$3
stderrFile=$4   

#test(){
#    echo "generation stopped"
#}

#trap test SIGSTOP
#trap "echo generation resumed" SIGCONT


mkdir -p /home/$USER/$folder 

touch $stdoutFile $stderrFile && mv -t /home/$USER/$folder $stdoutFile $stderrFile 

echo 'user Id :' $UID

# Compile genTick.c
gcc -Wall -o genTick genTick.c

# Compile genSensorData.c
#gcc -Wall -o getSensorData genSensorData.py

# Run genTick.o with delay argument (millisecond)
#./genTick $delay

# Run genSensorData
./genTick $delay | python3 genSensorData.py 2>&1 | {
    while IFS= read -r line; do
    echo "/home/$USER/$folder/$stdoutFile"
        if echo $line | grep -q "Sensor_id"; then
            echo $line >> /home/$USER/$folder/$stdoutFile
        elif echo $line | grep -q "Error#"; then
            echo $line >> /home/$USER/$folder/$stderrFile
        fi
    done
}
