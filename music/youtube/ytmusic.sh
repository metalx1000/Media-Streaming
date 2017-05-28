#!/bin/bash

if [ $# -lt 1 ]
then
  echo "Sorry, no input given..."
  echo "try something like this:"
  echo "$0 'nine inch nails'"
  echo "Goodbye..."
  exit 1
fi

q="$1"
playlist="/tmp/ytmusic.m3u"

echo "https://www.youtube.com/results?search_query=$q"
wget -O- -q "https://www.youtube.com/results?search_query=$q"|\
  sed 's/</\n</g'|\
  grep 'href="/watch'|\
  cut -d\" -f4|\
  grep '/watch'|\
  while read list;
  do
    echo "http://youtube.com${list}";
  done|shuf > "$playlist"

  mpv --vid=no --playlist="$playlist"
