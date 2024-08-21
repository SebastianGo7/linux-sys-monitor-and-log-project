#!/bin/bash
#====================================================
# TITLE:            tmux_v0.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-08-21
# USAGE:            ./main_v0.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          0.4.0
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
tmux new-session -d -s $SESSION_NAME

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

# Sent a command to each pane
tmux send-key -t 0 './tmux_panes_display_cmds_v1.sh menu_info' C-m
tmux send-key -t 3 "$(cat << EOF 
$(declare -f display_table) 
display_table $argument_value_1 $argument_value_2 $argument_value_3 $argument_value_4
EOF
)" C-m 

tmux send-key -t 1 "./tmux_panes_display_cmds_v1.sh $argument_value_1" C-m
tmux send-key -t 4 "./tmux_panes_display_cmds_v1.sh $argument_value_2" C-m

tmux send-key -t 2 "./tmux_panes_display_cmds_v1.sh $argument_value_3" C-m
tmux send-key -t 5 "./tmux_panes_display_cmds_v1.sh $argument_value_4" C-m

tmux attach-session -t $SESSION_NAME


# important commands to test etc:
# tmux kill-window
# tmux list-panes
# tmux display -p '#{window_height}'
# tput lines
# tmux display-panes


