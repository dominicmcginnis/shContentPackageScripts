#!/bin/bash
TYPE=$1
ACTION=$2

die () {
    echo >&2 "$@"
    exit 1
}


[ "$#" -eq 2 ] || die "The following arguments required <TYPE> <ACTION>, $# provided;  
Available types: 
	css_home: create home-content-bundle.min.css 
	js_browse: create browse-content-head-bundle.min.js and browse-content-footer-bundle.min.js 
	js_home: create home-content-bundle.min.js
	js_event: create event-content-bundle.min.js 
	js_search: create search-content-bundle.min.js
	all: create all bundles (css and js) 
Available actions:
	pull - Get latest source files for bundles
	package - create bundles from source
	pull_package - get the lates and package them

	Example: packagePromotions.sh css pull_package"

if [[ ! -d ./src ]]
 then mkdir src
else
	rm -rf src/*bundle*
fi

if [[ ! -d ./target ]]
 then mkdir target
else
	rm -rf target
	mkdir target
fi

JAVA_COMMAND=/usr/bin/java
YUI_LIB="./lib/yuicompressor-2.4.8.jar"
CLOSURE_LIB="./lib/compiler-closure.jar"

getLatestFilesFiles () {
	fileList=$1
	fileType=$2
	while read -r line || [[ -n $line ]]
	do 
		#get Filename
		filename=`basename $line .$fileType`
		#get the fil
		wget -O src/$filename.$fileType $line
	done < ./fileLists/$fileList.txt
}

# Run mvn merge/min process on CSS files
packageHomeCSS () {
	CSS_RESULT_FILE_NAME="home-content-bundle"
	# Copy down CSS files
	while read -r line || [[ -n $line ]]
	do 
		#get Filename
		filename=`basename $line .css`
		# merge to output file
		echo "/*--- Start $filename.css  ---*/" >> ./src/$CSS_RESULT_FILE_NAME.css
		cat ./src/$filename.css >> ./src/$CSS_RESULT_FILE_NAME.css
		echo "/*--- END $filename.css  ---*/" >> ./src/$CSS_RESULT_FILE_NAME.css
	done < ./fileLists/cssHomeFiles.txt
	#minify the package
	$JAVA_COMMAND -jar $YUI_LIB ./src/$CSS_RESULT_FILE_NAME.css -o ./target/$CSS_RESULT_FILE_NAME.min.css --charset utf-8

}

packageHeadJS () {
	JS_RESULT_HEAD_FILE_NAME="browse-common-content-head-bundle"
	# Copy down JS Head files
	while read -r line || [[ -n $line ]]
	do 
		#get Filename
		filename=`basename $line .js`
		# merge to output file
		echo "/*--- Start $filename.js  ---*/" >> ./src/$JS_RESULT_HEAD_FILE_NAME.js
		cat ./src/$filename.js >> ./src/$JS_RESULT_HEAD_FILE_NAME.js
		echo "/*--- End $filename.js  ---*/" >> ./src/$JS_RESULT_HEAD_FILE_NAME.js
	done < ./fileLists/jsHeadFiles.txt
	$JAVA_COMMAND -jar $CLOSURE_LIB --js ./src/$JS_RESULT_HEAD_FILE_NAME.js --js_output_file ./target/$JS_RESULT_HEAD_FILE_NAME.min.js
}

packageFooterJS () {
	JS_RESULT_FOOTER_FILE_NAME="browse-common-content-footer-bundle"
	# Copy down JS Footer files
	while read -r line || [[ -n $line ]]
	do 
		#get Filename
		filename=`basename $line .js`
		# merge to output file
		echo "/*--- Start $filename.js  ---*/" >> ./src/$JS_RESULT_FOOTER_FILE_NAME.js
		cat ./src/$filename.js >> ./src/$JS_RESULT_FOOTER_FILE_NAME.js
		echo "/*--- End $filename.js  ---*/" >> ./src/$JS_RESULT_FOOTER_FILE_NAME.js
	done < ./fileLists/jsFooterFiles.txt
	$JAVA_COMMAND -jar $CLOSURE_LIB --js ./src/$JS_RESULT_FOOTER_FILE_NAME.js --js_output_file ./target/$JS_RESULT_FOOTER_FILE_NAME.min.js
}

packageHomeJS () {
	JS_RESULT_FILE_NAME="home-content-bundle"
	# Copy down JS files
	while read -r line || [[ -n $line ]]
	do 
		#get Filename
		filename=`basename $line .js`
		# merge to output file
		echo "/*--- Start $filename.js  ---*/" >> ./src/$JS_RESULT_FILE_NAME.js
		cat ./src/$filename.js >> ./src/$JS_RESULT_FILE_NAME.js
		echo "/*--- End $filename.js  ---*/" >> ./src/$JS_RESULT_FILE_NAME.js
	done < ./fileLists/jsHomeFiles.txt
	$JAVA_COMMAND -jar $CLOSURE_LIB --js ./src/$JS_RESULT_FILE_NAME.js --js_output_file ./target/$JS_RESULT_FILE_NAME.min.js
}

packageSearchJS () {
	JS_RESULT_FILE_NAME="search-content-bundle"
	# Copy down JS files
	while read -r line || [[ -n $line ]]
	do 
		#get Filename
		filename=`basename $line .js`
		# merge to output file
		echo "/*--- Start $filename.js  ---*/" >> ./src/$JS_RESULT_FILE_NAME.js
		cat ./src/$filename.js >> ./src/$JS_RESULT_FILE_NAME.js
		echo "/*--- End $filename.js  ---*/" >> ./src/$JS_RESULT_FILE_NAME.js
	done < ./fileLists/jsSearchFiles.txt
	$JAVA_COMMAND -jar $CLOSURE_LIB --js ./src/$JS_RESULT_FILE_NAME.js --js_output_file ./target/$JS_RESULT_FILE_NAME.min.js
}

packageEventJS () {
	JS_RESULT_FILE_NAME="event-content-bundle"
	# Copy down JS files
	while read -r line || [[ -n $line ]]
	do 
		#get Filename
		filename=`basename $line .js`
		# merge to output file
		echo "/*--- Start $filename.js  ---*/" >> ./src/$JS_RESULT_FILE_NAME.js
		cat ./src/$filename.js >> ./src/$JS_RESULT_FILE_NAME.js
		echo "/*--- End $filename.js  ---*/" >> ./src/$JS_RESULT_FILE_NAME.js
	done < ./fileLists/jsEventFiles.txt
	$JAVA_COMMAND -jar $CLOSURE_LIB --js ./src/$JS_RESULT_FILE_NAME.js --js_output_file ./target/$JS_RESULT_FILE_NAME.min.js
}

case $TYPE in
    'all' )
		if [ "$ACTION" == "pull" ] || [ "$ACTION" == "pull_package" ]
			then 
			getLatestFilesFiles cssHomeFiles css
			getLatestFilesFiles jsHeadFiles js
			getLatestFilesFiles jsFooterFiles js
			getLatestFilesFiles jsHomeFiles js
			getLatestFilesFiles jsSearchFiles js
			getLatestFilesFiles jsEventFiles js
		fi
		if [ "$ACTION" == "package" ] || [ "$ACTION" == "pull_package" ]
			then
	        	packageHomeCSS 
	  			packageHeadJS
	  			packageFooterJS
	        	packageHomeJS       
	        	packageSearchJS       
	        	packageEventJS
        fi       
        ;;
    'css_home' )
		if [ "$ACTION" == "pull" ] || [ "$ACTION" == "pull_package" ]
			then 
				getLatestFilesFiles cssHomeFiles css
		fi
		if [ "$ACTION" == "package" ] || [ "$ACTION" == "pull_package" ]
			then
	        	packageHomeCSS 
        fi       
        ;;
    'js_browse' )
		if [ "$ACTION" == "pull" ] || [ "$ACTION" == "pull_package" ]
			then 
			getLatestFilesFiles jsHeadFiles js
			getLatestFilesFiles jsFooterFiles js
		fi
		if [ "$ACTION" == "package" ] || [ "$ACTION" == "pull_package" ]
			then
	        packageHeadJS
    	    packageFooterJS
        fi       
        ;;
    'js_home' )
		if [ "$ACTION" == "pull" ] || [ "$ACTION" == "pull_package" ]
			then 
			getLatestFilesFiles jsHomeFiles js
		fi
		if [ "$ACTION" == "package" ] || [ "$ACTION" == "pull_package" ]
			then
	        packageHomeJS       
        fi       
        ;;
    'js_search' )
		if [ "$ACTION" == "pull" ] || [ "$ACTION" == "pull_package" ]
			then 
			getLatestFilesFiles jsSearchFiles js
		fi
		if [ "$ACTION" == "package" ] || [ "$ACTION" == "pull_package" ]
			then
	        packageSearchJS       
        fi       
        ;;
    'js_event' )
		if [ "$ACTION" == "pull" ] || [ "$ACTION" == "pull_package" ]
			then 
			getLatestFilesFiles jsEventFiles js
		fi
		if [ "$ACTION" == "package" ] || [ "$ACTION" == "pull_package" ]
			then
	        packageEventJS       
        fi       
        ;;
esac
