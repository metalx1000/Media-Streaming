#!/bin/bash

#check if root user
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user"
  echo "Trying to restart script as sudo"
  sudo $0
  exit
fi

cp -v music/myFreeMP3/musicplay.sh /usr/local/bin/musicplay
cp -v music/youtube/ytmusic.sh /usr/local/bin/ytmusic
cp -v music/youtube/ytplaylist.sh /usr/local/bin/ytplaylist

cp -v videos/123movies/123movies.sh /usr/local/bin/123movies
#cp -v videos/stream-tv-series/stream-tv-series.sh /usr/local/bin/stream-tv-series
