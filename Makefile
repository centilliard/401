BUILD_DIR=build

.PHONY: .git

minify:
	mkdir -p ${BUILD_DIR}
	echo "Hello, 401 Tavern!" >> ${BUILD_DIR}/index.html

deploy: .git
	echo "Deploying to github..."
	git remote set-branches --add origin gh-pages
	git fetch
	git checkout gh-pages
	git status
	cp -rv ${BUILD_DIR}/* .
	ls -al
	git status
	git add .
	git commit -a -m "Automatic web deployment"
	git push "https://${GITHUB_KEY}@github.com/centilliard/401.git" gh-pages

.git:
	git config user.email "centilliard@centilliard.com"
	git config user.name "Travis CI"
