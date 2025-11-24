FROM php:8.5-apache

# install system packages for zip extension
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
 && docker-php-ext-install zip \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# activate Apache mod_rewrite
RUN a2enmod rewrite

# install Composer
COPY --from=composer/composer:latest /usr/bin/composer /usr/bin/composer

# set my own Apache site
# and set DocumentRoot to /var/www/html/public
COPY my-site.conf /etc/apache2/sites-available/000-default.conf

RUN mkdir /var/www/html/public
COPY ./src/* /var/www/html/

# set owner
RUN chown -R www-data:www-data /var/www/html
# RUN chown -R www-data:www-data /var/www/html/bootstrap
# RUN chown -R www-data:www-data /var/www/html/storage
