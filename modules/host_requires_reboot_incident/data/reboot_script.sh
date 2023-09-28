

#!/bin/bash



# Define variables

HOSTNAME=${HOSTNAME}



# Schedule the reboot

echo "Rebooting the host now..."

sudo shutdown -r now



# Wait for the reboot to complete

echo "Waiting for host to reboot..."

sleep 60