#!/bin/bash

declare -a databases=("cve" "exploitdb" "openvas" "osvdb" "scipvuldb" "securityfocus" 
                      "securitytracker" "xforce")

for DB in "${databases[@]}"; do
    wget https://www.computec.ch/projekte/vulscan/download/${DB}.csv
done
