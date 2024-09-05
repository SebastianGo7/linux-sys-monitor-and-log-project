#!/bin/bash
#====================================================
# TITLE:            personalized_cronjob_creator_v0.2.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-09-04
# USAGE:            ./personalized_cronjob_creator_v0.2.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          0.2.0
#====================================================

# Define the base directory for the log files
LOG_DIR="/var/log/custom_logs"

# Create the directory if it does not exist
mkdir -p $LOG_DIR

# Function to log command output
log_command() {
    local log_file="$1"
    local command="$2"
    local header="$3"
    local control_flag="$4"

    if [ "$control_flag" -eq 1 ]; then
        echo "### Log Date: $(date) ###" >> "$log_file"
        echo -e "\n--- $header ---" >> "$log_file"
        eval "$command" >> "$log_file"
        echo -e "\n #########################\n" >> "$log_file"
    fi    
}

# Function to create a basic cron job that logs command output
create_cron_job() {
    local frequency="$1"
    local log_file="$2"
    local command="$3"
    local header="$4"
    local control_flag="$5"

    # Generate cron expression based on a frequency
    local cron_time=""
    case $frequency in 
        1) cron_time="* * * * *" ;;      # Every minute
        2) cron_time="*/5 * * * *" ;;    # Every 5 minutes
        3) cron_time="*/10 * * * *" ;;   # Every 10 minutes
        *) cron_time="0 * * * *" ;;      # Default to hourly if incorrect value
    esac

    # Escape single quotes for bash -c
    local escaped_command=$(echo "$command" | sed "s/'/'\"'\"'/g")

    # The full job command as it would appear in the crontab
    local full_job_command="$cron_time bash -c 'source /home/user_999/Documents/SysMonitor/main_v4_development/cronrocks_v0.sh; log_command \"$log_file\" \"$escaped_command\" \"$header\" $control_flag'"

    # Add the new cron job
    (crontab -l ; echo "$full_job_command") | crontab -
}

# Function to remove a cron job based on the job command
remove_cron_job() {
    local job_command="$1"
    
    # Remove existing cron jobs matching the job command
    crontab -l | grep -v -F "$job_command" | crontab -
}

# Testing usage
#create_cron_job 1 "/var/log/custom_logs/uptime.log" "uptime" "Uptime" 1
remove_cron_job "uptime"

