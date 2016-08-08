#!/bin/bash

COUNTER=0;

while true; do
    COUNTER=$(($COUNTER + 1));
    printf "$COUNTER\n";
    if [[ $COUNTER -gt 6 ]]; then
        exit 0;
    fi
    sleep 2;
done;
