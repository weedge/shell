#!/bin/bash
#@Author: wuyong
#@Date: Mon Jan 26 23:16:49 CST 2015
#@Desc: 统计网票有影院排期信息的城市

day=`date "+%Y-%m-%d"`

#获取城市id和名称
city_ids=(`curl --data-urlencode "Target=Base_City" --data-urlencode "UserName=WP_SGWPWAPI" --data-urlencode "Sign=e53a6d778e1b27b310ef17f889f4e70e" "http://channel.api.wangpiao.com/2.0/" | jq '.Data[].ID'`)
city_names=(`curl --data-urlencode "Target=Base_City" --data-urlencode "UserName=WP_SGWPWAPI" --data-urlencode "Sign=e53a6d778e1b27b310ef17f889f4e70e" "http://channel.api.wangpiao.com/2.0/" | jq '.Data[].Name' | sed "s/\"//g"`)

cities=()
index=0
plan_cities=""

for i in ${city_ids[*]};do
    cities[$i]=${city_names[$index]}
    let "index = $index + 1" 
done

for city_id in ${city_ids[*]};do
    fid=""
    phpscript="echo (strtolower(md5('${city_id}'.'${day}'.'${fid}'.'Base_CinemaQuery'.'WP_SGWPWAPI'.'rkQAECwdWLRyxQBK')));"
    sign=`php -r "${phpscript}"`

    #curl --data-urlencode "Target=Base_CinemaQuery" --data-urlencode "CityID=${city_id}"  --data-urlencode "Date=${day}" --data-urlencode "UserName=WP_SGWPWAPI" --data-urlencode "Sign=${sign}" "http://channel.api.wangpiao.com/2.0/" | jq .Data[].ID | sort -n | uniq
    
    cinema_ids=(`curl --data-urlencode "Target=Base_CinemaQuery" --data-urlencode "CityID=${city_id}"  --data-urlencode "Date=${day}" --data-urlencode "UserName=WP_SGWPWAPI" --data-urlencode "Sign=${sign}" "http://channel.api.wangpiao.com/2.0/" | jq .Data[].ID | sort -n | uniq`)
    for cinema_id in ${cinema_ids[@]};do
        fid="";
        phpscript="echo (strtolower(md5('${cinema_id}'.'${day}'.'${fid}'.'Base_FilmShow'.'WP_SGWPWAPI'.'rkQAECwdWLRyxQBK')));";
        sign=`php -r "${phpscript}"`;

        #curl --data-urlencode "Target=Base_FilmShow" --data-urlencode "UserName=WP_SGWPWAPI" --data-urlencode "Sign=${sign}" --data-urlencode "CinemaID=${cinema_id}" --data-urlencode "Date=${day}" --data-urlencode "FilmId=" "http://channel.api.wangpiao.com/2.0/"| jq '.Data[].CityID' | sort -n | uniq

        city_id=`curl --data-urlencode "Target=Base_FilmShow" --data-urlencode "UserName=WP_SGWPWAPI" --data-urlencode "Sign=${sign}" --data-urlencode "CinemaID=${cinema_id}" --data-urlencode "Date=${day}" --data-urlencode "FilmId=" "http://channel.api.wangpiao.com/2.0/" | jq '.Data[].CityID' | sort -n | uniq`;

        if [ "$city_id" = "" ];then
            #echo -e "${cinema_id}没有~\n";
            continue;
        else
            plan_cities="$plan_cities ${cities[$city_id]}"
            break;
        fi
    done
    usleep 300
done

echo $plan_cities | sed "s/ /\n/g" | sort | uniq

