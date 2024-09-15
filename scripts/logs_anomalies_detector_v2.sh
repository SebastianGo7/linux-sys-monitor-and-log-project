#!/bin/bash
#====================================================
# TITLE:            logs_anomalies_detector_v2.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-09-14
# USAGE:            ./logs_anomalies_detector_v2.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          2.0.0
#====================================================

# Define log file locations
LOG_DIR="/var/log/custom_logs"
FIREWALL_LOG="$LOG_DIR/firewall_settings.log"
SSH_STATUS_LOG="$LOG_DIR/systemctl_ssh_status.log"
NETWORK_LOG="$LOG_DIR/network_interfaces.log"
TIMEZONE_LOG="$LOG_DIR/timezone.log"
CRONTAB_ENTRIES_LOG="$LOG_DIR/crontab_entries.log"
FSTAB_CONFIGURATION_LOG="$LOG_DIR/fstab_configuration.log"
SYSCTL_SETTING_LOG="LOG_DIR/sysctl_settings.log"


# Define report folder location
REPORT_DIR="./reports"

# Create the anomaly_reports folder if it doesn't exist
if [ ! -d "$REPORT_DIR" ]; then 
    mkdir "$REPORT_DIR"
fi

# Check if the user provided an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <search_term>"
    echo "Valid search terms: logs_ssh, logs_ip, logs_timezone, logs_crontab, logs_firewall, log_sysctl, log_fstab, ftp, ssh, ip, timezone, special_char_ip, special_char_timezone"
    exit 1
fi

# Set the search term and select the log file based on the argument
case "$1" in 
    logs_firewall)
        SEARCH_TERM="CEST"
        LOG_FILE="$FIREWALL_LOG"
        LINES_BEFORE=2
        ;;
    logs_ssh)
        SEARCH_TERM="CEST"
        LOG_FILE="$SSH_STATUS_LOG"
        LINES_BEFORE=2
        ;;
    logs_ip)
        SEARCH_TERM="CEST"
        LOG_FILE="$NETWORK_LOG"
        LINES_BEFORE=2
        ;;
    logs_timezone)
        SEARCH_TERM="CEST"
        LOG_FILE="$TIMEZONE_LOG"
        LINES_BEFORE=2
        ;;
    logs_crontab)
        SEARCH_TERM="CEST"
        LOG_FILE="$CRONTAB_ENTRIES_LOG"
        LINES_BEFORE=2
        ;;
    logs_sysctl)
        SEARCH_TERM="CEST"
        LOG_FILE="$SYSCTL_SETTING_LOG"
        LINES_BEFORE=2
        ;;
    logs_fstab)
        SEARCH_TERM="CEST"
        LOG_FILE="$FSTAB_CONFIGURATION_LOG"
        LINES_BEFORE=2
        ;;

    ftp)
        SEARCH_TERM="ftp"
        LOG_FILE="$FIREWALL_LOG"
        LINES_BEFORE=9
        ;;
    ssh)
        SEARCH_TERM="inactive"
        LOG_FILE="$SSH_STATUS_LOG"
        LINES_BEFORE=9
        ;;
    ip)
        # Use of regex for flexible matching, allowing for subnet masks like /16
        SEARCH_TERM="255\.255\.255\.255(/[^ ]*)?"
        LOG_FILE="$NETWORK_LOG"
        LINES_BEFORE=13
        ;;
    timezone)
        SEARCH_TERM="Antarctica"
        LOG_FILE="$TIMEZONE_LOG"
        LINES_BEFORE=9
        ;;
    special_char_ip)
        SEARCH_TERM='@'
        LOG_FILE="$NETWORK_LOG"
        LINES_BEFORE=13
        ;;
    special_char_timezone)
        SEARCH_TERM='%'
        LOG_FILE="$TIMEZONE_LOG"
        LINES_BEFORE=9
        ;;
    *)
        echo "Invalid search terms. Valid options are: logs_ssh, logs_ip, logs_timezone, logs_crontab, logs_firewall, log_sysctl, log_fstab, ftp, ssh, ip, timezone, special_char_ip, special_char_timezone"
        exit 1
        ;;
esac

# Check if the selected log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file '$LOG_FILE' not found!"
    exit 1
fi

# Extract all "Log Date" lines where the search term appears in the appropriate number of lines before
# Adding '-a' flag to treat the file as text and prevent issues with binary data
log_dates=$(grep -aE "$SEARCH_TERM" "$LOG_FILE" -B"$LINES_BEFORE" | grep -a "Date")

# Convert the log dates to an array, splitting by newline instead of spaces
IFS=$'\n' log_dates_array=($log_dates)

# Get the number of entries in the array
total_dates=${#log_dates_array[@]}

# Initialize report output
report_output="First, divided middle, and last detected anomalies\n"

# Check if there are no log dates
if [[ $total_dates -eq 0 ]]; then
    echo "No anomalies found."
    exit 0
fi

# If there are fewer than 6 log dates, display all of them and exit
if [[ $total_dates -lt 6 ]]; then
    echo "Less than 6 log dates available. Displaying all:"
    for date in "${log_dates_array[@]}"; do
        echo "$date"
        report_output+="$date\n"
    done
else

    # Extract the first and last values
    first="${log_dates_array[0]}"
    last="${log_dates_array[$((total_dates - 1))]}"

    # Calculate intermediate values for 4 values
    # Divide the range into 5 steps, 4 intermediate + the first
    step=$(( (total_dates - 2) / 5 ))


    # Extract 4 intermediate values spaced evenly
    mid1="${log_dates_array[$((1 * step))]}"
    mid2="${log_dates_array[$((2 * step))]}"
    mid3="${log_dates_array[$((3 * step))]}"
    mid4="${log_dates_array[$((4 * step))]}"

    # Print the selected values
    echo "$first"
    echo "$mid1"
    echo "$mid2"
    echo "$mid3"
    echo "$mid4"
    echo "$last"

    report_output+="$first\n$mid1\n$mid2\n$mid3\n$mid4\n$last\n"
fi

echo $1
# Determine the report file name based on the search term 
if [[ "$1" == *"logs"* ]]; then
    report_file="$REPORT_DIR/${1}_report.txt"
else
    report_file="$REPORT_DIR/${1}_anomaly_report.txt"
fi

echo -e "$report_output" > "$report_file"


echo "Report saved to: $report_file"

# Reset IFS to default
unset IFS

