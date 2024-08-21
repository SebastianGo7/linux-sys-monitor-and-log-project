#!/bin/bash
#====================================================
# TITLE:            tmux_panes_display_cmds_v1.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-08-21
# USAGE:            ./main_v1.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          1.0.0
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
    env) 
        # Execute the env command
        exec_cmd="env | grep -E '^(PATH|HOME|SHELL|USER|LOGNAME|PWD|LANG|LC_ALL|TZ|SSH_AUTH_SOCK)='"
        ;;
    *)
        # Handle invalid command
        echo "Invalid command, please use a correct command or codeword"
        exit 1
        ;;
esac

# Execute the selected command
eval "$exec_cmd"
