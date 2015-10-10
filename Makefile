BUILD_DIR=build

minify:
	echo "Minifying resources..."
	mkdir ${BUILD_DIR}
	echo "Hello, 401!" >> ${BUILD_DIR}/index.html
	find .

deploy:
	echo "Deploying to github..."
	git checkout -b gh-pages
	cp -r ${BUILD_DIR}/* .
	git commit -a -m "Automatic web deployment"
	git push "https://${GITHUB_KEY}@github.com/centilliard/401.git" gh-pages
