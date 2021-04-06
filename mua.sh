#!/usr/bin/bash
<<COMMENT
    Administrative helper script use for:
        - Adding user to sudo group
        - Removing user from sudo group
        - Listing user's group(s)
        - Locking user account
        - Unlocking user account

    Uncomment lines 53, 68 83 and 114
    Comment or delete lines 54, 69, 84 and 115
COMMENT
declare -r EXIT_PROG=0
declare -r ROOT_UID=0
declare -r NON_ROOT=121
declare -r EXIT_UNKNOWN_USER=120
declare -r EXIT_UNKNOWN_GROUP=119
declare -r EXIT_NO_ROOT=118
declare -r PROG="Manage User Account"
declare -r DESC="Administrative helper script use for: Adding user to sudo group, Removing user from sudo group,
Listing user's group(s), Locking user account and Unlocking user account."
userName=""
groupName=""

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
    printf "\n%s%s%s%s" "$(color -o "Synopsis: ")" "$(white "${0}")" " $(white "<-aAlLru?>")" " $(white "<username>")"
    printf "\n%s\n\t%s\n\t%s\n\t%s\n\t%s\n\t%s\n\t%s\n" "$(color -o "Parameters: ")" "$(color -w "?:\tPrints this message")" \
        "$(color -w "a:\tAdd user to the sudo group")" \
        "$(color -w "A:\tAdd user to the group")" \
        "$(color -w "l:\tLock user acount")" \
        "$(color -w "L:\tList user's groups")" \
        "$(color -w "r:\tRemove user from the sudo group")" \
        "$(color -w "u:\tUnlock user accunt")"
}

addUserToGroup() {
    # usermod -aG $userName $groupName
    printf "\n\t%s\n\n" "$(color -P "Done and Done!!")"
}

addUserToSudo() {
    # usermod -aG $userName sudo
    printf "\t\t%s\n\n" "Done and Done!!"
    exit $EXIT_PROG
}

lockUserAccount() {
    # usermod -L $userName
    printf "\t\t%s\n\n" "Done and Done!!"
    exit $EXIT_PROG
}

unlockUserAccount() {
    # usermod -U $userName
    printf "\t\t%s\n\n" "Done and Done!!"
    exit $EXIT_PROG
}

listUserGroups() {
    groups "$userName"
    exit $EXIT_PROG
}

removeUserFromSudoGroup() {
    # gpasswd -d $userName "sudo"
    printf "\t\t%s\n\n" "Done and Done!!"
    exit $EXIT_PROG
}

trap "gracefulExit" INT TERM QUIT PWR

while getopts ':?l:u:a:L:r:A:' OPTION; do
    case ${OPTION} in
    a)
        # printf "%s parameter\n" "${OPTION^}"
        # printf "Username argument: %s\n" "$2"
        # printf "%d arguments\n\n" $#

        if [ ! -e "$2" ]; then
            userName="$(cat </etc/passwd | awk -F : '{print $1}' | grep -E "\b($2)\b")"
            addUserToSudo "$userName"
        else
            printf "\nMust enter a valid username \n\n"
            exit $EXIT_UNKNOWN_USER
        fi

        ;;
    A)
        # printf "%s parameter\n" "${OPTION^}"
        # printf "Username argument: %s, %s\n" "$2" "$3"
        # printf "%d arguments\n\n" $#

        if [ $# -eq 3 ]; then
            userName="$(cat </etc/passwd | awk -F : '{print $1}' | grep -E "\b($2)\b")"
            groupName="$(cat </etc/group | awk -F : '{print $1}' | grep -E "\b($3)\b")"

            printf "User: %s, Group: %s\n\n" "$userName" "$groupName"

            if [ -n "$userName" ]; then
                if [ -n "$groupName" ]; then
                    addUserToGroup "$userName" "$groupName"
                else
                    printf "\n\t%s\n\n" "$(color -o "Group ${3^^} does not exist!")"
                    exit $EXIT_UNKNOWN_GROUP
                fi

            else
                printf "\n\t%s\n\n" "$(color -o "Username ${2^^} does not exist!")"
                exit $EXIT_UNKNOWN_USER
            fi
        fi
        # if [ ! -e "$2" ]; then
        #     userName="$(cat </etc/passwd | awk -F : '{print $1}' | grep -E "\b($2)\b")"
        #     addUserToSudo "$userName"
        # else
        #     printf "\nMust enter a valid username \n\n"
        #     exit $EXIT_UNKNOWN_USER
        # fi

        ;;

    l)
        # printf "%s parameter\n" "${OPTION^}"
        # printf "Username argument: %s\n" "$2"
        # printf "%d arguments\n\n" $#

        if [ ! -e "$2" ]; then
            userName="$(cat </etc/passwd | awk -F : '{print $1}' | grep -E "\b($2)\b")"
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
            userName="$(cat </etc/passwd | awk -F : '{print $1}' | grep -E "\b($2)\b")"
            listUserGroups "$userName"
        else
            printf "\nMust enter a valid username \n\n"
            exit $EXIT_UNKNOWN_USER
        fi

        ;;

    r)
        # printf "%s parameter\n" "${OPTION^}"
        # printf "Username argument: %s\n" "$2"
        # printf "%d arguments\n\n" $#

        if [ ! -e "$2" ]; then
            userName="$(cat </etc/passwd | awk -F : '{print $1}' | grep -E "\b($2)\b")"
            removeUserFromSudoGroup "$userName"
        else
            printf "\nMust enter a valid username \n\n"
            exit $EXIT_UNKNOWN_USER
        fi

        ;;

    u)
        # printf "%s parameter\n" "${OPTION^}"
        # printf "Username argument: %s\n" "$2"
        # printf "%d arguments\n\n" $#

        if [ ! -e "$2" ]; then
            userName="$(cat </etc/passwd | awk -F : '{print $1}' | grep -E "\b($2)\b")"
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
