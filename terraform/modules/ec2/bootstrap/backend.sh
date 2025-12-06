#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

# --- Configuration ---
PHP_VERSION="8.3"

echo "--- STARTING LARAVEL SERVER PROVISIONING ---"

# --- 1. Install PHP 8.3 PPA and Update ---
echo "1. Adding Ondrej Surý PPA for PHP ${PHP_VERSION} and updating..."
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

# --- 2. Install Essential Packages ---
echo "2. Installing PHP, Apache, and required extensions..."
sudo apt install -y \
    php${PHP_VERSION}-{cli,fpm,mysql,xml,mbstring,curl,zip} \
    apache2 \
    unzip \
    git

# --- 3. Install Composer Globally ---
echo "3. Installing Composer globally..."
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"

# --- 4. Configure Apache for PHP-FPM ---
echo "4. Configuring Apache Virtual Host..."
# Define variables used in the config file
HOME_DIR=$(eval echo ~${SUDO_USER})
LARAVEL_ROOT="${HOME_DIR}/app/public"
PHP_SOCKET="/run/php/php${PHP_VERSION}-fpm.sock"

# Enable necessary Apache modules (proxy_fcgid for FPM, rewrite for clean URLs)
sudo a2enmod proxy_fcgid setenvif rewrite mpm_prefork

# Create Apache virtual host configuration
sudo bash -c "cat > /etc/apache2/sites-available/000-default.conf << EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot $LARAVEL_ROOT

    <Directory $LARAVEL_ROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # Route PHP requests to FPM socket
    <FilesMatch \.php$>
        SetHandler \"proxy:unix:$PHP_SOCKET|fcgi://localhost/\"
    </FilesMatch>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF"

# --- 5. Final Service Restart ---
echo "5. Restarting services..."
sudo systemctl restart php${PHP_VERSION}-fpm
sudo systemctl restart apache2

echo "--- Bootstrap backend completed successfully ---"