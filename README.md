# Roadiz *Standard Edition* CMS

[![Join the chat at https://gitter.im/roadiz/roadiz](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/roadiz/roadiz?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Roadiz is a modern CMS based on a polymorphic node system which can handle many types of services and contents.
Its back-office has been developed with a high sense of design and user experience.
Roadiz theming system is built to live independently of back-office allowing easy switching
and multiple themes for one content basis. For example, it allows you to create one theme
for your desktop website and another one for your mobile, using the same node hierarchy.
Roadiz is released under MIT license, so you can reuse
and distribute its code for personal and commercial projects.

* [Documentation](#documentation)
* [Standard edition](#standard-edition)
* [Usage](#usage)
  + [Update Roadiz and your own theme assets](#update-roadiz-and-your-own-theme-assets)
  + [Develop with *PHP* internal server](#develop-with-php-internal-server)
  + [Develop with *Docker*](#develop-with-docker)
    - [Install your theme assets and execute Roadiz commands](#install-your-theme-assets-and-execute-roadiz-commands)
    - [On Linux](#on-linux)
* [Update Roadiz sources](#update-roadiz-sources)
* [Maximize performances for production](#maximize-performances-for-production)
  + [Optimize class autoloader](#optimize-class-autoloader)
  + [Increase PHP cache sizes](#increase-php-cache-sizes)
* [Build a docker image with Gitlab Registry](#build-a-docker-image-with-gitlab-registry)

## Documentation

* *Roadiz* website: http://www.roadiz.io
* *Read the Docs* documentation can be found at http://docs.roadiz.io
* *API* documentation can be found at http://api.roadiz.io
* *Forum* can be found at https://ask.roadiz.io

## Standard edition

This is the **production-ready edition** for Roadiz. It is meant to set up your *Apache/Nginx* server root 
to the `web/` folder, keeping your app sources and themes secure.

## Usage

```bash
# Create a new Roadiz project on develop branch
composer create-project roadiz/standard-edition;
# Navigate into your project dir
cd standard-edition;
# Create a new theme for your project
bin/roadiz themes:generate --symlink --relative FooBar;
# Go to your theme
cd themes/FooBarTheme;
# Build base theme assets
yarn; # or npm install
yarn build; # or npm run build
```

Composer will automatically create a new project based on Roadiz and download every dependency. 

Composer script will copy a default configuration file and your entry-points in `web/` folder automatically 
and a `.env` file in your project root to set up your *Docker* development environment.

### Update Roadiz and your own theme assets

```bash
composer update -o --no-dev

# Re-install your theme in public folder using relative symlinks (MacOS + Unix)
# remove --relative flag on Windows to generate absolute symlinks
bin/roadiz themes:assets:install --symlink --relative FooBar;
```

### Develop with *Docker*

*Docker* on Linux will provide awesome performances, and a production-like environment 
without bloating your development machine:

```bash
# Copy sample environment variables
# and adjust them against your needs.
nano .env;
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
yarn; # npm install;
# Then build assets
yarn build; # npm run build
```

##### Issue with Solr container

*Solr* container declares its volume in `.data/solr` in your project folder. After first launch this 
folder may be created with `root` owner causing *Solr* not to be able to populate it. Just run: \
`sudo chown -R $USER_UID:$USER_UID .data` (replacing `$USER_UID` with your local user *id*).

### Develop with *PHP* internal server

````bash
# Edit your Makefile "DEV_DOMAIN" variable to use a dedicated port
# to your project and your theme name.
nano Makefile;

# Launch PHP server
make dev-server;
````

#### Install your theme assets and execute Roadiz commands

You can directly use `bin/roadiz` command through `docker-compose exec`:

```bash
# Install Rozier back-office assets
docker-compose exec -u www-data app bin/roadiz themes:assets:install Rozier

# Install your theme assets as relative symlinks
docker-compose exec -u www-data app bin/roadiz themes:assets:install --symlink --relative FooBar
```

#### On Linux

Pay attention that *PHP* is running with *www-data* user. You must update your `.env` file to 
reflect your local user **UID** during image build.

```shell script
# Type id command in your favorite terminal app
id
# It should output something like
# uid=1000(toto)
```

So use the same uid in your `.env` file **before** starting and building your docker image.
```dotenv
USER_UID=1000
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

You can create a standalone *Docker* image with your Roadiz project thanks to our `roadiz/php80-nginx-alpine` base 
image, a continuous integration tool such as *Gitlab CI* and a private *Docker* registry. 
All your theme assets will be compiled in a controlled environment, and your production website 
will have a minimal downtime at each update.

Make sure you don’t ignore `package.lock` or `yarn.lock` in your themes not to get dependency errors when your 
CI system will compile your theme assets. You may do the same for your project `composer.lock` to make sure 
you’ll use the same dependencies' version in dev as well as in your CI jobs.

*Standard Edition* provides a basic configuration set with a `Dockerfile`:

1. Customize `.gitlab-ci.yml` file to reflect your *Gitlab* instance configuration and your *theme* path and your project name.
2. Add your theme in *Composer* `pre-docker` scripts to be able to install your theme assets into `web/` during Docker build:

```
php bin/roadiz themes:assets:install MyTheme
```

3. Add your theme in `.dockerignore` file to include your assets during build, update the following lines to force ignored files into your Docker image:
   
```
!themes/BaseTheme/static
!themes/BaseTheme/Resources/views/base.html.twig
!themes/BaseTheme/Resources/views/partials/*
```

4. Enable *Registry* and *Continuous integration* on your repository settings.
5. Push your code on your *Gitlab* instance. An image build should be triggered after a new **tag** has been pushed and your test and build jobs succeeded.


