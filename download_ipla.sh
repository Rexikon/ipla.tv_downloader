#!/bin/bash

##
## https://www.ipla.tv/Sprawiedliwi-wydzial-kryminalny-odcinek-149/vod-10976776
## ipla://playvod-1|40d6e109cdcaa58ab003c7360d74a418
## http://getmedia.redefine.pl/vods/get_vod/?cpid=1&ua=mipla/23&media_id=2ddfaa076499524528986c1cb2a59e47


url=$1
serial=`echo $url | grep -Po "(?<=tv\/)(.*)(?=-odcinek)"`
odcinek=`echo $url | grep -Eo "(\odcinek-[0-9]+)"`
echo "Pobieramy $odcinek serialu $serial"
url_button_extracted=`curl -s $url | grep -Eoi '<a href=\"ipla[^>]+>' | grep -Eo 'ipla://[^/"]+'| sed -e 's/\ipla:\/\/playvod-1|//g'`
url_with_movie_json=`curl -s "http://getmedia.redefine.pl/vods/get_vod/?cpid=1&ua=mipla/23&media_id="$url_button_extracted`
url_with_movie_hd=$(echo $url_with_movie_json | grep -Po '"video_hd":.*?[^\\]",' | sed 's/"video_hd":"//g' | sed 's/",//g' | sed 's/\\//g' )

mkdir -p $serial
wget -q --show-progress --continue --retry-connrefused --tries=10 $url_with_movie_hd -O $serial/$odcinek.mp4
