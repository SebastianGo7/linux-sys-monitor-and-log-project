#!/bin/bash
#====================================================
# TITLE:            tmux_panes_display_cmds_v1.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-08-23
# USAGE:            ./main_v1.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          1.1.0
#====================================================

# Check if a command argument is provided

if [ "$#" -ne 1 ]; then
    echo "Provide a valid cmd or code word please"
    exit 1
fi

# Retrieve the command argument
COMMAND=$1

# Use a case statment for different commands and code words

case "$COMMAND" in
    menu_info) 
        # Display the menu info 
        exec_cmd='echo -e "\nEmpty pane, to display further info later"'
        ;;
    last)
        # Execute the last command
        exec_cmd="last | awk '{print \$1}' | sort | uniq -c | sort -nr"
        ;;
    ulimit) 
        # Execute the ulimit command
        exec_cmd="ulimit -a | sed 's/)/)\n/g' | grep --color=never -A 9 '^max locked memory'"
        ;;
    who)
        # Execute the who command
        exec_cmd="who | awk '{print \$1, \$4, \$5}'"

        ;;
    id) 
        # Execute the id command
        exec_cmd="id | sed -E 's/[ ,]/\t\t/g; s/\t\t/\t\t\n/g'"
        ;;
    chage)
        # Execute the chage command
        exec_cmd="chage -l user_999 | awk -F: '/Last password change|Password expires|Account expires/ {print \$1 "\n" \$2 "\n"}'"
        ;;
    env) 
        # Execute the env command
        exec_cmd="env | grep -E '^(PATH|HOME|SHELL|USER|LOGNAME|PWD|LANG|LC_ALL|TZ|SSH_AUTH_SOCK)='"
        ;;
    /etc/sudoers)
        # Display info of sudoers file
        exec_cmd="sudo grep -E '^[^#]*ALL=\(ALL(:ALL)?\) ALL' /etc/sudoers"
        ;;
    /etc/passwd)
        # Display info of passwd file
        exec_cmd="grep '/bin/bash' /etc/passwd"
        ;;
    /etc/group)
        # Display info of group file
        exec_cmd="cut -d: -f1,3 /etc/group | head -n 10"
        ;;
    /var/log/auth.log)
        # Display info of auth.log file
        exec_cmd="grep -E 'failed password|authentication failure' /var/log/auth.log | tail -n 20 | awk '{print \$1, \$2, \$3, \$4, \$7, \$8}'"
        ;;
    *)
        # Handle invalid command
        echo "Invalid command, please use a correct command or codeword"
        exit 1
        ;;
esac

# Execute the selected command
eval "$exec_cmd"
