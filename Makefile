TODAY := `date +%Y/%m/%d`
NOW := `date +%Y/%m/%dT%H:%M:%S+09:00`
POST_TITLE := ${TODAY}/${title}
POST_FILE := ${POST_TITLE}.md

.PHONY: generate
generate: clean
	hugo

.PHONY: server
server: generate
	hugo server -D

.PHONY: init
init:
	-rm -rf ./public
	git submodule add --force https://github.com/jiro4989/jiro4989.github.io public

.PHONY: new
new:
	if [ "${title}" = "" ]; then echo "[ERROR]title変数を入力してください。(ex: make new title=hogepiyo)"; exit 1 ; fi
	hugo new post/${POST_FILE}
	mkdir -p static/img/${POST_TITLE}
	vim content/post/${POST_FILE}

.PHONY: deploy
deploy: generate
	git add .
	-git commit -m "deploy ${NOW}"
	-git push origin master
	cd ./public && make

.PHONY: clean
clean:
	cd ./public && make clean

.PHONY: apply-gitignore
apply-gitignore:
	git rm -r --cached .
	git add .
	git commit -m "apply gitignore ${NOW}"
	git push origin master
