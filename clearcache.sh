#!/bin/bash
sync; echo 3 > /proc/sys/vm/drop_caches
if [[ $? -gt 0 ]];
then
    printf 'Error code: %s\n' "$?"
else
    exit 0;
fi
