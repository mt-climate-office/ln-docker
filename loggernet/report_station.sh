#!/bin/bash

trap 'rm -f "$TMPFILE"' EXIT

TMPFILE=$(mktemp) || exit 1
# echo "Our temp file is $TMPFILE"

## Get a station's data
cora_cmd \
--echo=on \
--input="{
connect localhost; 
logger-query-ex $1 FiveMin $TMPFILE most-recent 5 --format=\"CSIXML\";
}"

cat $TMPFILE |
	xq . |
       tee $TMPFILE >/dev/null

#cat $TMPFILE

curl -T $TMPFILE https://fcfc-mesonet-staging.cfc.umt.edu/api/loggernet
