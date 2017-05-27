#!/bin/bash

if [ "$#" -lt 1 ]
then
  echo "Useage: $0 'show name'"
  echo "Example: $0 'speechless'"
  echo "Goodbye..."
  exit 1
fi

q="$1"

echo "Searching for $q..."
wget -O- -q "http://stream-tv3.co/"|\
  grep '^<li><a href="http'|\
  grep -i "$q"|\
  cut -d\" -f2|while read line
  do
    #echo "$line"
    wget -O- -q "$line"|\
      grep '^<li><a href="http'|\
      cut -d\" -f2|while read page
      do
        echo -n "############### "
        echo "$page"|rev|cut -d\/ -f2|rev|tr '\n' ' '
        echo "###############"
        wget -O- -q "$page"|\
          grep 'iframe'|\
          head -n 1|\
          cut -d\" -f6|while read l
          do
            wget -O- -q "$l"|\
              grep '.mp4'|\
              cut -d\" -f4
          done
      done
  done
