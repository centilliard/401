SRC_DIR=src
BUILD_DIR=build
BIN_DIR=bin

HTML_COMPRESSOR=${BIN_DIR}/htmlcompressor-1.5.3.jar
HTML_OPTS=--remove-intertag-spaces --remove-quotes --remove-style-attr --remove-link-attr --remove-script-attr \
          --remove-form-attr --remove-input-attr --simple-bool-attr --remove-surrounding-spaces style
YUI_COMPRESSOR=${BIN_DIR}/yuicompressor-2.4.8.jar
CLOSURE_COMPILER=${BIN_DIR}/compiler-20151015.jar

.PHONY: .git .dirs .tools .scss .html build deploy

build: .dirs .tools .scss .html
	sed -i -e "/__HEADER_CSS__/{r ${BUILD_DIR}/styles/header.css" -e 'd}' ${BUILD_DIR}/index.html #inject header CSS
	java -jar ${HTML_COMPRESSOR} ${HTML_OPTS} ${BUILD_DIR}/index.html -o ${BUILD_DIR}/index.html  #compress final HTML

deploy: .git
	git remote set-branches --add origin gh-pages
	git fetch
	git checkout gh-pages
	git status
	cp -rvT ${BUILD_DIR} .
	ls -hal
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

.dirs:
	mkdir -p "${BUILD_DIR}"

.tools:
	gem install sass
	sass --version

.scss: ${BUILD_DIR}/styles/header.css ${BUILD_DIR}/styles/body.css

.html: ${BUILD_DIR}/index.html

${BUILD_DIR}/styles/%.css: ${SRC_DIR}/styles/%.scss
	mkdir -p "$(@D)"
	sass --scss --style compressed --no-cache --sourcemap=none "$<" "$@"

${BUILD_DIR}/%.html: ${SRC_DIR}/%.html
	cp -v "$<" "$@"