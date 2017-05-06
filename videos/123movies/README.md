#one liner to download videos after retrieving the list
sed 'N;s/\n/ /' list|sed 's/=//g'|sed 's/^/wget -c -O "/g'|sed 's/ http/.mp4" http/g'|while read c;do eval $c;done
