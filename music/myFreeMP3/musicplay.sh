#!/bin/bash
#description     :This script will create a music playlist and play it
#author      :Kris Occhipinti <http://FilmsByKris.com>
#date            :20170501
#version         :0.2
#License     :GPLv3 https://www.gnu.org/licenses/gpl-3.0.txt    

site="https://myfreemp3.click"
url="https://myfreemp3.click/api/search.php?callback=jQuery21301101852661060918_1493583931877"
q="$1"
pl="/tmp/music.m3u"
l="==============="
tmp="/tmp/music.tmp"
info="/tmp/music.info"

#set colors
bold=`echo -en "\e[1m"`
red=`echo -en "\e[31m"`
normal=`echo -en "\e[0m"`

#remove tmp files
rm "$tmp $info $pl" 2>/dev/null

if [ $# -lt 1 ]
then
  echo "Sorry, no input given..."
  echo "try something like this:"
  echo "$0 'nine inch nails' shuff"
  echo "Goodbye..."
  exit 1
fi

echo "${bold}$l Creating Playlist $l${normal}"

curl "$url" -H "origin: $site" -H 'accept-encoding: gzip, deflate, br' -H 'x-requested-with: XMLHttpRequest' -H 'accept-language: en-US,en;q=0.8' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'accept: text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01' -H 'referer: https://myfreemp3.click/' -H 'authority: myfreemp3.click' -H 'cookie: __cfduid=da06ebcf2a76fa5a4b2ae6842f589d93f1492027491; __atssc=google%3B1; musicLang=en; __utmt=1; __utma=245448472.761302065.1492027494.1493036598.1493583571.4; __utmb=245448472.2.10.1493583571; __utmc=245448472; __utmz=245448472.1492027494.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); __atuvc=1%7C15%2C1%7C16%2C1%7C17%2C2%7C18; __atuvs=590646d3f092f1aa001' --data "q=$q&sort=2&count=300&performer_only=0" --compressed -o "$tmp"

cat "$tmp"|\
  sed 's/{/\n{/g'|\
  sed 's/,/,\n/g'|\
  grep "url"|\
  cut -d\" -f4|\
  sed 's/\\//g' > "$pl" 

#get url and song title into info file 
cat "$tmp"|\
  sed 's/{/\n{/g'|\
  sed 's/,/,\n/g'|\
  grep -e "title" -e "url"|\
  cut -d\" -f4|\
  sed 's/\\//g'|\
  sed ':r;$!{N;br};s/\nhttp/|http/g' > "$info"

#shuffle playlist
if [ "$2" == "shuff" ]
then
  echo "Shuffling Songs"
  shuf "$pl" > /tmp/shuf
  mv /tmp/shuf "$pl"
fi

#display first 20 song titles
echo "${bold}${red}"
head -n20 "$pl"|\
while read line;
do 
  grep "$line" "$info"|cut -d\| -f1;
done
echo "${normal}"

#play playlist
mpv --no-ytdl --no-audio-display "$pl"


