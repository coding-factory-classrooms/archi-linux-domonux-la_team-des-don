#!/bin/bash

dossier=$1
stdoutFile=$2
stderrFile=$3
fileSize=$4
generationPID=$(pgrep -x "generation.sh")

FILE=/home/$USER/$dossier
if [ -d "$FILE" ]; then
    cd /home/$USER/$dossier
else
    echo that $dossier does not exist   
    exit 1 
fi 

processUser=$(eval "pgrep -u $USER 'generation.sh' | wc -c")
echo $processUser

if [[ $processUser -gt 1 ]]; then
    echo 'Running'
else
    echo 'not Running'
    exit 1
fi   

actualsize=$(wc -c <"$stdoutFile")
if [[ $actualsize -ge $fileSize ]]; then
    echo size is over $fileSize bytes of $stdoutFile
    kill $generationPID
    
    tarfile=$(date +"%Y_%m_%d_%H_%M_%S")_logs.tar
    tar -cvf $tarfile *.txt
else
    echo size is under $fileSize bytes of $stdoutFile
fi

actualsize=$(wc -c <"$stderrFile")
if [[ $actualsize -ge $fileSize ]]; then
    echo size is over $fileSize bytes of $stderrFile
    kill pgrep "generation.sh"

    tarfile=$(date +"%Y_%m_%d_%H_%M_%S")_logs.tar
    tar -cvf $tarfile *.txt
else
    echo size is under $fileSize bytes of $stderrFile
fi