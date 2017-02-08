# Roadiz Standard Edition

This is the production-ready edition for Roadiz. It is meant to lock your *Apache/Nginx* server root to the `web/` folder, keeping your app sources and theme secure.

```shell
composer create-project roadiz/standard-edition
```

## Usage

For the moment, we don’t have any warm-up script to generate configuration and entry-points automatically. Follow the next step to create a dev-ready environment.

```shell
# Copy config and add your database credentials in…
cp app/conf/config.default.yml app/conf/config.yml

# Copy Vagrantfile and use a dedicated IP
# add this IP to your /etc/hosts
cp samples/Vagrantfile.sample Vagrantfile

# Adapt Makefile with your theme name and NPM/Yarn
# This will be useful to generate assets and clear cache
# in one command
nano Makefile 

# Copy entry-points and authorize Vagrant IP to access dev, clear_cache and install
cp samples/install.php.sample web/install.php
cp samples/dev.php.sample web/dev.php
cp samples/index.php.sample web/index.php
cp samples/clear_cache.php.sample web/clear_cache.php

# Init VM
vagrant up --no-provision
vagrant provision --provision-with=roadiz,mailcatcher
```

## Update Roadiz sources

Simply call `composer update --no-dev` to upgrade Roadiz. 
You’ll need to execute regular operations if you need to migrate your database.
