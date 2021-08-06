FROM php:5.6-apache

LABEL Name=laravel4.2 Version=1.0.2

#hacer que la consola no sea interactiva
ENV DEBIAN_FRONTEND=noninteractive
#--------------------------------

#define la zona horaria y el lenguaje del sistema
ENV TZ=America/Tijuana
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV LANGUAGE=es_ES.UTF-8
ENV LANG=es_ES.UTF-8
ENV LC_ALL=es_ES.UTF-8

RUN apt-get update && \
    apt-get install -y locales locales-all

RUN locale-gen es_ES && \
    locale-gen es_ES.UTF-8 && \
    update-locale


#instalar apache y php
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libpcre3-dev \
        libxml2-dev

RUN docker-php-ext-install mcrypt gd mbstring pdo pdo_mysql zip xml

#soap
RUN docker-php-ext-install soap

#mongo
#RUN pecl install mongo && docker-php-ext-enable mongo

#herramientas utiles
RUN apt-get install -y wget && \
    apt-get install -y curl && \
    apt-get install -y vim && \
    apt-get install -y cron

#-------------------------

# memory limit php
RUN echo "memory_limit=-1" > /usr/local/etc/php/conf.d/memory-limit.ini
#---------------------------------------------------------------------

# limite de archivos
RUN echo "file_uploads = On \n memory_limit = 100M \n upload_max_filesize = 100M \n post_max_size = 100M \n max_execution_time = 600" > /usr/local/etc/php/conf.d/uploads.ini
#---------------------------------------------------------------------------

#composer, git y node
RUN apt-get update && \
    curl -s https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN apt-get install -y git-core openssl libssl-dev python3 
#----------------------

# Cleanup
RUN apt-get autoremove -y && \
    apt-get autoclean && \
    apt-get clean 
#---------------------

#configurar proyecto
EXPOSE 80

ENV APP_HOME /var/www/html

RUN mkdir -p /opt/data/public && \
    rm -r /var/www/html && \
    ln -s /opt/data $APP_HOME

#--------traer config de apache--------
RUN rm /etc/apache2/sites-enabled/000-default.conf
ADD 000-default.conf /etc/apache2/sites-enabled
#===============================================

RUN a2enmod rewrite

WORKDIR /opt/data

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

