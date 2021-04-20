#!/bin/bash

echo "Hello world!"

# Compile genTick.c
gcc -Wall -o genTick genTick.c

# Run genTick.o with delay argument (millisecond)
./genTick 1000

