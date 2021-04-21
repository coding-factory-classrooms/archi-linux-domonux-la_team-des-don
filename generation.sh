#!/bin/bash
# set -x

if [[ $# -eq 1 ]]; then
    delay=$1
    verbose_mode=false
elif [[ $# -eq 2 && $1 == "-v" || $1 == "--verbose" ]]; then
    delay=$2
    verbose_mode=true
else
    echo "Invalid arguments"
    exit 1
fi
echo "Hello world!"

# Compile genTick.c
gcc -Wall -o genTick genTick.c

# Run genTick.o with delay argument (millisecond)
./genTick $delay

