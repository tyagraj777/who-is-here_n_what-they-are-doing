# comprehensive script to monitor user logins, file changes, processes affected by logged-in users or service accounts, and provide continuous updates in real-time.
# The script can be run by root or normal users with proper permissions.

# refer detail README fpr usage 



#!/bin/bash

# Check if the script is running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script can be run by root for full monitoring. It can also be run by normal users with necessary permissions."
    exit 1
fi

# Function to monitor logged-in users
check_logged_in_users() {
    echo "Logged-in Users:"
    who
    echo ""
}

# Function to check active processes and their owners
check_active_processes() {
    echo "Active Processes by Users:"
    ps aux --sort=user
    echo ""
}

# Function to monitor file changes using inotify
check_file_changes() {
    echo "Monitoring File Changes (Ctrl+C to stop)..."
    inotifywait -m / --exclude '(/tmp|/var/log)' -e modify,create,delete
    echo ""
}

# Function to track altered files and processes
track_files_and_processes() {
    echo "Tracking Affected Files and Processes..."
    lsof +D /home
    echo ""
}

# Function to track system logs for user-specific actions
check_system_logs() {
    echo "Monitoring System Logs (recent user activity)..."
    journalctl -xe | grep 'user'
    echo ""
}

# Display instructions
echo "System Monitoring Script"
echo "Press [CTRL+C] to stop monitoring."
echo "------------------------------------"
echo ""

# Continuous monitoring loop
while true; do
    check_logged_in_users
    check_active_processes
    check_file_changes
    track_files_and_processes
    check_system_logs
    sleep 10
done
