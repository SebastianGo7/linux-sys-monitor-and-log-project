#!/bin/bash
#====================================================
# TITLE:            cronrocks_v0.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-09-05
# USAGE:            ./personalized_cronjob_creator_v1
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          0.0.0
#====================================================

# Define the base directory for the log files (if needed, adjust the directory)
LOG_DIR="/var/log/custom_logs"

# Create the directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Function to log command output
log_command() {
    local log_file="$1"
    local command="$2"
    local header="$3"
    local control_flag="$4"
    
    if [ "$control_flag" -eq 1 ]; then
        # Append log date and header to the log file
        echo "### Log Date: $(date) ###" >> "$log_file"
        echo -e "\n--- $header ---" >> "$log_file"
        
        # Execute the command and append its output to the log file
        eval "$command" >> "$log_file" 2>&1
        
        # Append a footer to the log file
        echo -e "\n##############################\n" >> "$log_file"
    fi
}


