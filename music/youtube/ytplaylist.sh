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
  grep ';list=PL'|\
  grep 'yt-uix-tile-link'|\
  cut -d\" -f2|\
  cut -d\; -f2|\
  while read list;
  do 
    echo "http://youtube.com/watch?${list}";
  done > "$playlist"

if [ "$2" == "shuf" ]
then
  echo "shuffling.."
  shuf "$playlist" > /tmp/shuf
  mv /tmp/shuf "$playlist"
fi

mpv --vid=no --playlist="$playlist" 
