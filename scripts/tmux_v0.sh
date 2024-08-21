#!/bin/bash
#====================================================
# TITLE:            tmux_v0.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-08-21
# USAGE:            ./main_v1.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          0.2.0
#====================================================

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

# Sent a command to each pane
tmux send-key -t 0 'tput lines' C-m
tmux send-key -t 1 'tput lines' C-m
tmux send-key -t 2 'tput lines' C-m
tmux send-key -t 3 'tput lines' C-m
tmux send-key -t 4 'tput lines' C-m
tmux send-key -t 5 'tput lines' C-m

# Attach to the tmux session
tmux attach-session -t $SESSION_NAME

# important commands to test etc:
# tmux kill-window
# tmux list-panes
# tmux display -p '#{window_height}'
# tput lines
# tmux display-panes


