#!/bin/bash
declare -r ROOT=0
declare -r NOT_ROOT=120
declare -r NON_USER=121
declare -r NO_PARAM=122
declare -r CLEAN_EXIT=0
declare -r ERROR_EXIT=123
declare -r PROG="Lock User Account"

prog() {
    printf "\n\t`white "${PROG^^}"`\n\n"
}

snyopsis() {
    printf "\n`yellow "Synopsis"`\n\t`white "lua.sh <Username>"`\n"
}

error() {
    printf "\n\t$(red "Error: ")$(white "Unknown Error Occurred")\n"
    exit $ERROR_EXIT
}

if [ $1 == "p" ] || [ $1 == "-p" ];
then
    prog
    exit $CLEAN_EXIT
elif [ $1 == "h" ] || [ $1 == "-h" ] || [ $1 == "?" ];
then
    snyopsis
    exit $CLEAN_EXIT
elif [ $UID -ne $ROOT ]; then
    printf "\n\tYou must run this script as privileged user\n\n"
    exit $NOT_ROOT
fi

if [ ! -e $1 ]; then
    userName=$1
    if [ ${#userName} -eq 0 ]; then
        echo -e "\n\t\e[28;5;24m`white "Username ${1^^} does not exist"`\e[m\n"
        exit $NON_USER
    elif [ ${#userName} -gt 0 ]; then
        usermod -L $userName
        if [ ! $? -eq 0 ];
        then
            error
        else
            exit $CLEAN_EXIT
        fi
    fi
else
    printf "\nMust enter a valid username\n\n"
    exit $NON_USER
fi
# blink echo -e "\e[28;5;24m${TEMP}\e[m\n"
