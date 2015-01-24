#!/bin/bash

#统计美团有影院信息的城市
cities=(`curl "http://platform.mobile.meituan.com/open/maoyan/v1/cities.json" | jq '.data[].nm' | cut -d '"' -f2| xargs echo`);

for i in ${cities[*]}
do
	res=`curl "http://platform.mobile.meituan.com/open/maoyan/v1/cinemas.json?ct=${i}"| jq .data`;
	if [ "$res" = "null" ];then 
		continue;
	else 
		echo $i;
		usleep 100;
	fi
done | sed "s/市//g"

