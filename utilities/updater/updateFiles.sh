#!/bin/bash
##
## Declare all the sites that you want to download the cvs files from into an array.
##   Error codes:
##     0 - Everything went fine, no updated files
##     1 - Everything went fine, at least one updated file
##
## The exit status can be used to help other scripts decide if it is time to update 
## the files in the vulscan folder.
##
declare -a FILES=(
    "https://raw.githubusercontent.com/scipag/vulscan/master/cve.csv"
    "https://raw.githubusercontent.com/scipag/vulscan/master/exploitdb.csv"
    "https://raw.githubusercontent.com/scipag/vulscan/master/openvas.csv"
    "https://raw.githubusercontent.com/scipag/vulscan/master/osvdb.csv"
    "https://raw.githubusercontent.com/scipag/vulscan/master/scipvuldb.csv"
    "https://raw.githubusercontent.com/scipag/vulscan/master/securityfocus.csv"
    "https://raw.githubusercontent.com/scipag/vulscan/master/securitytracker.csv"
    "https://raw.githubusercontent.com/scipag/vulscan/master/xforce.csv"
)

UPDATED=false

##
## Enable / Disable debug output.
##
DEBUG=true

##
## Simple debug function, to help debug if debug is on.
##   example use:
##      logIfDebug "Hello world!"
##
function logIfDebug(){
    if [ $DEBUG = true ]
    then
	echo "$1"
    fi
}

##
## Create teporary download directory
##
mkdir -p downloading

##
## Work from the temp directory
##
cd downloading

##
## For each file, we want to download it, and see if it differs from old one.
##    If it differs, we assume that it is new, and thus we want to replace the old one.
##    Unfortunately GitHub is issuing the cert for www.github.com only and not for other
##    domains which is why we need to ignore cert warnings
##
for file in "${FILES[@]}"
do    
    logIfDebug "Downloading ${file}..."
    wget --quiet --no-check-certificate ${file}
    filename=$(echo ${file} | awk -F/ '{print $NF}')
    result=$(diff --suppress-common-lines --speed-large-files -y ${filename} ../../../${filename} | wc -l)
    if [ ${result} -ne 0 ]; then
	logIfDebug "Updating ${filename} as it differs"
	mv ${filename} ../../../
	UPDATED=true
    fi
done

##
## Remove the temporary directory
##
cd ..
rm -rf downloading

##
## All is well, exit with error code 0.
##
if [ $UPDATED = true ]
then
    logIfDebug "Returning 1, as at least one file has been updated."
    exit 1;
else
    logIfDebug "Returning 0, as no files have been updated, but script ran successfully"
    exit 0;
fi
