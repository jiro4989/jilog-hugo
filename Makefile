today := `date +%Y/%m/%d`
now := `date +%Y/%m/%dT%H:%M:%S+09:00`
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
	git add .
	git commit -m "deploy ${now}"
	git push origin master

apply_gitignore:
	git rm -r --cached .
	git add .
	git commit -m "apply gitignore ${now}"
	git push origin master

.PHONY: generate new deploy
