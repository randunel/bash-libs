#!/bin/bash

# Executes all functions, then waits until all are done executing.
#
# @param    @:1 functions to execute
async_wait_functions() {
    local fns="$@";

    local -a array;
    local counter=1;
    for fn in $fns; do
        printf "Executing $fn\n";

        eval $fn &
        local pid=$$;

        local -A details;
        details=([fn]=$fn [pid]=$pid [counter]=$counter);

        array[$counter]=$details;
        printf "set array $counter $pid\n";

        counter=$(($counter + 1));
    done;

    for details in "$array"; do
        printf "should do something with ${details[fn]} ${details[pid]} ${details[counter]}\n";
        kill ${details[pid]};
    done;
}
