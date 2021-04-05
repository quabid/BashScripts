#!/usr/bin/bash
<<COMMENT
    Administrative helper script use for:
        - Adding user to sudo group
        - Removing user from sudo group
        - Listing user's group(s)
        - Locking user account
        - Unlocking user account

    Uncomment lines 52, 67 82 and 113
    Comment or delete lines 53, 68, 83 and 114
COMMENT
declare -r EXIT_PROG=0
declare -r ROOT_UID=0
declare -r NON_ROOT=121
declare -r EXIT_UNKNOWN_USER=120
declare -r EXIT_NO_ROOT=119
declare -r PROG="Manage User Account"
declare -r DESC="Administrative helper script use for: Adding user to sudo group, Removing user from sudo group,
Listing user's group(s), Locking user account and Unlocking user account."
userName=""

clearVars() {
    unset userName
}

gracefulExit() {
    clearVars
    exit 0
}

exitProg() {
    gracefulExit
}

synopsis() {
    printf "\n\t%s\n" "$(color -w "${PROG^^}")"
    printf "\n%s\n" "$(color -w "$DESC")"
    printf "\n%s%s%s%s" "$(color -o "Synopsis: ")" "$(white "${0}")" " $(white "<-alLru?>")" " $(white "<username>")"
    printf "\n%s\n\t%s\n\t%s\n\t%s\n\t%s\n\t%s\n\t%s\n" "$(color -o "Parameters: ")" "$(color -w "?:\tPrints this message")" \
        "$(color -w "a:\tAdd user to the sudo group")" \
        "$(color -w "l:\tLock user acount")" \
        "$(color -w "L:\tList user's groups")" \
        "$(color -w "r:\tRemove user from the sudo group")" \
        "$(color -w "u:\tUnlock user accunt")"
}

addUserToSudo() {
    if [ ${#userName} -eq 0 ]; then
        printf "\t%s\n" "$(color -r "Unknown username")"
        exit $EXIT_UNKNOWN_USER
    elif [ ${#userName} -gt 0 ]; then
        # usermod -aG $userName
        printf "\t\t%s\n\n" "Done and Done!!"
        if [ ! $? -eq 0 ]; then
            exit $#
        else
            exit $EXIT_PROG
        fi
    fi
}

lockUserAccount() {
    if [ ${#userName} -eq 0 ]; then
        printf "\t%s\n" "$(color -r "Unknown username")"
        exit $EXIT_UNKNOWN_USER
    elif [ ${#userName} -gt 0 ]; then
        # usermod -L $userName
        printf "\t\t%s\n\n" "Done and Done!!"
        if [ ! $? -eq 0 ]; then
            exit $#
        else
            exit $EXIT_PROG
        fi
    fi
}

unlockUserAccount() {
    if [ ${#userName} -eq 0 ]; then
        printf "\t%s\n" "$(color -r "Unknown username")"
        exit $EXIT_UNKNOWN_USER
    elif [ ${#userName} -gt 0 ]; then
        # usermod -U $userName
        printf "\t\t%s\n\n" "Done and Done!!"
        if [ ! $? -eq 0 ]; then
            exit $#
        else
            exit $EXIT_PROG
        fi
    fi
}

listUserGroups() {
    if [ ${#userName} -eq 0 ]; then
        printf "\t%s\n" "$(color -r "Unknown username")"
        exit $EXIT_UNKNOWN_USER
    elif [ ${#userName} -gt 0 ]; then
        groups $userName
        if [ ! $? -eq 0 ]; then
            exit $#
        else
            exit $EXIT_PROG
        fi
    fi
}

removeUserFromSudoGroup() {
    # Check that username exists
    if [ ${#userName} -eq 0 ]; then
        printf "\t%s\n" "$(color -r "Unknown username")"
        exit $EXIT_UNKNOWN_USER
    # Confirm userName variable is not empty
    elif [ ${#userName} -gt 0 ]; then
        # gpasswd -d $userName "sudo"
        printf "\t\t%s\n\n" "Done and Done!!"
        if [ ! $? -eq 0 ]; then
            exit $#
        else
            exit $EXIT_PROG
        fi
    fi
}

trap "gracefulExit" INT TERM QUIT PWR

while getopts ':?l:u:a:L:r:' OPTION; do
    case ${OPTION} in
    a)
        printf "%s parameter\n" "${OPTION^}"
        printf "Username argument: %s\n" "$2"
        printf "%d arguments\n\n" $#

        if [ ! -e "$2" ]; then
            userName="$(cat /etc/passwd | awk -F : '{print $1}' | grep -E "\b($2)\b")"
            addUserToSudo "$userName"
        else
            printf "\nMust enter a valid username \n\n"
            exit $EXIT_UNKNOWN_USER
        fi

        ;;

    l)
        printf "%s parameter\n" "${OPTION^}"
        printf "Username argument: %s\n" "$2"
        printf "%d arguments\n\n" $#

        if [ ! -e "$2" ]; then
            userName="$(cat /etc/passwd | awk -F : '{print $1}' | grep -E "\b($2)\b")"
            lockUserAccount "$userName"
        else
            printf "\nMust enter a valid username \n\n"
            exit $EXIT_UNKNOWN_USER
        fi

        ;;

    L)
        # printf "%s parameter\n" "${OPTION^}"
        # printf "Username argument: %s\n" "$2"
        # printf "%d arguments\n\n" $#

        if [ ! -e "$2" ]; then
            userName="$(cat /etc/passwd | awk -F : '{print $1}' | grep -E "\b($2)\b")"
            listUserGroups "$userName"
        else
            printf "\nMust enter a valid username \n\n"
            exit $EXIT_UNKNOWN_USER
        fi

        ;;

    r)
        printf "%s parameter\n" "${OPTION^}"
        printf "Username argument: %s\n" "$2"
        printf "%d arguments\n\n" $#

        if [ ! -e "$2" ]; then
            userName="$(cat /etc/passwd | awk -F : '{print $1}' | grep -E "\b($2)\b")"
            removeUserFromSudoGroup "$userName"
        else
            printf "\nMust enter a valid username \n\n"
            exit $EXIT_UNKNOWN_USER
        fi

        ;;

    u)
        printf "%s parameter\n" "${OPTION^}"
        printf "Username argument: %s\n" "$2"
        printf "%d arguments\n\n" $#

        if [ ! -e "$2" ]; then
            userName="$(cat /etc/passwd | awk -F : '{print $1}' | grep -E "\b($2)\b")"
            unlockUserAccount "$userName"
        else
            printf "\nMust enter a valid username \n\n"
            exit $EXIT_UNKNOWN_USER
        fi

        ;;

    \?)
        synopsis
        ;;
    esac
done
shift "$(($OPTIND - 1))"
