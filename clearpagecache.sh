#!/bin/bash
sync; echo 1 > /proc/sys/vm/drop_caches
if [[ $? -gt 0 ]];
then
    printf 'error code: %s\n' "$?"
else
    exit 0
fi
