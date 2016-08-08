#!/bin/bash -u

source $(dirname ${BASH_SOURCE[0]})/import_all.sh;

# function_get_undefined_name "MY_FN" "_asdqq_";
# printf "asd %s qq\n" "$MY_FN";

# interaction_confirmation_y_n "REPLY_1" "asd %s qq %s ?" "haha" "3";
# printf "Test result $REPLY_1\n";

# async_wait_functions "./counter.sh 2" "./counter.sh 4";
# printf "Done async.\n";

line_is_2() {
    local line=$1;
    printf "validator checking $line\n";
    if [[ $line -eq "2" ]]; then
        printf "found!\n"
        return 1;
    fi
    return 0;
}

sync_wait_until_kill "./counter.sh 10" "line_is_2" 9;
printf "all done\n";
sleep 30;
