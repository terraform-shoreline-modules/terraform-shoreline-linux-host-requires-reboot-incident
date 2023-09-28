

#!/bin/bash



# Check system logs for recent critical errors

if sudo grep -q 'CRITICAL' /var/log/syslog; then

    echo "System has encountered critical errors"

    echo "Reboot required"

    exit 0

fi



# Check system status for any failures

if sudo systemctl status | grep -q 'failed'; then

    echo "System has failed services"

    echo "Reboot required"

    exit 0

fi



# Check disk usage for critical levels

if [ "$(df -h ${DISK_PATH} | awk '{print $5}' | tail -n 1 | tr -d '%')" -ge 90 ]; then

    echo "Disk usage is critical"

    echo "Reboot required"

    exit 0

fi



echo "No issues found. System functioning normally."