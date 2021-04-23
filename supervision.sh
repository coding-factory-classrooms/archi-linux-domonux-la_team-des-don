#!/bin/bash

if [[ $# -eq 5 ]]; then
    folder=$1
    stdoutFile=$2
    stderrFile=$3
    maxFileSize=$4
    delayForGeneration=$5
else
    echo "Invalid arguments"
    exit 1
fi

trapFunction(){
    pkill generation
    echo "Goodbye !"
}

echo "Start of Supervision"
FILE=/home/$USER/$folder

while true;do
    if [ -d "$FILE" ]; then
        pathForFiles=/home/$USER/$folder
    else
        echo that $folder does not exist   
        exit 1 
    fi

    processUser=$(eval "pgrep -u $USER 'generation.sh' | wc -c")
    echo $processUser

    if [[ $processUser -gt 1 ]]; then
        echo 'Running'
    else
        echo 'Not Running'
        # Retrieve absolute path of generation.sh
        path=$(pwd)
        $path/generation.sh $5 $1 $2 $3 &
    fi

    generationPID=$(pgrep -x "generation.sh")
    

    outfileSize=$(wc -c <"$pathForFiles/$stdoutFile")
    errfileSize=$(wc -c <"$pathForFiles/$stderrFile")
    if [[ $outfileSize -ge $maxFileSize || $errfileSize -ge $maxFileSize ]]; then
        echo size of $stdoutFile or $stderrFile is over $maxFileSize bytes
        kill -SIGSTOP $generationPID

        cd /home/$USER/$folder

        cat $stdoutFile | wc -l > infos.log
        cat $stderrFile | wc -l > errors.log
        
        cat $stdoutFile | sort >> infos.log
        cat $stderrFile | sort >> errors.log

        
        tarfile=$(date +"%Y_%m_%d_%H_%M_%S")_logs.tar
        tar -cvf $tarfile *.txt infos.log errors.log
        rm -rf infos.log errors.log
        # empty text files
        > $stdoutFile
        > $stderrFile
        cd -
        echo "resume generation"
        kill -SIGCONT $generationPID
    else
        echo size of $stderrFile or $stdoutFile is under $maxFileSize bytes
    fi
done

echo "End of Supervision"
