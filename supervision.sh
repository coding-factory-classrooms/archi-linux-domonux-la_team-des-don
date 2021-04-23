#!/bin/bash

dossier=$1
stdoutFile=$2
stderrFile=$3
maxFileSize=$4

trap trapFunction 2

echo "Start of Supervision"
FILE=/home/$USER/$dossier

while true;do
    if [ -d "$FILE" ]; then
        pathForFiles=/home/$USER/$dossier
    else
        echo that $dossier does not exist   
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
        $path/generation.sh 1000 $1 $2 $3 &
    fi

    generationPID=$(pgrep -x "generation.sh")
    
    #commandForGeneration=$(ps -eo args | grep generation.sh | head -n 1)
    #commandForSupervision=$(ps -eo args | grep supervision.sh | head -n 1)

killAndWrite $stdoutFile
killAndWrite $stderrFile

killAndWrite(){
    local targetFile=$1
    fileSize=$(wc -c <"$pathForFiles/$targetFile")
    if [[ $fileSize -ge $maxFileSize ]]; then
        echo size is over $maxFileSize bytes of $stdoutFile
        kill $generationPID

        cd /home/$USER/$dossier

        cat $stdoutFile | wc -l > infos.log
        cat $stderrFile | wc -l > errors.log
        
        cat $stdoutFile | sort >> infos.log
        cat $stderrFile | sort >> errors.log

        
        tarfile=$(date +"%Y_%m_%d_%H_%M_%S")_logs.tar
        tar -cvf $tarfile *.txt infos.log errors.log
        rm -rf infos.log errors.log
        cd -
    else
        echo size is under $maxFileSize bytes of $stdoutFile
    fi
}

trapFunction(){
    pkill generation
    echo "Goodbye !"
}
    # actualsize=$(wc -c <"$stderrFile")
    # if [[ $actualsize -ge $fileSize ]]; then
        
    #     echo size is over $fileSize bytes of $stderrFile
    #     kill pgrep "generation.sh"
        
    #     cat $stdoutFile | wc -l > infos.log
    #     cat $stderrFile | wc -l > errors.log

    #     cat $stdoutFile | sort >> infos.log
    #     cat $stderrFile | sort >> errors.log
        
    #     tarfile=$(date +"%Y_%m_%d_%H_%M_%S")_logs.tar
    #     tar -cvf $tarfile *.txt infos.log errors.log
    #     rm -rf infos.log errors.log
    # else
    #     echo size is under $fileSize bytes of $stderrFile
    # fi
done

echo "End of Supervision"