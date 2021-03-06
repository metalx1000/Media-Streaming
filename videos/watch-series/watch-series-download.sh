#!/bin/bash

tmp="/tmp/watch-series-$RANDOM"
dom="https://watch-series.co"
search="/search.html?keyword=$1"

#color settings
bold=`echo -en "\e[1m"`
red=`echo -en "\e[31m"`
default=`echo -en "\e[39m"`
blue=`echo -en "\e[34m"`
reverse=`echo -en "\e[7m"`
normal=`echo -en "\e[0m"`

###search for series
wget -q -O- "${dom}${search}"|grep series|grep view_more|cut -d\" -f2,6|tr '"' '|'|while read l
do
  echo "${dom}${l}"
done > $tmp

let x=1;
cat $tmp|cut -d\| -f2|while read line
do
  echo "${red}$x ${default} - ${blue} $line"
  let x++;
done

echo -n "${bold}${blue}Please select a number to download: ${default}${normal}"
read s

###get all episodes
d="$(sed "${s}q;d" $tmp|cut -d\| -f1)/season"
echo "$d"
wget -q -O- "$d"|grep "vid_info"|tac|cut -d\" -f 4,6|tr '"' '|'|while read l
do
  echo "${dom}${l}"
  d="$(echo "${dom}${l}"|cut -d\| -f1)"
  #dd="$(wget -q -O- "$d"|grep yourupload|cut -d\" -f6|sed 's/embed/watch/g')"
  dd="$(wget -q -O- "$d" |grep -i data-video|cut -d\" -f6|grep '^http'|sort -R|grep -Ev '(openload|thevideo)'|head -n1)"
  t="$(echo "${dom}${l}"|cut -d\| -f2|tr ":" "-")"
  echo "${red}########### DOWNLOADING $t - $ddd #############${default}"
  echo "${blue}${dd}${default}"
  youtube-dl "$dd" -o "${t}.mp4"

done 

rm $tmp

