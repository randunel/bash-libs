#!/bin/bash

COUNTER=0;

TOP=6;
if [[ ! -z $1 ]]; then
    TOP=$1;
fi
while true; do
    COUNTER=$(($COUNTER + 1));
    printf "$COUNTER\n";
    printf "$COUNTER\n" >> "asdqq.count";
    if [[ $COUNTER -eq $TOP ]]; then
        exit 0;
    fi
    sleep 2;
done;
