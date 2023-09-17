#!/usr/bin/env bash

killall wlsunset

while [[ -z $lat ]]; do
	res_str=$(geoiplookup -f /usr/share/GeoIP/GeoIPCity.dat $(curl ipinfo.io/ip))
	read -r lat lon  <<< $(echo $res_str | awk -F ',' '{print $7 $8'})
	sleep 1
done

wlsunset -t 3500 -T 5900 -l $lat -L $lon
