#!/usr/bin/bash
declare -r PROG="Print Color Range"
declare -r DESC="Prints sentences vertically in the color matching that color range"

# for N in {1..255};do color -x $N "Color value is $N!";done

synopsis() {
    printf "\n\t%s" "$(color -w "${PROG}")"
    printf "\n\t%s" "$(color -x 226 "${DESC}")"
    printf "\n\t%s\n\n" "$(color -x 178 "Synopsis: ${0} <?h>")"
    exit 0
}

printRange() {
    for N in {1..255}; do color -x $N "Color value is $N!"; done
    exit 0
}

trap "gracefulExit" INT TERM QUIT PWR

while getopts ':?h' OPTION; do
    case ${OPTION} in
    h)
        printRange
        ;;

    :)
        printRange
        ;;

    \?)
        synopsis
        ;;
    esac
done
shift "$(($OPTIND - 1))"
