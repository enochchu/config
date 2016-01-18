LOCAL_BUNDLES_FOLDER = bundles
LOCAL_DEPLOY_FOLDER= webapps
LOCAL_SOURCE_FOLDER = src
PHP_SERVER_DOMAIN = localhost
PHP_SERVER_PORT_NUMBER = 8000
PHP_SERVER_ADDRESS = ${PHP_SERVER_DOMAIN}:${PHP_SERVER_PORT_NUMBER}
WORDPRESS_URL = https://wordpress.org/latest.tar.gz
WORDPRESS_ZIPPED_FILENAME = wordpress.tar.gz

all:

setup:
	mkdir ${LOCAL_BUNDLES_FOLDER}
	cd ${LOCAL_BUNDLES_FOLDER}; \
	curl ${WORDPRESS_URL} > ${WORDPRESS_ZIPPED_FILENAME};\
	tar -xvf ${WORDPRESS_ZIPPED_FILENAME}
	cp -R ./${LOCAL_BUNDLES_FOLDER}/wordpress ${LOCAL_SOURCE_FOLDER}
	cp -R ./${LOCAL_BUNDLES_FOLDER}/wordpress ${LOCAL_DEPLOY_FOLDER}
	@$(MAKE) generate-router-php-script
	@$(MAKE) generate-theme-scripts
	@$(MAKE) generate-start-server-script

generate-router-php-script:
	printf "<?php\n\
	\$$root = \$$_SERVER['DOCUMENT_ROOT'];\n\
	chdir(\$$root);\n\
	\$$path = '/'.ltrim(parse_url(\$$_SERVER['REQUEST_URI'])['path'],'/');\n\
	set_include_path(get_include_path().':'.__DIR__);\n\
	if(file_exists(\$$root.\$$path)) {\n\
	\tif(is_dir(\$$root.\$$path) && substr(\$$path,strlen(\$$path) - 1, 1) !== '/')\n\
	\t\t\$$path = rtrim(\$$path,'/').'/index.php';\n\
	\tif(strpos(\$$path,'.php') === false) return false;\n\
	\telse {\n\
	\t\tchdir(dirname(\$$root.\$$path));\n\
	\t\trequire_once \$$root.\$$path;\n\
	\t}\n\
	} else include_once 'index.php';"\
	> ./${LOCAL_DEPLOY_FOLDER}/router.php

generate-theme-scripts:
	printf "cp -R \$${1} ../../../${LOCAL_DEPLOY_FOLDER}/wp-content/themes/\$${1}" > \
	${LOCAL_SOURCE_FOLDER}/wp-content/themes/deploy
	chmod +x ${LOCAL_SOURCE_FOLDER}/wp-content/themes/deploy
	printf "cp -R \$${1} ../../../${LOCAL_DEPLOY_FOLDER}/wp-content/plugins/\$${1}" > \
	${LOCAL_SOURCE_FOLDER}/wp-content/plugins/deploy
	chmod +x ${LOCAL_SOURCE_FOLDER}/wp-content/plugins/deploy

generate-start-server-script:
	printf "cd ${LOCAL_DEPLOY_FOLDER} && php -S ${PHP_SERVER_ADDRESS} router.php" > server
	chmod +x server