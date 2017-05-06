#!/bin/bash
q="$1"
tmp=/tmp/123movies.tmp
cookie="cookie: __cfduid=d0d51e448719a2a63af2a3bb2d11c5ecb1490488836; gogoanime=i95kmtnq72500afnjnrta995d5; __atssc=google%3B1; __test; __atuvc=7%7C14%2C5%7C15%2C0%7C16%2C0%7C17%2C4%7C18; __atuvs=590cb4282204c3ea000; _ga=GA1.2.247199771.1490488838; _gid=GA1.2.1287305608.1494004778; _gat=1; subscribe=1"
enc="accept-encoding: gzip, deflate, sdch, br"
req='x-requested-with: XMLHttpRequest'
lang='accept-language: en-US,en;q=0.8'
agent='user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36'
app='accept: application/json, text/javascript, */*; q=0.01'

uriencode() {
  s="${1//' '/'%20'}"
  s="${s//'"'/'%22'}"
  s="${s//'#'/'%23'}"
  s="${s//'$'/'%24'}"
  s="${s//'&'/'%26'}"
  s="${s//'+'/'%2B'}"
  s="${s//','/'%2C'}"
  s="${s//'/'/'%2F'}"
  s="${s//':'/'%3A'}"
  s="${s//';'/'%3B'}"
  s="${s//'='/'%3D'}"
  s="${s//'?'/'%3F'}"
  s="${s//'@'/'%40'}"
  s="${s//'['/'%5B'}"
  s="${s//']'/'%5D'}"
  printf %s "$s"
}

curl -s "https://123movieshd.tv/ajax/suggest_search?keyword=$q" -H "$enc" -H "$req" -H "$lang" -H "$agent" -H "$app" -H 'referer: https://123movieshd.tv/' -H 'authority: 123movieshd.tv' -H "$cookie" --compressed|\
  sed 's/</\n</g'|\
  grep href|\
  grep -v url|\
  cut -d\" -f2|\
  sed 's/\\\//\//g'|\
  cut -d\\ -f1|\
  while read l;
  do 
    echo "https://123movieshd.tv${l}/watching.html?ep=1";
  done > "$tmp"

cat "$tmp"
cat "$tmp"|while read l;
  do
    curl -s "$l" -H 'accept-encoding: gzip, deflate, sdch, br' -H 'x-requested-with: XMLHttpRequest' -H 'accept-language: en-US,en;q=0.8' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36' -H 'accept: application/json, text/javascript, */*; q=0.01' -H 'referer: https://123movieshd.tv/' -H 'authority: 123movieshd.tv' -H 'cookie: __cfduid=d0d51e448719a2a63af2a3bb2d11c5ecb1490488836; gogoanime=i95kmtnq72500afnjnrta995d5; __atssc=google%3B1; __test; __atuvc=7%7C14%2C5%7C15%2C0%7C16%2C0%7C17%2C4%7C18; __atuvs=590cb4282204c3ea000; _ga=GA1.2.247199771.1490488838; _gid=GA1.2.1287305608.1494004778; _gat=1; subscribe=1' --compressed
done|grep 'id-data'|grep 'title'|cut -d\" -f2,8|sort -u|
    while read line;
    do
      #echo "++++++++++++++++++$line++++++++++++++"
      title="$(echo $line|cut -d\" -f1)"
      echo "========$title======"  
      id="$(echo $line|cut -d\" -f2)"  
      wget -q "https://embed.123movieshd.tv/embedjw.php?id=$id" -O-|\
        grep googlev|\
        cut -d\' -f2|while read url
       do
         url="$(uriencode "$url")"
         wget -q "https://is.gd/create.php?format=simple&url=$url" -O-
         echo ""
       done
    done

