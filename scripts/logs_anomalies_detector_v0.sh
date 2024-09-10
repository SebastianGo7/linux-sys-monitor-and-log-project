#!/bin/bash
#====================================================
# TITLE:            logs_anomalies_detector_v0.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-09-06
# USAGE:            ./logs_anomalies_detector_v0.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          0.1.0
#====================================================

# Define log file location 
LOG_FILE="/var/log/custom_logs/firewall_settings.log"

# Extract all "Log Date" lines where ftp appears in the 10 lines before
log_dates=$(grep "ftp" "$LOG_FILE" -B10 | grep "Date")

# Debug print grep result
#echo "extracted log dates:"
#echo "$log_dates"
#echo ""

# Convert the log dates to an array, splitting by newline instead of spaces
IFS=$'\n' log_dates_array=($log_dates)

# Get the number of entries in the array
total_dates=${#log_dates_array[@]}

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
last="${log_dates_array[$((total_dates -1))]}"

# Calculate intermediate values for 4 values
# Divide the range into 5 steps, 4 intermediate + the first
step=$(( (total_dates -2) / 5 ))


# Extract 4 intermediate values spaced evenly
mid1="${log_dates_array[$((1 * step))]}"
mid2="${log_dates_array[$((2 * step))]}"
mid3="${log_dates_array[$((3 * step))]}"
mid4="${log_dates_array[$((4 * step))]}"


# Header message
echo "First, divided middle, and last detected anomalies"

#echo "${#log_dates_array[@]}"
#echo "${log_dates-array[10]}"

# Print the selected values
echo "$first"
echo "$mid1"
echo "$mid2"
echo "$mid3"
echo "$mid4"
echo "$last"

# Reset IFS to default
unset IFS

