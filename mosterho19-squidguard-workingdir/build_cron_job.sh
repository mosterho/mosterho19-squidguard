##  Run crontab -e and add the following to the bottom of the file. 
CRON_TZ=America/New_York
0 2 * * * (/opt/mosterho19-squidguard-workingdir/update-blacklist.sh && echo "$(date): Job completed successfully") >> /var/log/update-blacklist.log 2>&1