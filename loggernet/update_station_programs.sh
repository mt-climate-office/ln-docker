#!/bin/bash

cd /opt/mesonet-ln-config

stations="`curl https://fcfc-mesonet-staging.cfc.umt.edu/api/loggernet | jq -r '. | @sh' | tr -d \'`"

echo $stations

for station in $stations
do
	cora_cmd \
        --echo=on \
        --input="{
            connect localhost;
            get-program-file $station --use-cache=true --file-name=$station.txt --file-path=/opt/mesonet-ln-config/;
            }"
    
    if [ -s \\$station.txt ]
    then
        mv \\$station.txt $station.txt
    else
        rm -f \\$station.txt
    fi
    
done

find . -size  0 -print -delete

git add .
git commit -m "updated station program backups"
git push
