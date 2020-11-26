printenv | sed 's/^\(.*\)$/export \1/g' | grep -E "^export (SYMFONY|APP|ROADIZ|MYSQL|JWT|MAILER|SOLR|VARNISH)" > /var/www/html/project_env.sh

# Fix volume permissions
/bin/chown -R www-data:www-data /var/www/html/files;
/bin/chown -R www-data:www-data /var/www/html/web;
/bin/chown -R www-data:www-data /var/www/html/app;

/bin/chmod +x /var/www/html/project_env.sh;

# Uncomment following line to enable automatic migration for your theme at each docker start
#/usr/bin/sudo -u www-data -- bash -c "/var/www/html/project_env.sh; bin/roadiz themes:migrate -n Base"
