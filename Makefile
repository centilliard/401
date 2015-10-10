.PHONY: .git

minify:
	echo "Hello, 401!" >> index.html
	git add index.html
	
deploy: .git
	echo "Deploying to github..."
	git checkout -b gh-pages
	git status
	git commit -a -m "Automatic web deployment"
	git push "https://${GITHUB_KEY}@github.com/centilliard/401.git" gh-pages

.git:
	git config user.email "centilliard@centilliard.com"
	git config user.name "Travis CI"
