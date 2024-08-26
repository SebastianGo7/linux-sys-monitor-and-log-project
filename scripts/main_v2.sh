#!/bin/bash
#====================================================
# TITLE:            main_v2.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-08-23
# USAGE:            ./main_v2.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          2.2.0
#====================================================

# Define the initial array with command options
options=("who" "last" "ulimit" "env" "id" "/etc/sudoers" "/etc/passwd" "/etc/group" "/var/log/auth.log")

# Function to display current options
show_options() {

    echo "This is a program to display specific important output of chosen commands."
    echo "Please choose 4 commands by entering its number one after the other."
    echo " " 
    echo "Available options:"
    local index=1
    for opt in "${options[@]}"; do
        echo "$index) $opt"
        ((index++))
    done
    echo ""
    echo "q) Exit the program."
    echo ""
    if [ ${#selected_options[@]} -gt 0 ];
        then
        # Display chosen options so far
        echo -e "Chosen options so far: ${selected_options[*]}\n"
    fi
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
    
    # Retrieve the selected option
    selected_option="${options[$((global_var_selection - 1))]}"

    # Check if the selected option is already chosen
    if [[ " ${selected_options[*]} " == *" $selected_option "* ]]; then
        echo "Option '$selected_option' is already selected. Please choose a different option."
    else
        selected_options+=("$selected_option")

        # remove the selected option from the available options
        new_options=()
        for opt in "${options[@]}"; do
            if [[ "$opt" != "$selected_option" ]]; then
                new_options+=("$opt")
            fi
        done
        options=("${new_options[@]}")

    fi
done


# Display the selections of the user
echo "You selected:"
for option in "${selected_options[@]}"; do 
    echo "$option"
done

# Calling script, which open tmux panes with chosen comands
./tmux_v1.sh ${selected_options[0]} ${selected_options[1]} ${selected_options[2]} ${selected_options[3]}    

