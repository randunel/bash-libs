#!/bin/bash

COUNTER=0;

while true; do
    COUNTER=$(($COUNTER + 1));
    printf "$COUNTER\n";
    sleep 2;
done;
