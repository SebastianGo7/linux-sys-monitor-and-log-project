#!/bin/bash
#====================================================
# TITLE:            main_v0.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-07-30
# USAGE:            ./main_v0.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          0.0.0
#====================================================

# Function to display the menu
show_menu() {
    PS3="Select an option please [1-5]: "
    options=("Option who/n" "Option last" "Option ulimit -a" "Option env" "Option id")
    
    select option in "${options[@]}"; do
        case $REPLY in
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
}

# Main script loop
while true; do
    clear
    show_menu
    echo -n "Please press enter to return to the menu.."
    read -r 
done

