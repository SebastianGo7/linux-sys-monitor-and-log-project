#!/bin/bash
#====================================================
# TITLE:            personalized_cronjob_creator_v1.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-09-05
# USAGE:            ./personalized_cronjob_creator_v1.sh
# DEPENDENCIES:     Visudo changes necessary
# LICENSE:          MIT License
# VERSION:          1.0.0
#====================================================

# Define the base directory for the log files
LOG_DIR="/var/log/custom_logs"
mkdir -p $LOG_DIR

# Check if the correct number of arguments is provided
if [ "$#" -ne 16 ]; then
    echo "Usage: $0 <log_control_1> ... <log_control_8> <freq_1> ... <freq_8>"
    exit 1
fi

# Initialize the LOG_CONTROL and FREQ arrays with input arguments
LOG_CONTROL=("${@:1:8}")
FREQ=("${@:9:8}")

# Patch to the script to be sourced
SCRIPT_PATH="/home/user_999/Documents/SysMonitor/main_v4_development/cronrocks.sh"

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

# Function to create a cron job
create_cron_job() {
    local frequency="$1"
    local job_command="$2"

    # Generate cron command based on a frequency
    local cron_time=""
    case $frequency in 
        1) cron_time="* * * * *" ;;      # Every minute
        2) cron_time="*/5 * * * *" ;;    # Every 5 minutes
        3) cron_time="*/10 * * * *" ;;   # Every 10 minutes
        4) cron_time="*/30 * * * *" ;;   # Every 30 minutes
        5) cron_time="0 * * * *" ;;      # Every hour
        6) cron_time="0 */6 * * *" ;;    # Every 6 hours
        7) cron_time="0 0 * * *" ;;      # Every day
        8) cron_time="0 0 * * 0" ;;      # Every week
        *) cron_time="0 * * * *" ;;      # Default to hourly if incorrect value
    esac

    # Escape single quotes in the job command
    local escaped_command=$(echo "$job_command" | sed "s/'/'\"'\"'/g")

    # The full job command as it would appear in the crontab
    local full_job_command="$cron_time bash -c 'source $SCRIPT_PATH; $escaped_command'"

    # Add the new cron job
    (crontab -l ; echo "$full_job_command") | crontab -
}

# Function to remove a cron job based on the job command
remove_cron_job() {
    local command_prefix="$1"
    
    # Remove existing cron jobs matching the job command
    crontab -l | grep -v -F "$job_command" | crontab -
}

# Prepare the log commands
commands=(
    "log_command '/var/log/custom_logs/timezone.log' 'cat /etc/timezone' 'Timezone' '${LOG_CONTROL[0]}'"
    "log_command '/var/log/custom_logs/systemctl_ssh_status.log' 'systemctl status ssh | grep -E \"Active:|Loaded:|Main PID:|CGroup:\" | head -n 4' 'Systemctl SSH Status' '${LOG_CONTROL[1]}'"
    "log_command '/var/log/custom_logs/sysctl_settings.log' 'sudo sysctl -a | grep -E \"^(net.ipv4.ip_forward |kernel.hostname|vm.swappiness|kernel.randomize_va_space|kernel.sysrq|kernel.dmesg_restrict|vm.overcommit_memory)\"' 'Sysctl Settings' '${LOG_CONTROL[2]}'"
    "log_command '/var/log/custom_logs/top_cpu_processes.log' 'ps -eo pid,%cpu,%mem,comm --sort=-%cpu | head -n 5' 'Top CPU Processes' '${LOG_CONTROL[3]}'"
    "log_command '/var/log/custom_logs/crontab_entries.log' 'crontab -l | grep -v \"^#\"' 'Crontab Entries' '${LOG_CONTROL[4]}'"
    "log_command '/var/log/custom_logs/network_interfaces.log' 'ip addr show up | awk \"/^[0-9]+:/ {print \\\$2} /link\\/ether/ {print \\\"  MAC:\\\", \\\$2} /inet / {print \\\"  IP:\\\", \\\$2}\"' 'Network Interfaces' '${LOG_CONTROL[5]}'"
    "log_command '/var/log/custom_logs/firewall_settings.log' 'sudo firewall-cmd --list-all | head -n 9' 'Firewall Settings' '${LOG_CONTROL[6]}'"
    "log_command '/var/log/custom_logs/fstab_configuration.log' 'sudo tail -n +9 /etc/fstab | cut -c -44 | fold -w 44' 'fstab Configuration' '${LOG_CONTROL[7]}'"
)

# Prepare the pure commands for removal purposes
pure_commands=(
    "cat /etc/timezone"
    "systemctl status ssh | grep -E \"Active:|Loaded:|Main PID:|CGroup:\" | head -n 4"
    "sudo sysctl -a | grep -E \"^(net.ipv4.ip_forward |kernel.hostname|vm.swappiness|kernel.randomize_va_space|kernel.sysrq|kernel.dmesg_restrict|vm.overcommit|memory)\""
    "ps -eo pid,%cpu,%mem,comm --sort=-%cpu | head -n 5"
    "crontab -l | grep -v \"^#\""
    "ip addr show up | awk '/^[0-9]+:/ {print \\$2} /link\\/ether/ {print \"  MAC:\", \\$2} /inet / {print \"  IP:\", \\$2}'"
    "sudo firewall-cmd --list-all | head -n 9"
    "sudo tail -n +9 /etc/fstab | cut -c -44 | fold -w 44"
)

# First, remove all relevant cron jobs
for pure_command in "${pure_commands[@]}"; do
    remove_cron_job "$pure_command"
done

# Then, add the cron jobs based on the control flags and frequencies
for i in "${!commands[@]}"; do
    command="${commands[$i]}"
    if [ "${LOG_CONTROL[$i]}" -eq 1 ]; then
        create_cron_job "${FREQ[$i]}" "$command"
    fi
done





