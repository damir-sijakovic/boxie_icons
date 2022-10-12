#!/bin/bash

echo "░▒▓  BOXIE - ICONSET  ▓▒░" ; 
echo "▓▒░ BUILDING PNG ICONSET...  " ;

WORK_DIR=$(pwd) ;
RESIZE_TO="64x64"
OUTPUT_DIR_NAME="png-build"
LOGO_SVG=$WORK_DIR"/about-logo.svg"

#MAKE OUTPUT DIR
if [ ! -d $OUTPUT_DIR_NAME ] ; then
	mkdir $OUTPUT_DIR_NAME ;
fi

#CREATE LOGO
if test -f "$LOGO_SVG"; then
	convert -channel rgba -background "rgba(0,0,0,0)" $LOGO_SVG $OUTPUT_DIR_NAME"/about.png" ;
fi

#LOOP THROUGH SVGS IN SRC
for f in ./src/*; do
  if [ -d "$f" ]; then
	BASENAME=$(basename $f) ;	
	FILE0=$f"/0.svg" ;
	FILE1=$f"/1.svg" ;
    
    . $f"/icon.conf" ;
    
    TARGET_PATH="$WORK_DIR""/""$OUTPUT_DIR_NAME""$path"
    TARGET_FULL_PATH=$TARGET_PATH"/""$name"".png"
    
    echo $TARGET_FULL_PATH ;
    
    if [ ! -d $TARGET_PATH ] ; then
    	mkdir $TARGET_PATH ;
    fi

      convert -resize $RESIZE_TO -channel rgba -background "rgba(0,0,0,0)" $f"/0.svg" $f"/0.png" ;
      convert $f"/0.png" -gravity 'northwest' -background 'rgba(255,255,255,0)'  \( +clone -background '#005f005f005f0000' -shadow "80x3-1-1" \) +swap -background none -mosaic +repage $f"/0.png" ;

      mv $f"/0.png" $TARGET_FULL_PATH ;
      echo "created " $TARGET_FULL_PATH ;

  fi
done

date +%s > ./.lastbuild ;

echo "▓▒░ FINISHED BUILDING PNG ICONSET...  " ;

