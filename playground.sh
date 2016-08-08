#!/bin/bash
set -u

source $(dirname ${BASH_SOURCE[0]})/import_all.sh;

# function_get_undefined_name "MY_FN" "_asdqq_";
# printf "asd %s qq\n" "$MY_FN";

# interaction_confirmation_y_n "REPLY_1" "asd %s qq %s ?" "haha" "3";
# printf "Test result $REPLY_1\n";

async_wait_functions "./counter.sh" "./counter.sh";
printf "Done async.\n";
