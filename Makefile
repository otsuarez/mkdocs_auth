.PHONY: build
all: serve
full: clean build serve

clean:
	rm -fr site/
	mkdir site

serve:
	#mkdocs serve 
	cd site && php -S 0:8080

build:
	mkdocs build --clean
	theme_addons/do_php_thing.sh

