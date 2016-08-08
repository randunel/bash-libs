#!/bin/bash

declare name;
for name in interaction function text random async var; do
    source $(dirname ${BASH_SOURCE[0]})/$name.sh;
done;
