BUILD_DIR=build

.PHONY: .git

minify:
	mkdir -p ${BUILD_DIR}
	echo "Hello, 401!" >> ${BUILD_DIR}/index.html

deploy: .git
	echo "Deploying to github..."
	git remote set-branches --add origin gh-pages
	git fetch
	git checkout gh-pages
	git status
	cp -rv ${BUILD_DIR}/* .
	ls -al
	git status | grep "nothing to commit" && exit 0
	git add .
	git commit -a -m "Automatic web deployment" || exit 0
	git push "https://${GITHUB_KEY}@github.com/centilliard/401.git" gh-pages

.git:
	git config user.email "${GITHUB_USER_EMAIL}"
	git config user.name "${GITHUB_USER_NAME}"
