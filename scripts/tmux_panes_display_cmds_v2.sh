#!/bin/bash
#====================================================
# TITLE:            tmux_panes_display_cmds_v2.sh
# DESCRIPTION:      Linux System Monitor
# AUTHOR:           Sebastian Gommel
# DATE:             2024-08-30
# USAGE:            ./main_v4.sh
# DEPENDENCIES:     No dependencies
# LICENSE:          MIT License
# VERSION:          2.1.0
#====================================================

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
    systemctl)    
        # Execute the systemctl command
        exec_cmd="systemctl status ssh | grep -E 'Active:|Loaded:|Main PID:|CGroup:' | head -n 4"
        ;;
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
    *)
        # Handle invalid command
        echo "Invalid command, please use a correct command or codeword"
        exit 1
        ;;
esac

# Execute the selected command
eval "$exec_cmd"
