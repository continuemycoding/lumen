# 使用 PHP 带有 Apache 的官方镜像作为基础镜像
FROM php:8-apache

# 安装 PDO 扩展
RUN docker-php-ext-install pdo pdo_mysql

# 安装 ZIP 扩展和 unzip
RUN apt-get update && \
    apt-get install -y libzip-dev unzip && \
    docker-php-ext-install zip

# 安装 Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

# 安装 Git
RUN apt-get install -y git

# 设置 Apache 服务器的文档根目录为 public 文件夹
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}/!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 设置工作目录
WORKDIR /var/www/html

# 使用内联命令设置权限并启动 Apache
CMD chown -R www-data:www-data . && \
    a2enmod rewrite && \
    apache2-foreground
