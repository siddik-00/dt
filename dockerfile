# Use PHP 8.3 CLI/FPM
FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl unzip libpng-dev libonig-dev libxml2-dev \
    libzip-dev zip nodejs npm \
    libgmp-dev libpq-dev pkg-config \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# Optional: install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy project
COPY . .

# Install PHP dependencies
RUN composer install --no-interaction --optimize-autoloader

# Install Node dependencies
RUN npm install

# Expose ports for Laravel & Vite
EXPOSE 8000 5173

# Command to run Laravel + Vite
CMD ["sh", "-c", "php artisan serve --host=0.0.0.0 & npm run dev -- --host"]
