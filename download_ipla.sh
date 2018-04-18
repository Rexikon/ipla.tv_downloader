#!/bin/bash
#title           :download_ipla.sh
#description     :Bash downloader from ipla.tv
#author	         :Rexikon
#date            :2017.11.22
#version         :0.2    
#usage           :bash download_ipla.sh url_of_video
#notes           :Install wget, curl if you don't have.
#bash_version    :4.4.12(1)-release

if [[ $# -eq 0 ]] ; then
    echo 'Usage: bash download_ipla.sh url_of_video'
    exit 0
fi
url=$1
serial=`echo $url | cut -d'/' -f6`
odcinek=`curl -s $url | grep -Eo "(\Odcinek-[0-9]+)" | head -n 2 | tail -n 1`
echo "Pobieramy $odcinek serialu $serial"


# old: url_button_extracted=`curl -s $url | grep -Eoi '<a href=\"ipla[^>]+>' | grep -Eo 'ipla://[^/"]+'| sed -e 's/\ipla:\/\/playvod-1|//g'`

#new:
url_button_extracted=`echo $url | cut -d'/' -f9`
url_with_movie_json=`curl -s "http://getmedia.redefine.pl/vods/get_vod/?cpid=1&ua=mipla/23&media_id="$url_button_extracted`
url_with_movie_hd=$(echo $url_with_movie_json | grep -Po '"video_hd":.*?[^\\]",' | sed 's/"video_hd":"//g' | sed 's/",//g' | sed 's/\\//g' )

mkdir -p $serial
wget -q --show-progress --continue --retry-connrefused --tries=10 $url_with_movie_hd -O $serial/$odcinek.mp4
