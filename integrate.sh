#!/bin/bash

# CSS="cv.css"
# PHOTO="photo.jpg"

ROOTDIR="$1"

while IFS='' read -r a; do
	if echo "$a" | egrep '<link rel="stylesheet" type="text/css" href=".*" />' >/dev/null; then
		CSS=$(echo "$a" | cut -d\" -f6)
		echo -E '		<style type="text/css">'
		while IFS='' read -r b; do
			if echo "$b" | egrep "	background-image: url\(.*\);" >/dev/null; then
				PHOTO=$(echo "$b" | cut -d\( -f2 | cut -d\) -f1)
				echo -nE "				background-image: url(data:image/jpg;base64,"
				base64 < "$ROOTDIR""$PHOTO" | while IFS='' read -r c; do
					echo -nE "$c"
				done
				echo -E ");"
			else
				echo -E '			'"$b"
			fi
		done < "$ROOTDIR""$CSS"
		echo -E '		</style>'
	elif echo "$a" | egrep '<img src=".*" id=".*" />' >/dev/null; then
		PHOTO=$(echo "$a" | cut -d\" -f2)
		PHOTOID=$(echo "$a" | cut -d\" -f4)
		echo -nE '					<img src="data:image/jpg;base64,'
		base64 < "$ROOTDIR""$PHOTO" | while IFS='' read -r c; do
			echo -nE "$c"
		done
		echo -E '" id="'"$PHOTOID"'" />'
	else
		echo -E "$a"
	fi
done < cv.html > cv-pages/cv.html
