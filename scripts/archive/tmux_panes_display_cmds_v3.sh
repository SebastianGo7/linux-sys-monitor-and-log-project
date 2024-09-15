#!/bin/bash
#====================================================
# TITLE:            tmux_panes_display_cmds_v3.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-09-14
# USAGE:            ./main_v5.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          3.1.0
#====================================================

# Name of file necessary to display anomalies
LOGS_ANOMALIES_DETECTOR_SCRIPT="./logs_anomalies_detector_v2.sh"

# Check if a command argument is provided

if [ "$#" -ne 1 ]; then
    echo "Provide a valid cmd or code word please"
    exit 1
fi

# Retrieve the command argument
COMMAND=$1

# Use a case statment for different commands and code words

case "$COMMAND" in
    menu_info) 
        # Display the menu info 
        exec_cmd='echo -e "\nEmpty pane, to display further info later"'
        ;;
    last)
        # Execute the last command
        exec_cmd="last | awk '{print \$1}' | sort | uniq -c | sort -nr"
        ;;
    ulimit) 
        # Execute the ulimit command
        exec_cmd="ulimit -a | sed 's/)/)\n/g' | grep --color=never -A 9 '^max locked memory'"
        ;;
    who)
        # Execute the who command
        exec_cmd="who | awk '{print \$1, \$4, \$5}'"

        ;;
    id) 
        # Execute the id command
        exec_cmd="id | sed -E 's/[ ,]/\t\t/g; s/\t\t/\t\t\n/g'"
        ;;
    chage)
        # Execute the chage command
        exec_cmd="chage -l user_999 | awk -F: '/Last password change|Password expires|Account expires/ {print \$1 \"\\n\" \$2 \"\\n\"}'"
        ;;
    env) 
        # Execute the env command
        exec_cmd="env | grep -E '^(PATH|HOME|SHELL|USER|LOGNAME|PWD|LANG|LC_ALL|TZ|SSH_AUTH_SOCK)='"
        ;;
    systemctl)
        # Execute the systemctl command
        exec_cmd="systemctl status ssh | grep -E 'Active:|Loaded:|Main PID:|CGroup:' | head -n 4"
        ;;
        
    /etc/sudoers)
        # Display info of sudoers file
        exec_cmd="sudo grep -E '^[^#]*ALL=\(ALL(:ALL)?\) ALL' /etc/sudoers"
        ;;
    /etc/passwd)
        # Display info of passwd file
        exec_cmd="grep '/bin/bash' /etc/passwd"
        ;;
    /etc/group)
        # Display info of group file
        exec_cmd="cut -d: -f1,3 /etc/group | head -n 10"
        ;;
    /var/log/auth.log)
        # Display info of auth.log file
        exec_cmd="grep -E 'failed password|authentication failure' /var/log/auth.log | tail -n 20 | awk '{print \$1, \$2, \$3, \$4, \$7, \$8}'"
        ;;
# --------------New category Essential Commands---------------
 #   systemctl)    
 #       # Execute the systemctl command
 #       exec_cmd="systemctl status ssh | grep -E 'Active:|Loaded:|Main PID:|CGroup:' | head -n 4"
 #       ;;
    mpstat)    
        # Execute the mpstat command
        exec_cmd="mpstat | awk 'NR==3 || NR==4 {gsub(\",\", \".\", \$3); gsub(\",\", \".\", \$5); gsub(\",\", \".\", \$6); gsub(\",\", \".\", \$11); if (NR==3) {print \"CPU\", \"User%\", \"System%\", \"IOwait%\", \"Idle%\"}; if (NR==4) {print \$2, \$3, \$5, \$6, \$12}}'"
        ;;
    free) 
        # Execute the free command
        exec_cmd="free -h | awk ' NR1==1 {print \"Memory and Swap information.\"} NR==2 {printf \"Mem Total: %s\\n\",\$2} NR==2 {printf \"Mem Used: %s\\n\", \$3} NR==2 {printf \"Mem Free: %s\\n\", \$3} NR==3 {printf \"Mem Available: %s\\n}\",\$4} NR==2 {printf \"Swap Total: %s\\n\",\$2} NR==3 {printf \"Swap Used: %s\\n\", \$3} NR==3 {printf \"Swap Free: %s\\n\",\$4}'"
        ;;
    strace)   
        # Execute the strace command
        exec_cmd="strace -o all_syscalls.log ls"
        ;;
    dstat_cpu)    
        # Execute the dstat command (cpu)
        exec_cmd="dstat -c 1 1 | awk 'BEGIN {print \"Time   CPU_User CPU_Sys CPU_Idle\"} NR > 2 {time = \$1; cpu_usr = \$2; cpu_sys = \$3; cpu_idle = \$4; printf \"%-6s %-8s %-6s %-6s\\n\", time, cpu_usr, cpu_usr, cpu_sys, cpu_idle;}'"
        ;;
    dstat_mem)
        # Execute the dstat command (memory)
        exec_cmd="dstat -m 1 1 | awk 'BEGIN {print \"Time    Mem_Used Mem_Buff Mem_Cache\"} NR > 2 {time = \$1; mem_used = \$2; mem_buff = \$3; mem_cache=\$4; printf \"%-6s %-8s %-6s %-6s\\n\", time, mem_used, mem_buff, mem_cache; }'"
        ;;
# --------------New category Operations Deployment---------------
    sysctl)   
        # Execute the sysctl command
        exec_cmd="sudo sysctl -a | grep -E '^(net\.ipv4\.ip_forward |kernel\.hostname |vm\.swappiness |kernel\.randomize_va_space |kernel\.sysrq|kernel\.dmesg_restrict |vm\.overcommit_memory)'"
        ;;
    uptime)
        # Execute the uptime command
        exec_cmd="uptime"
        ;;
    top)
        # Execute the top command
        exec_cmd="top -b -n 1 | awk 'NR>6{print \$1, \$2, \$9, \$10, \$12, \$13}'| head -n 5"
        ;;    
    ps)
        # Execute the ps command
        exec_cmd="ps -eo pid,%cpu,%mem,comm --sort=-%cpu | head -n 5"
        ;;
    crontab)
        # Execute the crontab command
        exec_cmd="crontab -l | grep -v '^#'"
        ;;
    journalctl)
        # Execute the journalctl command
        exec_cmd="journalctl -xe | grep -i Shell | tail -n 4"
        ;;
    timezone)
        # Display info of timezone file
        exec_cmd="cat /etc/timezone"
        ;;
#--------------New category Network---------------
    ipaddr_show)
        # Execute the ip addr show command
        exec_cmd="ip addr show up | awk '/^[0-9]+:/ {print \$2} /link\\/ether/ {print \"  MAC:\", \$2} /inet / {print \"  IP:\", \$2}'"
        ;;
    hostnamectl)
        # Execute the hostnamectl command
        exec_cmd="hostnamectl"
        ;;
    ss_ltpn)
        # Execute the ss ltpn command
        exec_cmd="ss -ltpn | awk 'NR==1 {print \"STATE\", \"RECV-Q\", \"SEND-Q\", \"LOCAL ADDRESS:PORT\", \"REMOTE ADDRESS:PORT\"}; NR>1 {print \$1, \$2, \$3, \$4, \$5}'"
        ;;
    date)
        # Execute the date command
        exec_cmd="date"
        ;;
    firewalld)
        # Execute the firewalld command
        exec_cmd="sudo firewall-cmd --list-all | head -n 9"
        ;;
    /proc/net/tcp)
        # Display info of tcp file
        exec_cmd="cat /proc/net/tcp | awk '{print \$1, \$2, \$3, \$4, \$5}'"
        ;;
#--------------New category Storage---------------
    df)
        # Execute the df command
        exec_cmd="df -h"
        ;;
    iostat)
        # Execute the iostat command
        exec_cmd="iostat | grep -v loop | head -n 12 | awk '{print \$1, \$2, \$3, \$4}'"
        ;;
    vmstat)
        # Execute the vmstat command
        exec_cmd="vmstat | awk '{print \$1, \$2, \$3, \$4, \$5, \$6}'"
        ;;
    lsblk)
        # Execute the lsblk command
        exec_cmd="lsblk | grep -v loop"
        ;;
    fdisk)
        # Execute the fdisk command
        exec_cmd="sudo fdisk -l | grep /dev/sda: -A6"
        ;;
    du)
        # Execute the du command
        exec_cmd="find . -maxdepth 1 -type f -exec du -h {} +"        
        ;;
    /proc/mdstat)
        # Display info of mdstat file
        exec_cmd="cat /proc/mdstat"
        ;;
    /etc/fstab)
        # Display info of fstab file
        exec_cmd="sudo tail -n +9 /etc/fstab | cut -c -44 | fold -w 44"
        ;;
    /proc/partitions)
        # Display info of partitions file
        exec_cmd="cat /proc/partitions | grep -v loop"
        ;;
# --------------New category anomalies---------------         
    ftp_check)
        # Display the dates of recent ftp anomalies
        exec_cmd="$LOGS_ANOMALIES_DETECTOR_SCRIPT ftp"
        ;;
    ssh_check)
        # Display the dates of recent ssh anomalies
        exec_cmd="$LOGS_ANOMALIES_DETECTOR_SCRIPT ssh"
        ;;
    ip_check)
        # Display the dates of recent ip anomalies
        exec_cmd="$LOGS_ANOMALIES_DETECTOR_SCRIPT ip"
        ;;
    timezone_check)
        # Display the dates of recent timezone anomalies
        exec_cmd="$LOGS_ANOMALIES_DETECTOR_SCRIPT timezone"
        ;;
    spec._char_ip_check)
        # Display the dates of recent special char ip anomalies
        exec_cmd="$LOGS_ANOMALIES_DETECTOR_SCRIPT special_char_ip"
        ;;
    spec._char_timezone_check)
        # Display the dates of recent special char timezone anomalies
        exec_cmd="$LOGS_ANOMALIES_DETECTOR_SCRIPT special_char_timezone"
        ;;
    *)
        # Handle invalid command
        echo $COMMAND
        echo "Invalid command, please use a correct command or codeword"
        exit 1
        ;;
esac

# Execute the selected command
eval "$exec_cmd"
