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

2. Create a folder on your system for Docker bind mounts / storing container files. The folder should have the following structure:  

    ```shell
    docker_volumes/
    ├── Caddy/
    │   ├── Caddyfile
    │   ├── config/
    │   └── data/
    ```  

3. Change the ```.env``` file properties for your configuration:  

    ```properties
    DOCKER_VOLUMES=<PATH_TO_DOCKER_VOLUMES_FOLDER> # The folder created in the previous step.
    ```  

4. Copy the contents of Caddyfile_sample into DOCKER_VOLUMES/Caddy/Caddyfile as shown in the folder structure in step 2.  
5. Change the networks listed in the Docker Compose file to the networks attached to the service(s) you want to proxy.  
6. Open a terminal in the directory containing the docker-compose file.  
7. Start the container:  

    ```shell
    docker compose up -d
    ```  

Your container should be up and running and your Caddy instance should be operating according to your Caddyfile.  

## License  

This project is licensed under the GNU General Public License v3.0 (GPL-3.0). See the [LICENSE](LICENSE.txt) file for details.  

## Disclaimer  

This repository is provided as-is and is intended for informational and reference purposes only. The author assumes no responsibility for any errors or omissions in the content or for any consequences that may arise from the use of the information provided. Always exercise caution and seek professional advice if necessary.  
