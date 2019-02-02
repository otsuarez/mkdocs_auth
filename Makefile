.PHONY: build

all: help

full: clean build serve

clean: ## rm site/
	rm -fr site/
	mkdir site

build: ## build files
	mkdocs build --clean
	theme_addons/do_php_thing.sh

serve: ## publish site on :8080
	#mkdocs serve 
	cd site && php -S 0:8080

gpush: ## git push HEAD to origin
	@git push -u origin HEAD
gpushf: ##git force push HEAD to origin
	@git push -u origin HEAD -f
gupdate: ## update local branch from master
	@git fetch origin master; git rebase origin/master
gam: ## add new changes to previous commit
	@git commit -a --amend

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


