ARG PHP_VERSION=8.3
FROM php:${PHP_VERSION}-fpm

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libicu-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libwebp-dev \
    libonig-dev \
    libsodium-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    zlib1g-dev \
    git \
    unzip \
    cron \
  && rm -rf /var/lib/apt/lists/*

# GD with JPEG, WebP, FreeType support
RUN docker-php-ext-configure gd \
      --with-freetype \
      --with-jpeg \
      --with-webp

# Core Magento PHP extensions
RUN docker-php-ext-install -j"$(nproc)" \
    bcmath \
    ftp \
    gd \
    intl \
    mbstring \
    opcache \
    pdo_mysql \
    soap \
    sodium \
    sockets \
    xsl \
    zip \
    pcntl \
    xml \
    simplexml

# Install Redis extension via PECL (Magento session/cache backend)
RUN pecl install redis \
  && docker-php-ext-enable redis

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Non-root user matching nginx's nobody
RUN usermod -u 82 www-data && groupmod -g 82 www-data

WORKDIR /var/www/html

USER www-data

EXPOSE 9000

CMD ["php-fpm"]
