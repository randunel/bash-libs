#!/bin/bash

for name in interaction function colors random async; do
    source $(dirname ${BASH_SOURCE[0]})/$name.sh;
done;
