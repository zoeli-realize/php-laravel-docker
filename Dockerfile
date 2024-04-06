FROM richarvey/nginx-php-fpm:3.1.6

COPY . .

# Image config
ENV SKIP_COMPOSER 1
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

# Laravel config
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr

# Allow composer to run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN composer self-update

RUN apt update && apt install -y php8.2-dev &&  echo | pecl install mongodb && echo "extension=mongodb.so" >> /etc/php/8.2/cli/php.ini && echo "extension=mongodb.so" >> /etc/php/8.2/fpm/php.ini

RUN composer require mongodb/laravel-mongodb

RUN /etc/init.d/php8.2-fpm restart && service nginx reload

CMD ["/start.sh"]
