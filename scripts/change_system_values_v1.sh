#!/bin/bash
#====================================================
# TITLE:            change_system_values_v1.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-09-01
# USAGE:            ./change_system_values_v1.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          1.1.0
#====================================================

# Define the array with command options displayed for
# the user to choose

# chage
options1=(
    "Standard values" 
    "Password expires in 100 days" 
    "Account expires in 150 days" 
    "Account expires in 200 days"
)

# systemctl
options2=(
    "Standard values" 
    "Systemctl disable ssh" 
    "Systemctl restart ssh" 
    "Systemctl stop ssh"
)

# sysctl -a
options3=(
    "Standard values" 
    "Change hostname to user999-webserver" 
    "Disable ip forwarding" 
    "Set swappiness value to 10"
)

#top
options4=(
    "CPU intensive tasks with stress command for 20 seconds"
)

# ps
options5=(
    "CPU intensive writing task for 20 seconds"
)

# crontab
options6=(
    "Standard values" 
    "Add a cronjob" 
)

# journalctl -xe
options7=(
    "Add custom log entry"
    "Systemctl restart ssh" 
)

# cat /etc/timezone
options8=(
    "Standard values" 
    "Set timezone Europe/London" 
)

# ip addr show
options9=(
    "Standard values" 
    "Change docker ip address" 
    "Change docker Mac address" 
)


options=("${options1[@]}" "${options2[@]}" "${options3[@]}" "${options4[@]}" "${options5[@]}" "${options6[@]}" "${options7[@]}" "${options8[@]}" "${options9[@]}" )

# Function to display current options
show_options() {

    echo "This is a program to change system parameters."
    echo "Please choose one option by entering its number and pressing enter."
    echo " " 

    # index used to choose execute command later
    local index=1

    echo "Influence chage:"
    for opt in "${options1[@]}"; do
        echo "$index) $opt"
        ((index++))
    done

    echo -e "\nInfluence systemctl status ssh:"
    for opt in "${options2[@]}"; do
        echo "$index) $opt"
        ((index++))
    done

    echo -e "\nInfluence hostname:"
    for opt in "${options3[@]}"; do
        echo "$index) $opt"
        ((index++))
    done

    echo -e "\nInfluence top:"
    for opt in "${options4[@]}"; do
        echo "$index) $opt"
        ((index++))
    done

    echo -e "\nInfluence ps:"
    for opt in "${options5[@]}"; do
        echo "$index) $opt"
        ((index++))
    done

    echo -e "\nInfluence crontab:"
    for opt in "${options6[@]}"; do
        echo "$index) $opt"
        ((index++))
    done

    echo -e "\nInfluence journalctl:"
    for opt in "${options7[@]}"; do
        echo "$index) $opt"
        ((index++))
    done

    echo -e "\nInfluence /etc/timezone:"
    for opt in "${options8[@]}"; do
        echo "$index) $opt"
        ((index++))
    done
    echo -e "\nInfluence ip addr show:"
    for opt in "${options9[@]}"; do
        echo "$index) $opt"
        ((index++))
    done

    echo ""
    echo "q) Exit the program."
    echo ""
}

# Function to execute script
execute_script() {
    # use a case statement for different commands

    # Converting to zero-based index
    local option_index=$(($1 -1))
    echo "You selected: ${options[$option_index]}"

    case "$1" in
# influence chage    
        1)  
            # Disable password exiration 
            sudo chage -M -1 user_999
            # Disable account expiration            
            sudo chage -E -1 user_999
            # Set the last password change to July 3, 2024
            sudo chage -d 2024-07-03 user_999
            ;;
        2)
            # Set password expiration to 100 days
            sudo chage -M 100 user_999 
            ;;
        3)  
            # Set account expiration date to 150 days from now
            sudo chage -E $(date -d "+150 days" +"%Y-%m-%d") user_999       
            ;;
        4) 
            # Calculate the expiration date 200 days from now
            expiration_date=$(date -d "+200 days" +"%Y-%m-%d")
            # Set account expiration date to 200 days from now
            sudo chage -E "$expiration_date" user_999 
            ;;
# influence systemctl
        5) 
            # Enable SSH service to start at boot 
            sudo systemctl enable ssh
            # Restart the SSH service
            sudo systemctl restart ssh
            ;;
        6)  
            # Disable SSH service from starting at boot
            sudo systemctl disable ssh
            ;;
        7)  
            # Restart the SSH service
            sudo systemctl restart ssh
            ;;
        8)  
            # Stop the SSH service
            sudo systemctl stop ssh
            ;;
# influence sysctl -a
        9)
            # Set the system hostname to its standard
            sudo hostname user999-VirtualBox
            # Enable IP forwarding
            sudo sysctl -w net.ipv4.ip_forward=1
            # Set the kernel's swapiness value to 60
            sudo sysctl -w vm.swappiness=60
            ;;
        10)
            # Set the systems hostname to "user999-webserver"
            sudo hostname user999-webserver
            ;;
        11) 
            # Disable IP forwarding
            sudo sysctl -w net.ipv4.ip_forward=0
            ;;
        12)
            # Set the kernel's swapiness value to 10
            sudo sysctl -w vm.swappiness=10
            ;;

# influence top
        13) 
            # Run a CPU stress test using 30 cores for 20 seconds
            stress --cpu 30 --timeout 20
            ;;

# influence ps
        14) 
            # Run the "yes" command in the background, consuming CPU for 20 seconds
            timeout 20s yes >/dev/null &
            ;;


# influence crontab
        15) 
            # Removing the added cronjob
            
            # Defining Cronjob details
            COMMENT=" Cron job that runs on the 1st of every month at 1:30 AM"
            CRON_JOB_Part="echo \"Running on the 1st of every month at 1.30 am\""

            # Remove cronjob
            crontab -l | grep -v -e "$CRON_JOB_Part" -e "$COMMENT" | crontab -
            ;;

        16) 
            # Adding a cronjob
            
            # Defining Cronjob details
            COMMENT="# Cron job that runs on the 1st of every month at 1:30 AM"
            CRON_JOB="30 1 1 * * /bin/bash -c 'echo \"Running on the 1st of every month at 1.30 am\" >> /tmp/cron_monthly.log'"

            # Adding cronjob
            (
            crontab -l 2>/dev/null;
            echo "$COMMENT";
            echo "$CRON_JOB") | crontab -
            ;;

# influence journalctl -xe
        17) 
            # Add custom log entry
            sudo logger "Custom log shell entry by user_999"
            ;;

        18) 
            # Systemctl restart ssh to create log entry
            sudo systemctl restart sshd
            ;;

# influence /etc/timezone
        19) 
            # Set timezone to Europe/Berlin
            sudo timedatectl set-timezone Europe/Berlin
            ;;

        20) 
            # Set timezone to Europe/London
            sudo timedatectl set-timezone Europe/London
            ;;

# influence ip addr show
        21) 
            # Set standart ip address and mac address for docker0 network
            sudo ip addr del 172.17.0.22/16 dev docker0
            sudo ip link set dev docker0 address 02:42:a5:8a:1d:3b
            ;;

        22) 
            # Change ip address of docker0 network
            sudo ip addr add 172.17.0.22/16 dev docker0
            ;;

        23) 
            # Change Mac address docker0
            sudo ip link set dev docker0 address 02:42:a5:8a:1d:99
            ;;

        *)
            # Handle invalid command
            echo "Invalid option."
            exit 1
            ;;
    esac

}

# Function to promt the user to select an option
get_selection() {
    local choice

    read -rp "Select an option: " choice
    if [[ "$choice" == "q" ]]; then
        echo "Exiting the script."
        exit 0
    elif [[ "$choice" -ge 1 ]] && [[ "$choice" -le 23 ]];
    then
        execute_script "$choice"
    else
        echo "Your input is $choice"
        echo "Invalid input. Please enter a number between 1 and ${#options[@]}."
    fi
}


# Main script execution
show_options
get_selection


