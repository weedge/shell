#!/bin/bash
#统计扣电影有影院信息的城市 ****是key,三方提供
enc=`php -r "echo (strtolower(md5(urlencode('city_Query'.time().'*****'))));"`;

time_stamp=`date '+%s'`;

curl --header "channel_id: 130" --data-urlencode "action=city_Query" --data-urlencode "time_stamp=${time_stamp}" --data-urlencode "enc=${enc}" "http://api.komovie.cn/movie/service" | jq '.cities[] | {cinemaCnt:.allCinemaCnt,cityName:.cityName}'|tr -d '\n'|sed 's/}/}\n/g'|awk -F " " '{if($3!="0,")print $5}' | sed 's/"//g' | sed 's/}//g' | sed "s/市//g"

