#!/bin/bash
#统计网票有影院信息的城市

#获取网票有影院的城市id (sign由网票接口方提供)
sign="***"
curl --data-urlencode "Target=Base_Cinema" --data-urlencode "UserName=WP_SGWPWAPI" --data-urlencode "Sign=${sign}" "http://channel.api.wangpiao.com/2.0/" | jq .Data[].CityID | sort -nr | uniq > wangpiao_cinema_cityIds

#获取城市id和名称
sign="***"
curl --data-urlencode "Target=Base_City" --data-urlencode "UserName=WP_SGWPWAPI" --data-urlencode "Sign=${sign}" "http://channel.api.wangpiao.com/2.0/" | jq '.Data[]|{id:.ID,name:.Name}' | tr -d "\n" | sed "s/{/\n{\n/g" | sed "s/}/\n}\n/g" | awk -F' ' '{if($1!="}"&&$1!="{"&&$0!="")print $2,$4}' | sed "s/, \"/ /g" | cut -d '"' -f1 | sort -k1 -nr > wangpiao_cities

cat wangpiao_cinema_cityIds wangpiao_cities > temp

cat temp | sort -n |awk -F' ' 'BEGIN{id_num=0;} {if(a[$1]==0){a[$1]=1;b[id_num++]=$1;c[$1]=$2;}else{a[$1]++;c[$1]=$2;}} END{for(i=0;i<=id_num;i++)print a[b[i]],b[i],c[b[i]];}' | awk -F' ' '{if($1>1)print $3}' | sed "s/市//g"

