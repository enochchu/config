WORDPRESS_URL = https://wordpress.org/latest.tar.gz
WORDPRESS_ZIPPED_FILENAME = wordpress.tar.gz

all:

setup:
	mkdir tmp
	cd tmp; \
	curl ${WORDPRESS_URL} > ${WORDPRESS_ZIPPED_FILENAME};\
	tar -xvf ${WORDPRESS_ZIPPED_FILENAME}
	cp -R ./tmp/wordpress ./src
	cp -R ./tmp/wordpress ./webapps
	rm -R tmp

create-theme:
	cd src/wp-content/themes

start-server:
	cd webapps && php -S localhost:8000


print-%:
	@echo $*=$($*)