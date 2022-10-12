#!/bin/bash

echo "░▒▓  BOXIE - ICONSET  ▓▒░" ; 
echo "▓▒░ BUILDING ICONSET...  " ; 

WORK_DIR=$(pwd) ;
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
    
    . $f"/icon.conf" ; #import $name
    
    TARGET_PATH="$WORK_DIR""/""$OUTPUT_DIR_NAME""$path"
    TARGET_FULL_PATH=$TARGET_PATH"/""$name"".info"
    
    echo $TARGET_FULL_PATH ;
    
    if [ ! -d $TARGET_PATH ] ; then
    	mkdir $TARGET_PATH ;
    fi

      convert -resize $RESIZE_TO -channel rgba -background "rgba(0,0,0,0)" $f"/0.svg" $f"/0.png" ;
      convert $f"/0.png" -gravity 'northwest' -background 'rgba(255,255,255,0)'  \( +clone -background '#005f005f005f0000' -shadow "80x3-1-1" \) +swap -background none -mosaic +repage $f"/0.png" ;
      
      if test -f "$FILE1"; then
        convert -resize $RESIZE_TO -channel rgba -background "rgba(0,0,0,0)" $f"/1.svg" $f"/1.png" ;  

         convert $f"/1.png" -gravity 'northwest' -background 'rgba(255,255,255,0)'  \( +clone -background '#005f005f005f0000' -shadow "80x3-1-1" \) +swap -background none -mosaic +repage $f"/1.png" ;
         convert $f"/1.png" -gravity 'northwest' -background Yellow  \( +clone -background Yellow -shadow "80x3-1-1" \) +swap -background none -mosaic +repage $f"/1.png" ;

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

date +%s > ./.lastbuild ;

echo "▓▒░ FINISHED BUILDING ICONSET...  " ; 

