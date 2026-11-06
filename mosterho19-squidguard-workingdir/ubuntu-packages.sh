#!/bin/bash
echo 'copy and paste the following onto the ubuntu terminal session to easily update the system.'
echo 'Begin updating and installing Ubuntu updates.'
echo 'Once the "full-upgrade" and other installs run, you may see confirmation screens for outdated daemons and to reboot the system.'
echo 'You can hit "enter" to acccept these.'
echo ''

# Copy and paste from here if you wish
sudo apt update && 
sudo apt full-upgrade -y && 
sudo apt install docker docker.io docker-buildx unzip net-tools tree -y && \
sudo dpkg-reconfigure tzdata && 
sudo ifconfig && 
echo 'End of updates to system... If you received a message that you should reboot the system, you should do that now'