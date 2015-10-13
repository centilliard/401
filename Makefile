SRC_DIR=src
BUILD_DIR=build

.PHONY: .git

minify:
	python --version
	mkdir -p ${BUILD_DIR}
	cp ${SRC_DIR}/* ${BUILD_DIR}/

deploy: .git
	git remote set-branches --add origin gh-pages
	git fetch
	git checkout gh-pages
	git status
	cp -rv ${BUILD_DIR}/* .
	ls -al
	git status
	@if ! git status | grep -q "nothing to commit"; then \
      git add . && \
      git commit -a -m "Automatic web deployment"  && \
      git push "https://${GITHUB_KEY}@github.com/centilliard/401.git" gh-pages; \
    else \
      echo "Nothing to do."; \
    fi

.git:
	git config user.email "${GITHUB_USER_EMAIL}"
	git config user.name "${GITHUB_USER_NAME}"
