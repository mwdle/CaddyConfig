# Caddyfile and Docker Compose Configuration  

A sample Caddyfile and Docker Compose file for Caddy.  

## Table of Contents  

* [Description](#caddyfile-and-docker-compose-configuration)  
* [Getting Started](#getting-started)  
* [License](#license)  
* [Disclaimer](#disclaimer)  

## Getting Started  

1. Clone the repository:  

    ```shell
    git clone https://github.com/mwdle/CaddyConfig.git
    ```  

2. Change the ```.env``` file properties:  

    ```properties
    DOCKER_VOLUMES=<PATH_TO_DOCKER_VOLUMES> # A folder on your system to store bind mounts for Docker containers.
    ```  

3. Copy the contents of CADDYFILE_SAMPLE into the DOCKER_VOLUMES folder specified in step 3 under a subfolder called Caddy (e.g. DOCKER_VOLUMES/Caddy/Caddyfile). Modify the Caddyfile to fit your needs.  
4. Change the networks listed in the Docker Compose file to the networks attached to the service(s) you want to proxy.  
5. Open a terminal in the directory containing the docker-compose file.  
6. Start the container:  

    ```shell
    docker compose up -d
    ```  

Your container should be up and running and your Caddy instance should be operating according to your Caddyfile.  

## License  

This project is licensed under the GNU General Public License v3.0 (GPL-3.0). See the [LICENSE](LICENSE.txt) file for details.  

## Disclaimer  

This repository is provided as-is and is intended for informational and reference purposes only. The author assumes no responsibility for any errors or omissions in the content or for any consequences that may arise from the use of the information provided. Always exercise caution and seek professional advice if necessary.  
