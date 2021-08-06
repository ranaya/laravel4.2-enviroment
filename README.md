# Create image
```bash
  
  git clone https://github.com/kevinvergara/laravel4.2-enviroment.git

  cd laravel4.2-enviroment/

  docker build -y kevinvegara92/laravel4.2-enviroment:latest .



```

# Steps to make apache server available for laravel

### 1.- Create container with system
```bash
docker run -d --rm -p 80:80 -v /proyect:/opt/data kevinvegara92/laravel4.2-enviroment:latest
```
### 2.- Enter the container
```bash
docker exec -it IdContainer bash
```
### 3.- Composer install
```bash
composer install
```
## Ready the server, you can access through port 80 or modify to worked in port 8000

### Note
#### There may be problems with folder permissions on unix, you must give permissions to /vendor, /app/storage

#### 
# docker-compose example

```yml

version: "3"

services:

  mysql56:
    image: mysql:5.6.51
    container_name: mysql56
    hostname: mysql56
    restart: always
    volumes:
      - ${WORKPATH}/mysql:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASS}
      - MYSQL_PASSWORD=${MYSQL_PASS}
      - MYSQL_DATABASE=${MYSQL_DB}
      - MYSQL_USER=${MYSQL_USR}

  web:
    links:
      - "mysql56"
    image: ranay4/pdfs:0.02
    container_name: servicios
    hostname: ${HOST_NAME}
    environment:
      - TZ=America/Tijuana
    ports:
      - 80:80
    volumes:
      - ${WORKPATH}/html:/opt/data
      - ${WORKPATH}/Cron:/opt/Cron

```
