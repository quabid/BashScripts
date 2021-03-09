#!/bin/bash
declare -r ROOT=0
declare -r NOT_ROOT=120
declare -r NON_USER=121
declare -r NO_PARAM=122
declare -r CLEAN_EXIT=0
declare -r ERROR_EXIT=123
declare -r PROG="Add User To Sudo Group"


if [ $UID -ne $ROOT ]; then
    printf "\n\tYou must run this script as privileged user\n\n"
    exit 121
fi

if [ ! -e $1 ]; then
    userName=$(cat /etc/passwd | grep -E "$1" | awk -F : '{print $1}')

    if [ ${#userName} -eq 0 ]; then
        printf "\n\tUsername does not exist\n\n"
        exit 119
    elif [ ${#userName} -gt 0 ]; then
        usermod -aG sudo $userName
        # printf "\n\tGod-Damn ${userName} this is gooooood to go!!!\n\n"
        exit 0
    fi
else
    printf "\nMust enter a valid username\n\n"
    exit 120
fi
