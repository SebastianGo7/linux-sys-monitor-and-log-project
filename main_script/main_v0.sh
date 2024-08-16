#!/bin/bash
#====================================================
# TITLE:            main_v0.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-07-30
# USAGE:            ./main_v0.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          0.5.0
#====================================================

# Define the initial array with command options
options=("who" "last" "ulimit -a" "env" "id")

# Function to display current options
show_options() {
    echo "Available options:"
    local index=1
    for opt in "${options[@]}"; do
        echo "$index) $opt"
        ((index++))
    done
}

# Function to promt the user to select an option
get_selection() {
    local prompt="$1"
    local choice
    while :; do
        read -rp "$prompt" choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#options[@]}));
        then
            echo "$choice"
            global_var_selection=($choice)
            echo "Te1"
            return 
        else
            echo "Invalid input. Please enter a number between 1 and ${#options[@]}."
            echo "Te2"
        fi
    done
}

# Array to store user-selected options
selected_options=()

global_var_selection="nth chosen"

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
    #selection=$(get_selection "Select option $((${#selected_options[@]} + 1)): ")

    # Retrieve the selected option
    selected_option="${options[$((selection - 1))]}"


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

####1411
