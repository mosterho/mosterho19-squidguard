## Run these on the server. Must add 127.0.0.1 proxy.emergencyservicessoftweare.net to the /etc/hosts file.  The proxy is running on port 3129.  The certs are in ./certs

##  (no good, --proxy-resolve is not supported in curl 7.68.0) added entry to /etc/hosts.
##sudo curl -v -I https://example.com   --proxy-resolve proxy.emergencyservicessoftware.net:3129:127.0.0.1   --proxy https://proxy.emergencyservicessoftware.net:3128   --proxy-cacert ./certs/rootCA.crt   --proxy-cert ./certs/test-client-01.crt --proxy-key ./certs/test-client-01.key

##  GOOD
sudo curl -v -I https://example.com   --resolve proxy.emergencyservicessoftware.net:3129:127.0.0.1  --proxy https://proxy.emergencyservicessoftware.net:3129   --proxy-cacert ./certs/rootCA.crt   --proxy-cert ./certs/test-client-01.crt --proxy-key ./certs/test-client-01.key 

## GOOD
sudo curl -v -I https://example.com  --proxy https://proxy.emergencyservicessoftware.net:3129  --proxy-cacert ./certs/rootCA.crt  --proxy-cert ./certs/test-client-01.crt    --proxy-key ./certs/test-client-01.key 

## GOOD failed to connect on purpose.
sudo curl -I https://example.com   --proxy https://proxy.emergencyservicessoftware.net   --proxy-cacert ./certs/rootCA.crt   --proxy-cert ./certs/test-client-01.crt   --proxy-key ./certs/test-client-01.key   --cacert ./certs/rootCA.crt 

## GOOD (got failed to connect to proxy error since some certs are missing)
sudo curl -I https://example.com   --proxy https://proxy.emergencyservicessoftware.net   --proxy-cacert ./certs/rootCA.crt
