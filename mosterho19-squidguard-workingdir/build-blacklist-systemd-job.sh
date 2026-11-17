#!/bin/bash
######################################################################################################
## This script will create a systemd service for updating the SquidGuard blacklist.
##   Remember to change the Description and [Timer] sections for your needs.
######################################################################################################

## step 1 create service file.
sudo tee /etc/systemd/system/squidguard-update.service > /dev/null << 'EOF'
[Unit]
Description=Update SquidGuard Blacklist

[Service]
Type=oneshot
ExecStart=/opt/mosterho19-squidguard-workingdir/update-blacklist.sh
EOF


## step 2 create timer file.
sudo tee /etc/systemd/system/squidguard-update.timer > /dev/null << 'EOF'
[Unit]
Description=Run SquidGuard Blacklist Update on Wednesday and Saturday at 2 AM

[Timer]
OnCalendar=Wed,Sat *-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF


## step 3... you can copy/paste the following lines together in your terminal session... 
## and again in the future if you make any changes to the service or timer files.
##      After starting the service, it will appear that the program froze; it will likely take 2 minutes for it to complete.
##      Consider running "sudo journalctl -u squidguard-update.service" and confirm the results.
sudo chmod 755 /opt/mosterho19-squidguard-workingdir/*.sh 
sudo systemctl daemon-reload 
sudo systemctl enable --now squidguard-update.timer 

##sudo systemctl start squidguard-update.service

##  Extra commands to know:
# See when it last ran and when it runs next: systemctl list-timers squidguard-update.timer
# Check logs with automatic timestamps: sudo journalctl -u squidguard-update.service