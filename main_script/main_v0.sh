#!/bin/bash
#====================================================
# TITLE:            main_v0.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-07-30
# USAGE:            ./main_v0.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          0.1.0
#====================================================

# Function to display the menu
show_menu() {
    echo "------------------------------------"
    echo "           System Monitor"
    echo "------------------------------------"
    echo "Please select an option: "
    echo
    echo "1. who"
    echo
    echo "2. last"
    echo
    echo "3. ulimit -a"
    echo
    echo "4. env"
    echo
    echo "5. id"
    echo "------------------------------------"
}
 
# Function to handle user input
get_choice() {
    local choice
    read -p "Enter your choice [1-3]: " choice
    echo "$choice"
}


# Main script logic
while true; 
do 
    show_menu
    user_choice=$(get_choice)

    case $user_choice in

        1)  
            echo "You chose 1"
            # Call bash script 1
            ;;
        2) 
            echo "You chose 2"
            # Call bash script 2
            ;;
        3) 
            echo "You chose 3"
            # Call bash script 3
            ;;
        4) 
            echo "You chose 4"
            # Call bash script 4
            ;;
        5)
            echo "You chose 5"
            # Call bash script 5
            ;;
        *)  echo "You chose an invalid option, please choose a number between 1 and 5."
            # In case no number is given
            ;;
    esac
done

