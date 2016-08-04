#!/bin/bash

# Interacts with user until single letter confirmation (y/n).
#
# @param    @:1 arguments for `printf` question
# @returns  -   when $REPLY is set to "y" or "n"
interaction_confirmation_y_n() {
    # local valid_answer=0;

    # while [[ "$valid_answer" -eq 0 ]]; do
    #     printf "$@";
    #     read -r -p " (y/n) ";
    #     printf "\n";
    #     _interaction_confirmation_check $REPLY y n;
    #     valid_answer=$?;
    # done;
    # Commented code has the same output as uncommented, below

    local text="";
    for var in "${@:1}"; do
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
        "_interaction_confirmation_check" \
        "$prompt_fn_name" \
        "y" \
        "n";
}

# Interacts with user until a validation function returns 1.
#
# @param    1   name of validation function; will be called with ($answer @options)
# @param    2   name of prompt display function; will be called with ($INVALID_REPLY)
# @param    @:3 options
# @returns  -   when $REPLY is set to a string that passed validation
interaction_get_specific_text() {
    local validator_name=$1;
    local prompt_name=$2;
    local options=${@:3};

    local valid_answer=0;

    while [[ "$valid_answer" -eq 0 ]]; do
        read -r -p "`eval ${prompt_name}`";
        printf "\n";
        eval ${validator_name} $REPLY "$@";
        valid_answer=$?;
    done;
}

_interaction_confirmation_check() {
    local reply=$1;
    local options=${@:2};

    for option in $options; do
        if [[ $reply == $option ]]; then
            return 1;
        fi
    done;

    return 0;
}
