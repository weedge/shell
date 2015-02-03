#!/bin/bash
#@Author: wuyong
#@Date: Mon Jan 26 23:16:49 CST 2015
#@Desc: 统计美团有影院排期信息的城市

day=`date "+%Y-%m-%d"`
plan_cities=""

cities=(`curl "http://platform.mobile.meituan.com/open/maoyan/v1/cities.json" | jq '.data[].nm' | cut -d '"' -f2| xargs echo`)

for i in ${cities[*]}
do
	cinema_ids=(`curl "http://platform.mobile.meituan.com/open/maoyan/v1/cinemas.json?ct=${i}" | jq '.data[]|{id:.id}' | awk -F' ' '{if($1=="\"id\":")print $2}'| sort -n`)
	
	for j in ${cinema_ids[*]}
	do
		plist=`curl "http://platform.mobile.meituan.com/open/maoyan/v1/cinema/${j}/shows.json?dt=${day}" | jq .data.shows[0].plist[0]`
		if [ "${plist}" = "null" ];then
			#echo "${j}没有影讯~~"
			continue
		else
			plan_cities="${plan_cities} ${i}"
			break
		fi
		usleep 400
	done
done 

echo $plan_cities | sed 's/ /\n/g' | sort | uniq

