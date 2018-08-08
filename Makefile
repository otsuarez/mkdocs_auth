.PHONY: build
all: serve
full: clean build serve

clean:
	rm -fr site/
	mkdir site

build:
	mkdocs build --clean
	theme_addons/do_php_thing.sh

serve:
	#mkdocs serve 
	cd site && php -S 0:8080

