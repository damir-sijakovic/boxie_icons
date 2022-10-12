#!/bin/bash

echo "░▒▓  BOXIE - ICONSET  ▓▒░" ; 
echo "▓▒░ BUILDING HTML PREVIEW...  " ;

WORK_DIR=$(pwd) ;
RESIZE_TO="128x128"
OUTPUT_DIR_NAME="preview-html"
LOGO_SVG=$WORK_DIR"/about-logo.svg"

#DELETE OUTPUT DIR IF EXISTS
if [ -d "$OUTPUT_DIR_NAME" ] ; then
   rm -Rf $OUTPUT_DIR_NAME ;
fi

#MAKE OUTPUT DIR
if [ ! -d $OUTPUT_DIR_NAME ] ; then
  mkdir $WORK_DIR"/"$OUTPUT_DIR_NAME ;
  mkdir $WORK_DIR"/"$OUTPUT_DIR_NAME"/icons" ;
fi


#CREATE JS ICON DATA
OUTPUT_DATA_JS=$WORK_DIR"/"$OUTPUT_DIR_NAME"/data.js"
echo "const iconData = [" > "$OUTPUT_DATA_JS" ;
for f in ./src/*; do
  if [ -d "$f" ]; then
    
    . $f"/icon.conf" ; #import $name , $path
    echo "{"group":""\"$path\"",name":""\"$name\"""}," >> "$OUTPUT_DATA_JS";

  fi
done
echo "]" >> "$OUTPUT_DATA_JS" ;



#CREATE PNGS
for f in ./src/*; do
  if [ -d "$f" ]; then
	BASENAME=$(basename $f) ;	
	FILE0=$f"/0.svg" ;
	FILE1=$f"/1.svg" ;
    
    . $f"/icon.conf" ;
    
    TARGET_PATH="$WORK_DIR""/""$OUTPUT_DIR_NAME""/icons""$path"
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



echo "Making preview html file..."

echo "<!DOCTYPE html>
<html>
<head>
<meta name='viewport' content='width=device-width, initial-scale=1'>
<style>

@import url('https://fonts.googleapis.com/css2?family=Rajdhani:wght@300;400;500;600;700&display=swap');
body{
    background: #c1c1c1;
}

.accordion {
  background-color: #ccc;
  color: #444;
  cursor: pointer;
  padding: 18px;
  width: 100%;
  border: none;
  text-align: left;
  outline: none;
  font-size: 15px;
  transition: 0.4s;
  border: 1px solid darkgray;
}

.active, .accordion:hover {
  background-color: lightsteelblue;
}

.panel {
  padding: 18px;
  display: none;
  background-color: #ccc;
  overflow: hidden;
  border: 1px solid darkgray;
}

*{
font-family: 'Rajdhani', sans-serif;
font-weight:600;
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(128px, 1fr));
  grid-gap: 1rem;
  color: #333;
}

.grid > div {
  padding: 1rem;
  display: grid;
  place-items: center;
  transition: all 1s ease;
}

.grid > div:hover {
  padding: 1rem;
  display: grid;
  place-items: center;
  background: #ffa997;
  border-radius: 8px;
}

.grid > div::before {
  padding-bottom: 100%;
  grid-area: 1/1/2/2;
}

.grid > div svg {
}

.shadow-outline{
  box-shadow: rgba(0, 0, 0, 0.16) 0px 3px 6px, rgba(0, 0, 0, 0.23) 0px 3px 6px;
}

</style>
</head>
<body>

<h1>Boxie Iconset</h1>

<div class='shadow-outline main-container'>
</div>

</body>
</html>

<script src='data.js'></script>
<script>

const createIcon = (group, name) => {
	let imgUrl = './icons' + group + '/' + name + '.png' ;
	return \`
	<div>
		<img src='\${imgUrl}' />
		\${name}
	</div>
	\`;
}

const createIconGroup = (name, data) => {

    let generatedData = '';

    for (let i=0; i<data.length; i++){
        generatedData += createIcon(name, data[i]);
    }

	return \`
	<button class='accordion'><b>\${name}</b></button>
	<div class='panel'>
         <div class='grid'>
		\${generatedData}
	</div>
	</div>
	\`;
}

const addIconsToGrid = () => {
	let container = document.querySelector('.main-container');
	let item = createIcon('alphagr', 'beta');

    let groupData = [];
    for (let i=0; i<iconData.length; i++){
        if (iconData[i].group in groupData){
           groupData[iconData[i].group].push(iconData[i].name);
        }
        else{
           groupData[iconData[i].group] = [];
           groupData[iconData[i].group].push(iconData[i].name);
        }

    }

    for (const p in groupData) {
            container.innerHTML += createIconGroup(p, groupData[p]);
    }
}

addIconsToGrid();

window.addEventListener('load', function() {
	var acc = document.getElementsByClassName('accordion');
	var i;

	for (i = 0; i < acc.length; i++) {
	  acc[i].addEventListener('click', function() {
		this.classList.toggle('active');
		var panel = this.nextElementSibling;
		if (panel.style.display === 'block') {
		  panel.style.display = 'none';
		} else {
		  panel.style.display = 'block';
		}
	  });
	}
})

</script> " > $WORK_DIR"/"$OUTPUT_DIR_NAME"/preview.html" ;



date +%s > ./.lastbuild ;

echo "▓▒░ FINISHED BUILDING HTML PREVIEW...  " ;

