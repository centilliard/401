SRC_DIR=src
BUILD_DIR=build
BIN_DIR=bin

HTML_COMPRESSOR=${BIN_DIR}/htmlcompressor-1.5.3.jar
HTML_OPTS=--remove-intertag-spaces --remove-quotes --remove-style-attr --remove-link-attr --remove-script-attr \
          --remove-form-attr --remove-input-attr --simple-bool-attr
YUI_COMPRESSOR=${BIN_DIR}/yuicompressor-2.4.8.jar
CLOSURE_COMPILER=${BIN_DIR}/compiler-20151015.jar

MENU_MD=$(wildcard ${SRC_DIR}/menu/*.md)
MENU_HTML=$(patsubst %.md,%.html,${MENU_MD})
MENU_HTML_FILES=$(subst ${SRC_DIR},${BUILD_DIR},${MENU_HTML})

.PHONY:  build deploy .git .dirs .tools .scss .html .img .menu

build: .dirs .tools .scss .html .img .menu
	sed -i -e "/__HEADER_CSS__/{r ${BUILD_DIR}/styles/header.css" -e 'd}' ${BUILD_DIR}/index.html #inject header CSS
	sed -i -e "/__BRUNCH_MENU__/{r ${BUILD_DIR}/menu/brunch.html" -e 'd}' ${BUILD_DIR}/index.html #inject brunch HTML
	sed -i -e "/__LUNCH_MENU__/{r ${BUILD_DIR}/menu/lunch.html" -e 'd}' ${BUILD_DIR}/index.html   #inject lunch HTML
	sed -i -e "/__DINNER_MENU__/{r ${BUILD_DIR}/menu/dinner.html" -e 'd}' ${BUILD_DIR}/index.html #inject dinner HTML
	sed -i -e "/__SPECIALS_MENU__/{r ${BUILD_DIR}/menu/specials.html" -e 'd}' ${BUILD_DIR}/index.html #inject specials HTML
	sed -i -e "/__BEER_MENU__/{r ${BUILD_DIR}/menu/beer.html" -e 'd}' ${BUILD_DIR}/index.html     #inject beer HTML
	sed -i -e "/__WINE_MENU__/{r ${BUILD_DIR}/menu/wine.html" -e 'd}' ${BUILD_DIR}/index.html     #inject wine HTML
	sed -i -e "/__COCKTAIL_MENU__/{r ${BUILD_DIR}/menu/cocktail.html" -e 'd}' ${BUILD_DIR}/index.html #inject cocktail HTML
	sed -i -e "/__LIQUOR_MENU__/{r ${BUILD_DIR}/menu/liquor.html" -e 'd}' ${BUILD_DIR}/index.html #inject liquor HTML
	java -jar ${HTML_COMPRESSOR} ${HTML_OPTS} ${BUILD_DIR}/index.html -o ${BUILD_DIR}/index.html  #compress final HTML
	tr -d "\n\r" < ${BUILD_DIR}/index.html > ${BUILD_DIR}/index.html.tr                           #remove all newlines
	cp ${BUILD_DIR}/index.html.tr ${BUILD_DIR}/index.html && rm -fv ${BUILD_DIR}/index.html.tr    #remove temp file

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

.img:
	@cp -r ${SRC_DIR}/images ${BUILD_DIR}/

.menu: ${MENU_HTML_FILES}

${BUILD_DIR}/styles/%.css: ${SRC_DIR}/styles/%.scss
	mkdir -p "$(@D)"
	sass --scss --style compressed --no-cache --sourcemap=none "$<" "$@"

${BUILD_DIR}/%.html: ${SRC_DIR}/%.html
	cp -v "$<" "$@"
	
${BUILD_DIR}/menu/%.html: ${SRC_DIR}/menu/%.md
	mkdir -p "$(@D)"
	markdown "$<" > "$@"
