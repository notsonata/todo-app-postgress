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

# Copy application files
COPY *.php /var/www/html/
COPY *.css /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Apache configuration to enable .htaccess and set proper permissions
RUN echo '<Directory /var/www/html>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' >> /etc/apache2/apache2.conf

# Set DirectoryIndex
RUN echo "DirectoryIndex index.php index.html" >> /etc/apache2/apache2.conf