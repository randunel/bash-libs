#!/bin/bash

# Sets an unused function name to a predefined global variable.
#
# @param    1   global variable name
# @param    2   prefix
# @returns  -
function_get_undefined_name() {
    local global_var_name=$1;
    local prefix=$2;

    local self_global_var_name="$FUNCNAME""_GLOBAL_VAR";
    random_get_string $self_global_var_name 8;
    eval local random_string=\$$self_global_var_name;

    local undefined_name=$prefix$random_string;
    if [ `type -t $undefined_name` ]; then
        function_get_undefined_name $global_var_name $prefix;
        return;
    fi

    eval $global_var_name=\$undefined_name;
}
