#!/bin/bash

set -e

LINE=$1
FILE=$2
DETECT=${3:-$LINE}

if [[ -z $(grep "$DETECT" "$FILE") ]]; then
    echo "Line not found in $FILE"
    echo -n "$LINE" >> "$FILE"
else
    echo "Fragment already exists in $FILE"
fi
