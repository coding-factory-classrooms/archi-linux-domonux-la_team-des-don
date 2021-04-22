#!/bin/bash

dossier=$1
stdoutFile=$2
stderrFile=$3
fileSize=$4

FILE=/home/$USER/$dossier
if [ -d "$FILE" ]; then
    cd /home/$USER/$dossier
else
    echo that $dossier does not exist   
    exit 1 
fi

if pgrep -x "generation.sh"; then
    echo 'Running'
else
    echo 'not Running'
    exit 1
fi             


actualsize=$(wc -c <"$stdoutFile")
if [[ $actualsize -ge $fileSize ]]; then
    echo size is over $fileSize bytes of $stdoutFile
else
    echo size is under $fileSize bytes of $stdoutFile
fi

actualsize=$(wc -c <"$stderrFile")
if [[ $actualsize -ge $fileSize ]]; then
    echo size is over $fileSize bytes of $stderrFile
else
    echo size is under $fileSize bytes of $stderrFile
fi