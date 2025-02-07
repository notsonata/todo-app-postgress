# PHP Apache Dockerfile
FROM php:8.2-apache

# Install dependencies, PostgreSQL client and dev files
RUN apt-get update && apt-get install -y \
    libpq-dev \
    postgresql-client \
    dos2unix \
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

# Create directory for initialization scripts
RUN mkdir -p /docker-entrypoint-initdb.d

# Copy initialization SQL script
COPY init.sql /docker-entrypoint-initdb.d/

# Copy application files from the src directory
COPY src/*.php /var/www/html/
COPY src/*.css /var/www/html/

# Copy and set up the entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN dos2unix /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Apache configuration to enable .htaccess and set DirectoryIndex
RUN echo '<Directory /var/www/html>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
    DirectoryIndex index.php index.html\n\
</Directory>' > /etc/apache2/sites-available/000-default.conf

# Set the entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]