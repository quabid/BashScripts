#!/bin/bash
set -e
set -u
set -o pipefail

gracefulExit() {
    exit 0
}

usage() {
    printf "%s\n" "$(color -w "Usage: color <option> <Quoted Text>")"
    # For using one of the 256 colors on the foreground (text color), the control sequence is “<Esc>[38;5;ColorNumberm”
    #  where ColorNumber is one of the following colors:
    # For using one of the 256 colors on the background, the control sequence is “<Esc>[48;5;ColorNumberm”
    # where ColorNumber is one of the following colors:

    echo -e "\e[38;5;149mOptions:"
    echo -e "\t\e[38;5;224mb: \e[38;5;39m Blue"
    echo -e "\t\e[97mB: \e[38;5;234m Black"
    echo -e "\t\e[38;5;224mc: \e[38;5;87m Cyan"
    echo -e "\t\e[38;5;224mg: \e[38;5;119m Green"
    echo -e "\t\e[38;5;224mm: \e[38;5;200m Magenta"
    echo -e "\t\e[38;5;224mo: \e[38;5;208m Orange"
    echo -e "\t\e[38;5;224mP: \e[38;5;211m Pink"
    echo -e "\t\e[38;5;224mp: \e[38;5;129m Purple"
    echo -e "\t\e[38;5;224mr: \e[38;5;196m Red"
    echo -e "\t\e[38;5;224mw: \e[38;5;224m White"
    echo -e "\t\e[38;5;224mx: \e[38;5;224m Range from 1 to 255"
    echo -e "\t\e[38;5;224my: \e[38;5;226m Yellow"
}

printRangeVertically() {
    for N in {1..255}; do
        line="$(color -x "$N" "Color value is $N!")"
        printf "%s\n" "$line"
    done
    exit 0
}

printRangeHorizontally() {
    for N in {1..255}; do
        line="$(color -x "$N" "Color value is $N!")"
        printf "%s\t" "$line"
    done
    printf "\n\n"
    exit 0
}

synopsis() {
    echo -e "\e[38;5;209m\n\t\tColor Usage Detail\e[m"
    printf "%s\n\t  %s\n\t  %s\n\t  %s\n" "$(color -w "Synopsis: ${0} <BbcgmoPprwy> <Quoted Text>")" \
        "$(color -w "color -d")" \
        "$(color -w "color -H")" \
        "$(color -w "color -x <1-255> <Quoted Text>")"
    printf "%s\n" "$(color -w "By default, the color intensity is configured high")"
    printf "%s\n" "$(color -x 178 "Parameters:")"
    printf "\t%s\n" "$(color -b "b:\tBlue")"
    printf "\t%s\n" "$(color -B "B:\tBlack")"
    printf "\t%s\n" "$(color -c "c:\tCyan")"
    printf "\t%s\n" "$(color -g "g:\tGreen")"
    printf "\t%s\n" "$(color -m "m:\tMagenta")"
    printf "\t%s\n" "$(color -o "o:\tOrange")"
    printf "\t%s\n" "$(color -P "P:\tPink")"
    printf "\t%s\n" "$(color -p "p:\tPurple")"
    printf "\t%s\n" "$(color -r "r:\tRed")"
    printf "\t%s\n" "$(color -w "w:\tWhite")"
    printf "\t%s\n" "$(color -y "y:\tYellow")"
    printf "\t%s\n" "$(color -w "x:\tcolor -x N = (Color range 1 to 255) <Quoted Text>")"
    printf "\t%s\n" "$(color -w "d:\tPrints sentences colored in the full range")"
    printf "\t%s\n" "$(color -w "H:\tHorizontally prints sentences colored in the full range")"
    printf "\n"
    gracefulExit
}

while getopts ':dB:b:c:g:m:o:p:P:r:w:x:y:hH' OPTION; do
    case "$OPTION" in
    B)
        # printf 'Option %s chosen\n' "${OPTION}"
        echo -e "\e[38;5;240m${OPTARG}\e[m"
        ;;

    b)
        # printf 'Option %s chosen\n' "${OPTION}"
        echo -e "\e[38;5;39m${OPTARG}\e[m"
        ;;

    c)
        # printf 'Option %s chosen\n' "${OPTION}"
        echo -e "\e[38;5;87m${OPTARG}\e[m"
        ;;

    d)
        printRangeVertically
        ;;

    g)
        # printf 'Option %s chosen\n' "${OPTION}"
        echo -e "\e[38;5;83m${OPTARG}\e[m"
        ;;

    h)
        usage
        ;;

    H)
        printRangeHorizontally
        ;;

    m)
        # printf 'Option %s chosen\n' "${OPTION}"
        echo -e "\e[38;5;200m${OPTARG}\e[m"
        ;;

    o)
        echo -e "\e[38;5;208m${OPTARG}\e[m"
        ;;

    p)
        # printf 'Option %s chosen\n' "${OPTION}"
        echo -e "\e[38;5;170m${OPTARG}\e[m"
        ;;

    P)
        # printf 'Option %s chosen\n' "${OPTION}"
        echo -e "\e[38;5;211m${OPTARG}\e[m"
        ;;

    r)
        # printf 'Option %s chosen\n' "${OPTION}"
        echo -e "\e[38;5;196m${OPTARG}\e[m"
        ;;

    w)
        # printf 'Option %s chosen\n' "${OPTION}"
        echo -e "\e[38;5;224m${OPTARG}\e[m"
        ;;

    x)
        # Color given text with given color code
        # 2nd param = color code
        # 3rd param = text or quoted text with spaces
        if [[ $# -ne 3 ]]; then
            printf 'Option %s requires two arguments.\n' "${1}"
            nfy "Option ${1} requires two arguments.\n"
            usage
            exit 2
        else
            echo -e "\e[38;5;${OPTARG}m${3}\e[m"
        fi
        ;;

    y)
        # printf 'Option %s chosen\n' "${OPTION}"
        echo -e "\e[38;5;226m${OPTARG}\e[m"
        ;;

    \?)
        synopsis
        ;;

    :)
        if [[ ${OPTARG} == "x" ]]; then
            printf "Option %s requires 2 arguments\n" "$OPTARG"
            usage
        else
            printf "Option %s requires an argument\n" "$OPTARG"
            usage
        fi
        exit 1
        ;;
    esac
done
shift $(($OPTIND - 1))
