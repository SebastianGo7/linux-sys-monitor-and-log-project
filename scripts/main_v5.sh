#!/bin/bash
#====================================================
# TITLE:            main_v5.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-09-14
# USAGE:            ./main_v5.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          5.1.0
#====================================================

# Name of the file where seslected commands will be saved
FILE_NAME="user_arguments_v0.txt"

# Clear the file content before writing new data
> $FILE_NAME

# Define array with options into 5 categories
category1=("who" "last" "ulimit" "env" "id" "chage" "/etc/sudoers" "/etc/passwd" "/etc/group" "/var/log/auth.log")
category2=("systemctl" "mpstat" "free" "strace" "dstat_cpu" "dstat_mem")
category3=("dstat_mem" "sysctl" "uptime" "top" "ps" "crontab" "journalctl" "timezone")
category4=("ipaddr_show" "hostnamectl" "ss_ltpn" "date" "firewalld" "/proc/net/tcp")
category5=("df" "iostat" "vmstat" "lsblk" "fdisk" "du" "/proc/mdstat" "/etc/fstab" "/proc/partitions")
category6=("ftp_check" "ssh_check" "ip_check" "timezone_check" "spec._char_ip_check" "spec._char_timezone_check")

options=("${category1[@]}" "${category2[@]}" "${category3[@]}" "${category4[@]}" "${category5[@]}" "${category6[@]}")


# Function to display current options
show_options() {

    local terminal_width
    terminal_width=$(tput cols)
    local threshold_width=80


    echo "This is a program to display specific important output of chosen commands."
    echo "Please choose 4 commands by entering its number one after the other."
    echo " " 

    print_category() {
        local category=("${!1}")
        if [ $terminal_width -ge $threshold_width ]; then
            half=$(((${#category[@]} + 1) / 2))
            column1=("${category[@]:0:$half}")
            column2=("${category[@]:$half}")
        else
            column1=("${category[@]}")
        fi
         
        for ((i = 0; i < ${#column1[@]}; i++)); do
            printf "%-3s %-20s" "$((i+1+start_index)))" "${column1[$i]}"
            if [ $terminal_width -ge $threshold_width ] && [ $i -lt ${#column2[@]} ]; then
                printf "%-3s %-20s\n" "$((i+half+1+start_index)))" "${column2[$i]}"
            else
                echo ""
            fi
        done
        start_index=$((start_index + ${#category[@]}))
    }
    start_index=0

    echo "Category 1: Users and Groups"
    print_category category1[@]

    echo -e "\nCategory 2: Essential Commands"
    print_category category2[@]

    echo -e "\nCategory 3: Operations Deployment"
    print_category category3[@]

    echo -e "\nCategory 4: Networking"
    print_category category4[@]

    echo -e "\nCategory 5: Storage"
    print_category category5[@]

    echo -e "\nCategory 6: Checking for anomalies"
    print_category category6[@]
 

    echo ""
    echo "q) Exit the program."
    echo ""
    if [ ${#selected_options[@]} -gt 0 ];
        then
        # Display chosen options so far
        echo -e "Chosen options so far: ${selected_options[*]}\n"
    fi
}


# Function to handle category-specific removal of options
retrieve_and_update_options() {
    # Retrieve the selected option
    selected_option="${options[$((global_var_selection -1 ))]}"

    # Check if the selected option is already chosen
    if [[ " ${selected_options[*]} " == *" $selected_option "* ]]; then
        echo "Option '$selected_option' is already selected. Please choose a different option. "
    else
        selected_options+=("$selected_option")

    # Remove the selected option from the available options in all categories
    update_category_options "category1"
    update_category_options "category2"
    update_category_options "category3"
    update_category_options "category4"
    update_category_options "category5"
    update_category_options "category6"
    
    # Rebuild the combined options array
    options=("${category1[@]}" "${category2[@]}" "${category3[@]}" "${category4[@]}" "${category5[@]}" "${category6[@]}")
    
    fi
}


# Helper function to update a category array after selection deleting chosen cmds
update_category_options() {
    local category_name=$1
    local update_category=()
    local opt

    # Get the category array dynamically by name
    eval "category=(\"\${${category_name}[@]}\")"

    # Remove the selected option from the category
    for opt in "${category[@]}"; do
        if [[ "$opt" != "$selected_option" ]]; then
            update_category+=("$opt")
        fi
    done

    # Update the category array with the new list
    eval "${category_name}=(\"\${update_category[@]}\")"
}



# Function to promt the user to select an option
get_selection() {
    local prompt="$1"
    local choice
    while :; do
        read -rp "$prompt" choice
        if [[ "$choice" == "q" ]]; then
            echo "Exiting the script."
            exit 0
        elif [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#options[@]}));
        then
            global_var_selection=($choice)
            return 
        else
            echo "Invalid input. Please enter a number between 1 and ${#options[@]}."
        fi
    done
}


# Array to store user-selected options
selected_options=()

global_var_selection="nth chosen"

# Check if tmux is running, if it is kill its panes
if tmux ls > /dev/null 2>&1; then
    echo "tmux is running"
    sleep 1
    tmux kill-pane -t 5
    tmux kill-pane -t 4
    tmux kill-pane -t 3
    tmux kill-pane -t 2
    tmux kill-pane -t 1
else
    echo "tmux is not running"
    sleep 1
fi

# Loop to get 4 unique options from the user
while [ ${#selected_options[@]} -lt 4 ]; do
    clear
    show_options

    # Check if options are available to select
    # If no options are available, inform the user and exit the loop
    if [ ${#options[@]} -eq 0 ]; then
        echo "No more options available to choose from."
        break
    fi

    echo "Select option $((${#selected_options[@]} + 1)): "
    get_selection


    # Handle the selected option and upgrade categories
    retrieve_and_update_options

done


# Display the selections of the user
echo "You selected:"
for option in "${selected_options[@]}"; do 
    echo "$option"

    echo "$option" >> $FILE_NAME
done


# Calling script, which open tmux panes with chosen comands
./tmux_v3.sh ${selected_options[0]} ${selected_options[1]} ${selected_options[2]} ${selected_options[3]}    

