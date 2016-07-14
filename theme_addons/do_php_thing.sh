#!/bin/bash
[[ $(uname) = "Darwin" ]] && sedreplace='sed -i.old ' || sedreplace='sed -i '
#sedreplace='sed -i '
files=$(find site -name \*html | xargs basename | sort -u | sed 's/\.html//')
for i in $files ; do  find site -name \*html -exec $sedreplace "s/$i\.html/$i\.php/g" {} \; ; done
find site -name \*.html -exec sh -c 'x={}; mv "$x"  "$(dirname $x)/$(basename $x html)php"'  \;
find site -name \*.old -delete
