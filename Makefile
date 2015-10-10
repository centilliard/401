BUILD_DIR=build

.PHONY: .git

minify:
	echo "Minifying resources..."
	mkdir ${BUILD_DIR}
	echo "Hello, 401!" >> ${BUILD_DIR}/index.html
	find .

deploy: .git
	echo "Deploying to github..."
	git checkout -b gh-pages
	cp -r ${BUILD_DIR}/* .
	git status
	git add .
	git status
	git commit -a -m "Automatic web deployment"
	git push "https://${GITHUB_KEY}@github.com/centilliard/401.git" gh-pages

.git:
	git config user.email "centilliard@centilliard.com"
	git config user.name "Travis CI"
