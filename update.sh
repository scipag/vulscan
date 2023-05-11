#!/bin/bash

declare -a databases=("cve" "exploitdb" "openvas" "osvdb" "scipvuldb" "securityfocus"
"securitytracker" "xforce")

for DB in "${databases[@]}"; do
    /usr/bin/wget https://www.computec.ch/projekte/vulscan/download/${DB}.csv
    
    if [ -f ${DB}.csv.1 ]; then
        mv ${DB}.csv.1 ${DB}.csv
    fi
done
