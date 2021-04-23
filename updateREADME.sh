#!/bin/bash -f
PKGLISTFILE=$(mktemp)
echo "| Package | Description |" > $PKGLISTFILE
echo "| --- | ----------- |" >> $PKGLISTFILE
find . -name "*.ebuild" |xargs grep DESCRIPTION= |awk -F '/|:|=' '{ pname=$2"/"$3 ; DESC=$6  ; print "| ", pname, " | ", DESC " | " }' |sort|uniq >> $PKGLISTFILE

cp -f $PKGLISTFILE README.md
