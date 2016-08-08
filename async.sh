#!/bin/bash

# Executes all functions, then waits until all are done executing.
#
# @param    @:1 functions to execute
async_wait_functions() {
    local fns="$@";

    local -A map;
    local counter=0;
    for fn in $fns; do
        counter=$(($counter + 1));
        eval $fn &
        local pid=$!;

        map["$counter-fn"]=$fn;
        map["$counter-pid"]=$pid;
    done;

    local waitlist="";
    for ix in $(seq $counter); do
        waitlist="$waitlist ${map[$ix-pid]}";
    done;

    wait $waitlist;
}
