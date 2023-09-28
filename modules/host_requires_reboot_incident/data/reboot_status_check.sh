

#!/bin/bash



# Verify that the host has successfully rebooted

echo "Verifying host status"

if ping -c 3 ${HOSTNAME} &> /dev/null

then

    echo "Host has successfully rebooted"

else

    echo "Host reboot failed"

    exit 1

fi



# Check that all services and applications have started up correctly

if systemctl status ${SERVICE_NAME} | grep 'Active: active (running)' &> /dev/null

then

    echo "All services and applications have started up correctly"

else

    echo "Some services or applications failed to start up"

    exit 1

fi



exit 0