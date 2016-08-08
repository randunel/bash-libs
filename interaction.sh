#!/bin/bash

# Interacts with user until single letter confirmation (y/n).
#
# @param    1   global variable name
# @param    @:2 arguments for `printf` question
# @returns  -   when global variable is set to "y" or "n"
interaction_confirmation_y_n() {
    local global_var_name=$1;

    local text="";
    local var;
    for var in "${@:2}"; do
        text+="\"$var\" ";
    done;

    local self_global_var_name="$FUNCNAME""_GLOBAL_VAR";
    function_get_undefined_name $self_global_var_name "_interaction_confirmation_prompt";
    local prompt_fn_name=$self_global_var_name;
    local prompt_fn_body="$prompt_fn_name() { \
        printf $text; \
        printf \" (y/n) \"; \
    }";
    eval $prompt_fn_body;

    interaction_get_specific_text \
        "$global_var_name" \
        "_interaction_confirmation_check" \
        "$prompt_fn_name" \
        "y" \
        "n";
    unset $prompt_name;
}

# Interacts with user until a validation function returns 1.
#
# @param    1   global variable name (return value)
# @param    2   name of validation function; will be called with ($answer @options)
# @param    3   name of prompt display function; will be called with ($INVALID_REPLY)
# @param    @:4 options
# @returns  -   when global variable is set to a string that passed validation
interaction_get_specific_text() {
    local global_var_name=$1;
    local validator_name=$2;
    local prompt_name=$3;
    local options=${@:4};

    local valid_answer=0;

    while [[ "$valid_answer" -eq 0 ]]; do
        read -r -p "`eval ${prompt_name}`" $global_var_name;
        printf "\n";
        eval local read_value=\$$global_var_name;
        eval ${validator_name} $read_value "$@";
        valid_answer=$?;
    done;
}

_interaction_confirmation_check() {
    local reply=$1;
    local options=${@:2};

    local option;
    for option in $options; do
        if [[ $reply == $option ]]; then
            return 1;
        fi
    done;

    return 0;
}
