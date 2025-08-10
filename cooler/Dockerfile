FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# Install Apache, PHP, and dependencies
RUN apt-get update && apt-get install -y apache2 libapache2-mod-php php-mysql openssh-server

# Set permissions for Apache to access application files
RUN chown -R www-data:www-data /var/www/html/
RUN service ssh start

COPY ./src /var/www/html

RUN sed -i 's/Options Indexes FollowSymLinks/Options FollowSymLinks/g' /etc/apache2/apache2.conf

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Apache server
CMD ["/bin/bash", "-c", "/usr/sbin/sshd -D & /usr/sbin/apache2ctl -D FOREGROUND"]