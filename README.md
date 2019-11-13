# Roadiz *Standard Edition* CMS

[![Join the chat at https://gitter.im/roadiz/roadiz](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/roadiz/roadiz?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Roadiz is a modern CMS based on a polymorphic node system which can handle many types of services and contents.
Its back-office has been developed with a high sense of design and user experience.
Its theming system is built to live independently from back-office allowing easy switching
and multiple themes for one content basis. For example, it allows you to create one theme
for your desktop website and another one for your mobile, using the same node hierarchy.
Roadiz is released under MIT license, so you can reuse
and distribute its code for personal and commercial projects.

## Documentation

* *Roadiz* website: http://www.roadiz.io
* *Read the Docs* documentation can be found at http://docs.roadiz.io
* *API* documentation can be found at http://api.roadiz.io
* *Forum* can be found at https://ask.roadiz.io

## Standard edition

This is the **production-ready edition** for Roadiz. It is meant to setup your *Apache/Nginx* server root to the `web/` folder, keeping your app sources and themes secure.

## Usage

```bash
# Create a new Roadiz project on develop branch
composer create-project roadiz/standard-edition;
# Navigate into your project dir
cd standard-edition;
# Create a new theme for your project
bin/roadiz themes:generate --symlink --relative FooBar;
```

Composer will automatically create a new project based on Roadiz and download every dependencies. 

Composer script will copy a default configuration file and your entry-points in `web/` folder automatically and a sample `Vagrantfile` in your project root.

### Update Roadiz and your own theme assets

```bash
composer update -o --no-dev

# Re-install your theme in public folder using relative symlinks (MacOS + Unix)
# remove --relative flag on Windows to generate absolute symlinks
bin/roadiz themes:assets:install --symlink --relative FooBar;
```

### Develop with *PHP* internal server

````bash
# Edit your Makefile "DEV_DOMAIN" variable to use a dedicated port
# to your project and your theme name.
nano Makefile;

# Launch PHP server
make dev-server;
````

### Develop with *Vagrant*

For development, here are some useful commands: 

```bash
# Edit your Vagrantfile and use a dedicated IP
# add this IP to your /etc/hosts
nano Vagrantfile;

# Adapt Makefile with your theme name and NPM/Yarn
# This will be useful to generate assets and clear cache
# in one command
nano Makefile; 
cd themes/FooBarTheme;
# Install NPM dependencies for your front-end dev environment.
# Use YARN
yarn;
# OR use vanilla NPM
npm install;

# Init Vagrant dev VM
# This may take several minute if your 
# launching Vagrant up for the first time
# as it has to download Roadiz box which is ~ 1,2GB
cd ../../;
vagrant up;
```

If you have a full PHP-MySQL server running directly on your development machine you can
ignore *Vagrant* and use it. Make sure that your virtual host is configured to use `web/`
folder as *server root*.

### Develop with *Docker*

*Docker* on Linux will provide awesome performances and a production-like environment 
without bloating your development machine:

```bash
# Copy sample environment variables
# and adjust them against your needs.
cp .env.dist .env;
# Build PHP image
docker-compose build;
# Create and start containers
docker-compose up -d;

# Adapt Makefile with your theme name and NPM/Yarn
# This will be useful to generate assets and clear cache
# in one command
nano Makefile; 
cd themes/FooBarTheme;
# Install NPM dependencies for your front-end dev environment.
# Use YARN
yarn;
# OR use vanilla NPM
npm install;
```

#### Install your theme assets and execute Roadiz commands

You can directly use `bin/roadiz` command through `docker-compose exec`:

```bash
# Install Rozier back-office assets
docker-compose exec -u www-data app bin/roadiz themes:assets:install Rozier

# Install your theme assets as relative symlinks
docker-compose exec -u www-data app bin/roadiz themes:assets:install --symlink --relative FooBar
```

#### On Linux

Pay attention that *PHP* is running with *www-data* user. Linux docker host must
update the `docker/php73-nginx-alpine/Dockerfile` file to reflect your local user **UID**.

Update line: `&& usermod -u 1000 www-data \` using your on UID, you can find it with `id` command.

#### On Mac or Windows

Unfortunately, on *macOS* and *Windows* performances will be worse than *Vagrant* due to
the *volumes* sharing system. You can use [docker-sync](http://docker-sync.io/) to improve IO performances with your shared volumes.    
Use following command **instead of** `docker-compose up -d`:

```bash
# Make sure you setup docker-sync on your computer before.
# gem install docker-sync
docker-sync-stack start
```

## Update Roadiz sources

Simply call `composer update` to upgrade Roadiz. 
You’ll need to execute regular operations if you need to migrate your database.

## Maximize performances for production

You can follow the already [well-documented article on *Performance* tuning for Symfony apps](http://symfony.com/doc/current/performance.html).

### Optimize class autoloader

```bash
composer dump-autoload --optimize --no-dev --classmap-authoritative
```

### Increase PHP cache sizes

```ini
; php.ini
opcache.max_accelerated_files = 20000
realpath_cache_size=4096K
realpath_cache_ttl=600
```

## Build a docker image with Gitlab Registry

You can create a standalone *Docker* image with your Roadiz project thanks to our `roadiz/php73-nginx-alpine` base image, a continuous integration tool such as *Gitlab CI* and a private *Docker* registry. All your theme assets will be compiled in a controlled environment and your production website will have a minimal downtime at each update.

Make sure you don’t ignore `package.lock` or `yarn.lock` in your themes not to get dependency errors when your CI system will compile your theme assets. You may do the same for your project `composer.lock` to make sure that you’ll use the same dependencies version in dev as well as in your CI jobs.

Standard-edition provides a basic configuration set with a `Dockerfile`:

1. Customize `.gitlab-ci.yml` file to reflect your *Gitlab* instance configuration and your *theme* path and your project name.
2. Add your theme in *Composer* `pre-docker` scripts to be able to install your theme assets into `web/` during Docker build:

```
php bin/roadiz themes:assets:install MyTheme
```

3. Add your theme in `.dockerignore` file to include your assets during build, update the following lines to force ignored files into your Docker image:
   
```
!themes/BaseTheme/static
!themes/BaseTheme/Resources/views/partials/*
```

4. Enable *Registry* and *Continuous integration* on your repository settings.
5. Push your code on your *Gitlab* instance. An image build should be triggered after a new **tag** has been pushed and your test and build jobs succeeded.


