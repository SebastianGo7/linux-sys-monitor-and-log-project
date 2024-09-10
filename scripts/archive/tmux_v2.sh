#!/bin/bash
#====================================================
# TITLE:            tmux_v2.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-08-31
# USAGE:            ./main_v4.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          2.1.0
#====================================================

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

sleep 1

tmux attach-session -t $SESSION_NAME

# tmux panes are filled and refreshed through refresh_panes script
