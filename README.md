# linux-sys-monitor-and-log-project

Goal:
Create a Linux commandline based system monitor including mostly information which is valuable for the LFCS through shell scripts.
Extended Features will be: Dashboard elements, logs, log anomalies.

I challenge myself to on this software developing process to display my structured problem solving approach as well as my Linux skills. 

The System Monitor is split up into 5 Categories and I will start with Users and Groups:
Users and Groups
Essential Commands
Operations Deployment
Networking
Storage

Milestones:
1) Project Initiation
Develop project plan and schedule
Establish Git version control environment
Choose System Metrics and create Docs SystemMetrics_v0 and v1
Create README File

2) Initial Development 
Start Developing Main Script (v1): Implementing user input selection menu
Update Files if relevant changes

3) First Dashboard elements
Improve Main Script: Display System monitor dashboard with tmux
Improve Main Script (v2): Combine User input selection with tmux dashboard
Update Files if relevant changes

4) Text parsing integration
Create text parsing scripts for specific user files using tools as sed, cut, awk
And make them available in main script (v3)
Update Files if relevant changes

5) Continuous update and improvement
Ensure displayed items are updated continuously main script (v3) with refresh_pane script. 
Script change_system_values, which do changes so that these changes are visible on the dashboard when it updates
Update Files if relevant changes

6) Additional Scripts Development
Develop and integrate commands from other four categories. 
Develop further options for script change_system_values (v1) 
Update Files if relevant changes 
(main v4, tmux v3, tmuxpanes v3, refresh_p v1)

7) Extended Parsing and Display
Develop and integrate additional text parsing cmds. 
Develop further options for script change_system_values 
Update Files if relevant changes
(done together with milestone 6, therefore same versions)

8) Enhanced Logging and Monitoring 
Implement logging and monitoring script with options configurable by user input
Develop further options for script change_system_values (v2)
Update Files if relevant changes
(personalized_cronjob_creator_v1, main_v5, cronrocks_v0)

9) Anomaly Detection of Logs
Develop a scripts for anomaly detection (logs_anomalies_detector v1)
Develop further options for script change_system_values (v3) to create anomalies
Update Files if relevant changes (personalized_cronjob_creator v2)
Upload Libre Office Calc docs used for planning (SystemMetrics_v3, Logging_And_Anomalies_v1)

10) User interface unification
Create option to detect desired anomalies and display them running the main script (main_v6.sh) 
Update Files if relevant changes (tmux_panes_display_cmds_v4.sh) (logs_anomalies_detector_v2.sh) (refresh_panes_v1.sh)

11) Cronjob creator integration and packaging
Personalized cronjob creator script is integrated to main script
Package the system monitor to share with users 
Update Files if relevant changes

12) Further development
Adding Tips and tricks
Create User Manual
Update Files if relevant changes

13) Project Information and further development
Adding Project information and analysis
Update Files if relevant changes
