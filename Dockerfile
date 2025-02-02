# PHP Apache Dockerfile
FROM php:8.2-apache

# Install dependencies and PostgreSQL dev files
RUN apt-get update && apt-get install -y \
    libpq-dev \
    zip \
    unzip

# Install PHP extensions for PostgreSQL
RUN docker-php-ext-install \
    pdo \
    pdo_pgsql \
    pgsql

# Enable Apache mod_rewrite and mod_dir
RUN a2enmod rewrite dir

# Set working directory
WORKDIR /var/www/html

# Apache configuration to enable .htaccess
RUN echo '<Directory /var/www/html>\n\
    AllowOverride All\n\
</Directory>' >> /etc/apache2/apache2.conf

# Set DirectoryIndex to prioritize index.php
RUN echo "DirectoryIndex index.php index.html" >> /etc/apache2/apache2.conf