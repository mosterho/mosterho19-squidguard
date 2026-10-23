#!/bin/bash
## If using the "update-blacklist.sh" program's wget failed, then 
## open the website with a browser, download the blacklists.tar.gz file, 
## move the tar.gz file to /home/(yourworkingdir)/squidguard/db then run this script.
## Don't forget to change your working directory back to /home/(yourworkingdirectory) before running this!

receivedvalue=$1
if [ -z "$receivedvalue" ]; then 
    echo "Parameter/argument variable is empty, changing the received value to '0' (OK to rebuild blacklist and whitelist)"
    receivedvalue=0
fi

my_pwd=$(pwd)
cd "$my_pwd/squidguard/db"

## If tar file pulled from website, copy from Download to /var/lib/squidguard/db folder
if [ "$receivedvalue" -eq 0 ] ; then
    sudo tar -xvzf blacklists.tar.gz
    cd "$my_pwd/squidguard"
    echo "Extraction of blacklist successful... "
else
    echo "Error during download of blacklists... running the rebuild using existing blacklist and whitelist only"
fi
echo "Performing rebuild of blacklists and whitelist in ${my_pwd}/squidguard..."
container_result=$(sudo bash "${my_pwd}/capture-containerid.sh")
sudo chown -R proxy:proxy ${my_pwd}/squidguard
sudo docker exec -it $container_result squidGuard -d -C all
sudo docker exec -it $container_result squid -k reconfigure
echo "End of process...Container ID is: ${container_result}"