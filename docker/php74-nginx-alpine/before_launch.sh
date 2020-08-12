# Fix volume permissions
/bin/chown -R www-data:www-data /var/www/html/files;
/bin/chown -R www-data:www-data /var/www/html/web;
/bin/chown -R www-data:www-data /var/www/html/app;

# Uncomment following line to enable automatic migration for your theme at each docker start
# /usr/bin/sudo -u www-data bin/roadiz themes:migrate -n Base
