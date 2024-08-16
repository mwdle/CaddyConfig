# Caddyfile and Docker Compose Configuration  

A sample Caddyfile and Docker Compose file for Caddy.  

## Important Details  

* You must change the ```DOCKER_VOLUMES``` path in the ```.env``` file to a folder on your system where you wish to store container files (used in Docker Compose bind mounts).  

### Starting the container  

In your terminal, ```cd``` to the directory containing the ```docker-compose.yml``` and ```.env``` files. Run the following command: ```docker compose up -d```  
Your container should be up and running and your Adguard Home Dashboard will be accessible after you configure your reverse proxy and connect your Docker Networks accordingly! DNS will be available on port 53 on the host machine.  

### Disclaimer  

This repository is provided as-is and is intended for informational and reference purposes only. The author assumes no responsibility for any errors or omissions in the content or for any consequences that may arise from the use of the information provided. Always exercise caution and seek professional advice if necessary.  
