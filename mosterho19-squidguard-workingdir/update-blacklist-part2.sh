#!/bin/bash
## If using the "update-blacklist.sh" program's wget failed, then 
## open the website with a browser, download the blacklists.tar.gz file, 
## move the tar.gz file to squidguard/db then run this script.
## Don't forget to change your working directory back to (yourworkingdirectory) before running this!

receivedvalue=$1
if [ -z "$receivedvalue" ]; then 
    echo "Parameter/argument variable is empty, changing the received value to '0' (OK to rebuild blacklist and whitelist)"
    receivedvalue=0
fi
export $(cat mosterho19-docker-path.env)
my_pwd=$MOSTERHO19SQUIDGUARDPATH
cd "$my_pwd/squidguard/db"

## If tar file was manually pulled from website, it should have been copied from a Download folder to the squidguard/db folder
if [ "$receivedvalue" -eq 0 ] ; then
    sudo tar -xvzf blacklists.tar.gz
    cd "$my_pwd/squidguard"
    echo "Extraction of blacklist successful... "
else
    echo "Error during download of blacklists... running the rebuild using existing blacklist and whitelist only"
fi
cd ${my_pwd}

container_result=$(sudo bash "${my_pwd}/capture-containerid.sh")

## squidGuard needs the db folder to have proxy as owner in order to run.
sudo chown -R proxy:proxy ${my_pwd}/squidguard
echo "Performing rebuild of blacklists and whitelist in ${my_pwd}/squidguard..."
sudo docker exec -it $container_result squidGuard -d -C all
## It looks silly to run the chown again, 
## but if the above squidGuard command creates new files as root, the owner must be changed to proxy.
sudo chown -R proxy:proxy ${my_pwd}/squidguard
## If your uptime requirements of this application are not strict, consider just stopping and restarting squidGuard rather than doing the reconfigure. 
sudo docker exec -it $container_result squid -k reconfigure
##echo "Starting script start-squidguard.sh -- stopping and starting squidguard to use updated whitelist and blacklists in ${my_pwd}/squidguard..."
##sudo bash ${my_pwd}/start-squidguard.sh
echo "End of process...Container ID is: ${container_result}"