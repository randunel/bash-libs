#!/bin/bash

# Validates presence of array of environment variables
#
# @param    1   name of validation failed function; will be called with (@missing_envs)
# @param    @:2 array of variable names
# @returns  -
var_validate_presence() {
    local validation_failed_name=$1;

    local -a missing_envs;
    local ix=0;
    local var;
    for var in "${@:2}"; do
        eval local value=\$$var;
        if [[ -z "$value" ]]; then
            missing_envs[ix]=$var;
            ix=$((ix + 1));
        fi
    done;

    if [[ ix -gt 0 ]]; then
        eval ${validation_failed_name} ${missing_envs[@]};
    fi
}
