#!/bin/bash
## Script to download the blacklists.tar.gz file from the ftp site and then run the update-blacklist-part2.sh script to extract and rebuild the blacklists and whitelist.
echo
echo "$(date): *** Begin of update-blacklist.sh script ***"

cd /opt/mosterho19-squidguard-workingdir
export $(cat mosterho19-docker-path.env)
cd "$MOSTERHO19SQUIDGUARDPATH/squidguard/db"

##  The following wget is a bit fussy and doesn't always work. Please see "update-blacklist-part2.sh".
sudo mv blacklists.tar.gz blacklists-backup.tar.gz 
sudo wget -dv --user anonymous --password anonymous@example.com ftp://ftp.ut-capitole.fr/pub/reseau/cache/squidguard_contrib/blacklists.tar.gz
exitcode=$?
if [ $exitcode -ne 0 ]; then
    echo "Error code ${exitcode}: wget failed to download the file."
    echo "*** See readme.md documentation to use an alternate method of downloading the blacklists using update-blacklist-part2.sh."
    sudo mv blacklists-backup.tar.gz blacklists.tar.gz
    exit 1
else 
    echo "Download of blacklists-backup.tar.gz successful!"
fi

cd "/$MOSTERHO19SQUIDGUARDPATH"
sudo bash update-blacklist-part2.sh $exitcode
echo "$(date): *** End of update-blacklist.sh script ***"