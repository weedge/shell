#!/bin/bash
#@Author: wuyong
#@Date: Mon Jan 26 23:16:49 CST 2015
#@Desc: 统计扣电影有影院排期信息的城市

begin_date=`date "+%Y-%m-%d"`
end_date=''

time_stamp=`date '+%s'`;
phpscript="echo (strtolower(md5(urlencode('city_Query'.'${time_stamp}'.'3fjwedDFJ'))));"
enc=`php -r "${phpscript}"`;

#curl --header "channel_id: 130" --data-urlencode "action=city_Query" --data-urlencode "time_stamp=${time_stamp}" --data-urlencode "enc=${enc}" "http://api.komovie.cn/movie/service" | jq '.cities[].cityId'|sort -n|xargs echo

city_ids=(`curl --header "channel_id: 130" --data-urlencode "action=city_Query" --data-urlencode "time_stamp=${time_stamp}" --data-urlencode "enc=${enc}" "http://api.komovie.cn/movie/service" | jq '.cities[].cityId'|sort -n|xargs echo`)

cities=""
for i in ${city_ids[*]}
do
	time_stamp=`date '+%s'`;
	phpscript="echo (strtolower(md5(urlencode('cinema_Query'.'${i}'.'${time_stamp}'.'3fjwedDFJ'))));"
	enc=`php -r "${phpscript}"`;

	#curl --header "channel_id: 130" --data-urlencode "action=cinema_Query" --data-urlencode "city_id=${i}" --data-urlencode "time_stamp=${time_stamp}" --data-urlencode "enc=${enc}" "http://api.komovie.cn/movie/service" 
	cinema_ids=(`curl --header "channel_id: 130" --data-urlencode "action=cinema_Query" --data-urlencode "city_id=${i}" --data-urlencode "time_stamp=${time_stamp}" --data-urlencode "enc=${enc}" "http://api.komovie.cn/movie/service"|jq .cinemas[].cinemaId|sort -n`) 

	for j in ${cinema_ids[*]};do
		time_stamp=`date '+%s'`;
		phpscript="echo (strtolower(md5(urlencode('plan_Query'.'${begin_date}'.'${j}'.'${end_date}'.'${time_stamp}'.'3fjwedDFJ'))));"
		enc=`php -r "${phpscript}"`;

		#curl --header "channel_id: 130" --data-urlencode "action=plan_Query" --data-urlencode "begin_date=${begin_date}" --data-urlencode "end_date=${end_date}" --data-urlencode "cinema_id=${j}" --data-urlencode "time_stamp=${time_stamp}" --data-urlencode "enc=${enc}" "http://api.komovie.cn/movie/service" | jq .plans[].cinema.cityName | sed "s/\"//g" | uniq
		
		city=`curl --header "channel_id: 130" --data-urlencode "action=plan_Query" --data-urlencode "begin_date=${begin_date}" --data-urlencode "end_date=${end_date}" --data-urlencode "cinema_id=${j}" --data-urlencode "time_stamp=${time_stamp}" --data-urlencode "enc=${enc}" "http://api.komovie.cn/movie/service" | jq .plans[].cinema.cityName | sed "s/\"//g" | uniq`
		if [ "$city" = "" ];then
			continue;
		else
			break;
		fi
	done
	cities="${cities} ${city}"
done 

echo ${cities} | sed "s/ /\n/g" | sort | uniq

