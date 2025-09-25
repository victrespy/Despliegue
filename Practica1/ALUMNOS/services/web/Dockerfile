FROM php:8.2-apache

# mysqli
RUN docker-php-ext-install -j"$(nproc)" mysqli

#el nombre de la ruta donde se va a ver (de momento pongo esa, no se cunado se cambia)
WORKDIR /var/www/html 
#la ruta de la pagina de inicio
COPY src/ .

    