#!/bin/bash

#check if root user
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user"
  echo "Trying to restart script as sudo"
  sudo $0
  exit
fi

cp -v music/myFreeMP3/musicplay.sh /usr/local/bin/musicplay
cp -v videos/123movies/123movies.sh /usr/local/bin/123movies
