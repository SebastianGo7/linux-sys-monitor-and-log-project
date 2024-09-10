#!/bin/bash
#====================================================
# TITLE:            logs_anomalies_detector_v0.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-09-09
# USAGE:            ./logs_anomalies_detector_v0.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          0.2.0
#====================================================

# Define log file location 
LOG_DIR="/var/log/custom_logs"
FIREWALL_LOG="$LOG_DIR/firewall_settings.log"
SSH_STATUS_LOG="$LOG_DIR/systemctl_ssh_status.log"
NETWORK_LOG="$LOG_DIR/network_interfaces.log"
TIMEZONE_LOG="$LOG_DIR/timezone.log"

# Check if the user provided an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <search_term>"
    echo "Valid search terms: ftp, ssh, ip, timezone, special_char_ip, special_char_timezone"
    exit 1
fi

# Set the search term and select the log file based on the argument
case "$1" in 
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
        echo "Invalid search term. Valid options are: ftp, ssh, ip, timezone, special_char_ip, special_char_timezone"
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
    done
    exit 0
fi

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


# Header message
echo "First, divided middle, and last detected anomalies"

# Print the selected values
echo "$first"
echo "$mid1"
echo "$mid2"
echo "$mid3"
echo "$mid4"
echo "$last"

# Reset IFS to default
unset IFS

