#
# Base theme
# Development tasks
#
GREEN=\033[0;32m
RED=\033[0;31m
# No Color
NC=\033[0m
THEME=BaseTheme
# Use Yarn
INSTALL_CMD="`yarn`"
UPDATE_CMD="`yarn upgrade`"
# Or use NPM
#INSTALL_CMD="`npm install`"
#UPDATE_CMD="`npm update`"

# Default task install + build
all : configtest install build cache

# Install NPM deps and Bower deps
install : configtest themes/${THEME}/node_modules

themes/${THEME}/node_modules :
	cd ./themes/${THEME} && ${INSTALL_CMD};

.PHONY : clean uninstall update build watch cache

cache :
	bin/roadiz cache:clear
	bin/roadiz cache:clear -e prod
	bin/roadiz cache:clear -e prod --preview
	bin/roadiz cache:clear-fpm -e prod
	bin/roadiz cache:clear-fpm -e prod --preview

# Launch Gulp watch task
watch : configtest
	cd ./themes/${THEME} && npm run dev;
# Build prod ready assets with Gulp
build : configtest
	cd ./themes/${THEME} && npm run build;
# Update NPM deps
update : configtest
	cd ./themes/${THEME} && ${UPDATE_CMD};
	@echo "✅\t${GREEN}Updated NPM dependencies. \tOK.${NC}" >&2;
# Delete generated assets
clean :
	rm -rf ./themes/${THEME}/static/css/*;
	rm -rf ./themes/${THEME}/static/js/*;
	@echo "✅\t${GREEN}Cleaned build and dist folders. \tOK.${NC}" >&2;
# Uninstall NPM deps and clean generated assets
uninstall : clean
	rm -rf ./themes/${THEME}/node_modules;
	@echo "✅\t${GREEN}Removed NPM dependencies. \tOK.${NC}" >&2;
#
# Test if required binaries are available
#
configtest:
	@command -v npm >/dev/null 2>&1 || { echo "❌\t${RED}I require npm but it's not installed. \tAborting.${NC}" >&2; exit 1; }
	@echo "✅\t${GREEN}NodeJS is available. \tOK.${NC}" >&2;
