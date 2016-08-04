#!/bin/bash

# Sets a random string of specified length to a predefined global variable.
#
# @param    1   global variable name
# @param    2   length
# @returns  -
random_get_string() {
    local global_var_name=$1;
    local length=$2;

    local string="$( \
        head -c $length /dev/urandom \
        | base64 \
        | head -c $length \
        | sed -e s/[^[:alpha:]]/_/g \
        )";
    eval $global_var_name=\$string;
}
