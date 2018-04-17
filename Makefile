today := `date +%Y/%m/%d`
post_file := ${today}/${title}.md

generate:
	hugo

# make title="new title" new
new:
	if [ "${title}" = "" ]; then echo "Input title."; exit 1 ; fi
	hugo new post/${post_file}
	vim content/post/${post_file}

# make msg="message" deploy
deploy: generate
	cd ./public
	git add -A
	git commit -m "update `date +%Y/%m/%dT%H:%M:%S+09:00`"
	git push origin master
	cd ..

.PHONY: generate new deploy
