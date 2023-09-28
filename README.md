
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Host requires reboot incident.
---

This incident type occurs when a host requires a reboot. It could be due to various reasons like an update, configuration changes, or malfunctioning. If the host is not rebooted, it could cause performance issues or even lead to downtime. Therefore, immediate action is necessary to resolve the issue and restore the system to its optimal state. The incident could be triggered automatically by monitoring tools or reported by users.

### Parameters
```shell
export INSTANCE_IP_ADDRESS="PLACEHOLDER"

export SERVICE_NAME="PLACEHOLDER"

export DISK_PATH="PLACEHOLDER"

export HOSTNAME="PLACEHOLDER"
```

## Debug

### 1. Check which instance requires a reboot
```shell
ssh ${INSTANCE_IP_ADDRESS} "uptime"
```

### 2. Check if the disk space is full
```shell
ssh ${INSTANCE_IP_ADDRESS} "df -h"
```

### 3. Check if there are any processes that are consuming high CPU or memory
```shell
ssh ${INSTANCE_IP_ADDRESS} "top"
```

### 4. Check if there are any logged errors related to the host or instance
```shell
journalctl -u ${SERVICE_NAME} --since "24 hours ago"
```

### 5. Check if there are any pending software updates
```shell
ssh ${INSTANCE_IP_ADDRESS} "sudo apt update && sudo apt list --upgradable"
```

### 6. Check the system logs for any hardware-related errors
```shell
dmesg | grep -i error
```

### 7. Check the network connectivity between the host and other services
```shell
ping ${SERVICE_NAME}
```

### 8. Check the status of any relevant services or daemons
```shell
systemctl status ${SERVICE_NAME}
```

### The host system might have encountered a critical error or failure, leading to a reboot requirement.
```shell


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


```

## Repair

### Reboot the host
```shell


#!/bin/bash



# Define variables

HOSTNAME=${HOSTNAME}



# Schedule the reboot

echo "Rebooting the host now..."

sudo shutdown -r now



# Wait for the reboot to complete

echo "Waiting for host to reboot..."

sleep 60
```

### Verify that the host has successfully rebooted and that all services and applications have started up correctly.
```shell


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


```