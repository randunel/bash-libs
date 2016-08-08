#!/bin/bash

# Executes all functions, then waits until all are done executing.
#
# @param    @:1 functions to execute
async_wait_functions() {
    local -A map;
    local counter=0;
    local fn;
    for fn in "$@"; do
        counter=$(($counter + 1));
        eval $fn &
        local pid=$!;

        map["$counter-fn"]=$fn;
        map["$counter-pid"]=$pid;
    done;

    local waitlist="";
    local ix;
    for ix in $(seq $counter); do
        waitlist="$waitlist ${map[$ix-pid]}";
    done;

    wait $waitlist;
}

# Executes a function and reads stdout until the validator validates,
# then moves the process to background and continues previous execution.
#
# @param    $1  name of function to execute
# @param    $2  name of validation function
sync_wait_until_continue_async() {
    local fn_name=$1;
    local validator_name=$2;

    local self_global_var_name="$FUNCNAME""_GLOBAL_VAR";
    function_get_undefined_name $self_global_var_name "$FUNCNAME";
    local cb_name_global=$self_global_var_name;
    local cb_body_global="$cb_name_global() { \
        local pid=\$1; \
        local fd=\$2; \
        kill -SIGSTOP \$pid; \
        kill -SIGCONT \$pid; \
        {
            while kill -0 \$pid 2>/dev/null; do \
                sleep 2; \
            done; \
            eval 'exec '\"\$fd\"'<&-'; \
        } &
    }";
    eval $cb_body_global;
    sync_wait_until_cb "$fn_name" "$validator_name" "$cb_name_global";
    unset $cb_name_global;
}

# Executes a function and reads stdout until the validator validates,
# then moves the process to background and continues previous execution.
#
# @param    $1  name of function to execute
# @param    $2  name of validation function
# @param    $3  kill signal `kill -$signal $pid`
sync_wait_until_kill() {
    local fn_name=$1;
    local validator_name=$2;
    local signal=$3;

    local self_global_var_name="$FUNCNAME""_GLOBAL_VAR";
    function_get_undefined_name $self_global_var_name "$FUNCNAME";
    local cb_name_global=$self_global_var_name;
    local cb_body_global="$cb_name_global() { \
        local pid=\$1; \
        local fd=\$2; \
        kill -$signal \$pid; \
        eval 'exec '\"\$fd\"'<&-'; \
    }";
    eval $cb_body_global;
    sync_wait_until_cb "$fn_name" "$validator_name" "$cb_name_global";
    unset $cb_name_global;
}

# Executes a function and reads stdout until the validator validates,
# then calls the callback.
#
# This function opens a new file descriptor to allow keeping the process
# alive, in the background. Simply close the file descriptor and it will
# die when its current execution cycle ends (i.e. end of `sleep` command).
# It may be `kill`ed manually for faster results, but the file descriptor
# must be closed regardless, otherwise a file descriptor leak may lead to
# unexpected consequences.
#
# @param    $1  name of function to execute
# @param    $2  name of validation function
# @param    $3  name of callback function; will be called with ($pid $fd)
sync_wait_until_cb() {
    local fn_name=$1;
    local validator_name=$2;
    local cb_name=$3;

    local fd;
    exec {fd}< <(eval $fn_name);
    local pid=$!;

    local line;
    local found_expected=0;
    while read line; do
        printf "Got line $line\n";
        eval $validator_name \$line;
        found_expected=$?;

        if [[ $found_expected -eq 1 ]]; then
            break;
        fi
    done <&$fd;
    # kill -SIGSTOP $pid;
    # kill -SIGCONT $pid;

    # $fd>&2;
    # exec {fd}>&-;
    eval $cb_name \$pid \$fd;
}
