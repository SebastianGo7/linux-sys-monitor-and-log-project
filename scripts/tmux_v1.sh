#!/bin/bash
#====================================================
# TITLE:            tmux_v1.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-08-25
# USAGE:            ./main_v3.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          1.2.0
#====================================================


echo "Arguments: $@"

if [ "$#" -ne 4 ]; then
    echo "Please pass 4 commands to use $0"
    exit 1
fi

argument_value_1="$1"
argument_value_2="$2"
argument_value_3="$3"
argument_value_4="$4"

# tmux division into 6 parts, 3x2, upper two should only take about 20%
# the middle and lower each about 40% of the vertical length.

# Define session name
SESSION_NAME="grid_session_3x2"

    
# Create a new tmux session with a specified name, and start it in detach mode 
# Attach if session already exists
tmux new-session -d -s $SESSION_NAME || tmux attach-session -t $SESSION_NAME

# Split the window into a grid
# Split the window into two vertical panes
tmux split-window -h -t 0 -l '50%' 

# Split the right pane into two horizonal panes
tmux split-window -v -t 1 -l '80%'

# Split the left pane into two horizontal panes
tmux split-window -v -t 0 -l '80%'

# Split the bottom right pane into 2 panes horizontally
tmux split-window -v -t 3

# Split the bottom left pane into 2 panes horizontally
tmux split-window -v -t 1

# Define display table function
display_table() {

    if [ "$#" -ne 4 ] ; then
        echo "Please pass 4 commands to be displayed"
        exit 1
    fi

    argument_value_1="$1"
    argument_value_2="$2"
    argument_value_3="$3"
    argument_value_4="$4"

    # Define column widths
    width1=18
    width2=18

    # Format and display the table

    printf "%-${width1}s | %-${width2}s\n" "$argument_value_1" "$argument_value_2"
    printf "+%s+%s+\n" "$(printf '%*s' "$width1" | tr ' ' '-')" "$(printf '%*s' "$width2" | tr ' ' '-')"
    printf "%-${width1}s | %-${width2}s\n" "$argument_value_3" "$argument_value_4"

}

sleep 1


tmux attach-session -t $SESSION_NAME


# tmux panes are filled and refreshed through refresh_panes script
