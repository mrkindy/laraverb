FROM php:8.3-fpm

# Set environment variables
ENV RUNNER_USER=1001
ENV RUNNER_GROUP=1001
ENV RUNNER_PORT=9000
ENV WORKDIR="/var/www/html"

# Set working directory
WORKDIR $WORKDIR

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libonig-dev \
    libzip-dev \
    libgd-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-external-gd
RUN docker-php-ext-install gd

# Install Redis
RUN pecl install redis \
&& rm -rf /tmp/pear \
&& docker-php-ext-enable redis

# Add user for laravel application
RUN groupadd -g $RUNNER_GROUP $RUNNER_GROUP
RUN useradd -u $RUNNER_USER -ms /bin/bash -g $RUNNER_GROUP $RUNNER_GROUP

# Set file limit for user reverb to 10000 files
RUN echo "$RUNNER_USER  soft  nofile  10000" >> /etc/security/limits.conf
RUN echo "$RUNNER_USER  hard  nofile  10000" >> /etc/security/limits.conf

# Create system user to run Composer and Artisan Commands
RUN mkdir -p /home/$RUNNER_USER/.composer && \
    chown -R $RUNNER_USER:$RUNNER_GROUP /home/$RUNNER_USER

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Change current user to reverb
USER $RUNNER_USER

# Install Laravel
RUN composer create-project laravel/laravel $WORKDIR

# Remove default .env file
RUN rm $WORKDIR/.env

# Install Brodacast and reverb
RUN php artisan install:broadcasting --without-node -n

# Set permission for laravel application
RUN chmod -R ug+rwx storage bootstrap/cache
RUN chgrp -R $RUNNER_GROUP storage bootstrap/cache

# Expose port 9000 and start reverb server
EXPOSE $RUNNER_PORT
CMD ["php","artisan","reverb:start"]
