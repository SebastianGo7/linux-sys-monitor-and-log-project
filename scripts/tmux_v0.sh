#!/bin/bash
#====================================================
# TITLE:            tmux_v0.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-08-21
# USAGE:            ./main_v1.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          0.1.0
#====================================================

# tmux division into 4 parts

# Define session name
SESSION_NAME="grid_session_2x2_2"

# Create a new tmux session with a specified name, and start it in detach mode
tmux new-session -d -s $SESSION_NAME

# Split the window into a grid
# Split the window into two vertical panes
tmux split-window -h

# Split the right pane into two horizonal panes
tmux split-window -v

# Select the right pane and split it into two vertical panes
tmux select-pane -t 0
tmux split-window -v

# Select the top-left pane
tmux select-pane -t 0

#tmux resize-pane -t 0 -y 20
#tmux resize-pane -t 1 -y 20
#tmux resize-pane -t 2 -y 20
#tmux resize-pane -t 3 -y 20

# Attach to the tmux session
tmux attach-session -t $SESSION_NAME





