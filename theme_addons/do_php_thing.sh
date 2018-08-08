#!/bin/bash 


# Mac OS X `sed` differs from GNU sed.
[[ $(uname) = "Darwin" ]] && sedreplace='sed -i.old ' || sedreplace='sed -i '


# store in a variable all `.html` files
files=$(find site -name \*html -print0 | xargs -0 -n1  basename | sort -u)

# update all links to .html files to .php files.
for i in $files ; do  find site -name \*html -exec ${sedreplace} "s/$i\.html/$i\.php/g" {} \; ; done

# rename all .html files to .php files.
find site -name \*.html -exec sh -c 'x={}; mv "$x"  "$(dirname $x)/$(basename $x html)php"'  \;

# just in case we are using mac os x
find site -name \*.old -delete

# insert php code for basic auth if required
if ! fgrep -q '<?php' theme_addons/base.html;
then
  tmp="$(mktemp)" && cat theme_addons/basic_auth.inc theme_addons/base.html >"$tmp" && mv "$tmp" theme_addons/base.html 
fi
