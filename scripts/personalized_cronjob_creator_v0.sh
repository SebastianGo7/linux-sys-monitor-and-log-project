#!/bin/bash
#====================================================
# TITLE:            personalized_cronjob_creator_v0.1.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-09-04
# USAGE:            ./personalized_cronjob_creator_v0.1.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          0.1.0
#====================================================

# Function to create a basic cron job
create_cron_job() {
    local frequency="$1"
    local job_command="$2"

    # Generate cron expression based on a frequency
    local cron_time=""
    case $frequency in 
        1) cron_time="* * * * *" ;;      # Every minute
        2) cron_time="*/5 * * * *" ;;    # Every 5 minutes
        3) cron_time="*/10 * * * *" ;;   # Every 10 minutes
        *) cron_time="0 * * * *" ;;      # Default to hourly if incorrect value
    esac

    # The full job command as it would appear in the crontab
    local full_job_command="$cron_time $job_command"

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
#create_cron_job 1 "echo 'This is a test job'"
remove_cron_job "echo 'This is a test job'"
