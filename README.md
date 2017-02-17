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

## Standard edition

This is the **production-ready edition** for Roadiz. It is meant to setup your *Apache/Nginx* server root to the `web/` folder, keeping your app sources and themes secure.

## Usage

```shell
# Create a new Roadiz project on develop branch
composer create-project roadiz/standard-edition -s dev
# Create a new theme for your project
bin/roadiz themes:generate -d FooBar
```

Composer will automatically create a new project based on Roadiz and download every dependencies. 

Composer script will copy a default configuration file and your entry-points in `web/` folder automatically. However, if you want to use Vagrant and `make`for your development, here are some useful commands. 

```shell
# Copy Vagrantfile and use a dedicated IP
# add this IP to your /etc/hosts
cp samples/Vagrantfile.sample Vagrantfile

# Adapt Makefile with your theme name and NPM/Yarn
# This will be useful to generate assets and clear cache
# in one command
nano Makefile 

# Init VM
vagrant up --no-provision
vagrant provision --provision-with=roadiz,mailcatcher
```

Then you’ll need to create a new theme and symlink its `static/` folder into
`web/` directory.

## Update Roadiz sources

Simply call `composer update --no-dev` to upgrade Roadiz. 
You’ll need to execute regular operations if you need to migrate your database.

## Maximize performances for production

You can follow the already [well-documented article on *Performance* tuning for Symfony apps](http://symfony.com/doc/current/performance.html).

### Optimize class autoloader

```shell
composer dump-autoload --optimize --no-dev --classmap-authoritative
```

### Increase PHP cache sizes

```ini
; php.ini
opcache.max_accelerated_files = 20000
realpath_cache_size=4096K
realpath_cache_ttl=600
```
