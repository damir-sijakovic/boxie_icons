#!/bin/bash

echo "░▒▓  BOXIE - ICONSET  ▓▒░" ; 
echo "▓▒░ BUILDING ICONSET...  " ; 

WORK_DIR=$(pwd) ;
BUILD_DIR=$WORK_DIR"/"$outputDirName ;
RESIZE_TO="64x64"
OUTPUT_DIR_NAME="build"
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
    TARGET_FULL_PATH=$TARGET_PATH"/""$name"".info"
    
    echo $TARGET_FULL_PATH ;
    
    if [ ! -d $TARGET_PATH ] ; then
    	mkdir $TARGET_PATH ;
    fi

      convert -resize $RESIZE_TO -channel rgba -background "rgba(0,0,0,0)" $f"/0.svg" $f"/0.png" ;
      
      if test -f "$FILE1"; then
        convert -resize $RESIZE_TO -channel rgba -background "rgba(0,0,0,0)" $f"/1.svg" $f"/1.png" ;  
        cat $f"/0.png" $f"/1.png" > $TARGET_FULL_PATH ;  
        echo "created "  $TARGET_FULL_PATH ;  
        rm $f"/0.png" ;               
        rm $f"/1.png" ;               
      else 
        mv $f"/0.png" $TARGET_FULL_PATH ;           
        echo "created " $TARGET_FULL_PATH ; 
        rm $f"/0.png" ;             
      fi
               
         
  fi
done


echo "▓▒░ FINISHED BUILDING ICONSET...  " ; 

