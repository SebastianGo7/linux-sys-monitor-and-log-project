#!/bin/bash
#====================================================
# TITLE:            refresh_panes_v2.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-09-14
# USAGE:            ./refresh_panes_v2.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          2.0.0
#====================================================

#argument_value_1="$1"

FILE_NAME="user_arguments_v0.txt"
TMUX_PANES_DISPLAY_CMDS_SCRIPT="./tmux_panes_display_cmds_v4.sh"

if [ ! -f "$FILE_NAME" ]; then
    echo "Error: $FILE_NAME not found!"
    exit 1
fi

# update interval is set to user argument or to standart value
if [ "$#" -ne 1 ]; then
    update_interval="5"
    echo 'The update interval is: 5s.'
else
    update_interval="$1"
    echo "The update interval is: ${update_interval}s."
fi

# Read commands from the file
cmd1=$(sed -n '1p' $FILE_NAME)
cmd2=$(sed -n '2p' $FILE_NAME)
cmd3=$(sed -n '3p' $FILE_NAME)
cmd4=$(sed -n '4p' $FILE_NAME)

echo $cmd1
echo $cmd2
echo $cmd3
echo $cmd4

# Variables for display_table
width1=18
width2=18
cmd6="20"


# Sent a command to each pane

tmux send-key -t 3 "$(cat << EOF

#Define display table function
display_table() {
    
    # Format and display the table
    echo ""
    printf "%-${width1}s | %-${width2}s\n" "$cmd1" "$cmd2"
    printf "+%s+%s+\n" "$(printf '%*s' "$width1" | tr ' ' '-')" "$(printf '%*s' "$width2" | tr ' ' '-')"
    printf "%-${width1}s | %-${width2}s\n" "$cmd3" "$cmd4"
}


#$(declare -f display_table) 
display_table "$cmd1" "$cmd2" "$cmd3" "$cmd4"
EOF
)" C-m

# static pane
tmux send-key -t 0 "$TMUX_PANES_DISPLAY_CMDS_SCRIPT menu_info" C-m

# Refresh panes with the given commands or arguments

while true; do
    # date is used to check update every 5 seconds

    tmux send-key -t 1 "$TMUX_PANES_DISPLAY_CMDS_SCRIPT $cmd1" C-m
    tmux send-key -t 1 "date" C-m
 
    tmux send-key -t 4 "$TMUX_PANES_DISPLAY_CMDS_SCRIPT $cmd2" C-m
    tmux send-key -t 4 "date" C-m

    tmux send-key -t 2 "$TMUX_PANES_DISPLAY_CMDS_SCRIPT $cmd3" C-m
    tmux send-key -t 2 "date" C-m

    tmux send-key -t 5 "$TMUX_PANES_DISPLAY_CMDS_SCRIPT $cmd4" C-m
    tmux send-key -t 5 "date" C-m

    sleep $update_interval
done

