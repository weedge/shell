#!/bin/bash
# 2015年 03月 26日 星期四 16:53:34 CST
# wuyong
# 分页切分批量并行处理（将搜狗地图坐标转成标准的）
# 重复的发送mysql链接update。（串行update ）

mysql_host=**.**.**.**
mysql_user=****
mysql_password=****
mysql_db=tuan_offline 

sql="mysql -h${mysql_host} -u${mysql_user} -p${mysql_password} ${mysql_db}"

page_size=50000
total_num=`${sql} -e "set names utf8;select count(*) from map_match where lat is not null and lng is not null;"|awk -F'|' '{if(NR!=1){print $1}}'`
chu=$(($total_num/$page_size))
yu=$(($total_num%$page_size)) 
if [ $yu -eq 0 ];then 
	page_num=$chu 
else
	page_num=$(($chu+1)) 
fi

for i in `seq $page_num`;do
	j=$(($i-1))
	start_pos=$(($j*$page_size))
	${sql} -e "set names utf8;select id,lat,lng from map_match where lat is not null and lng is not null limit ${start_pos}, ${page_size};" | awk -F'||\t' '{if(NR!=1){cmd="python SogouCoord.py "$2" "$3;print $1;system(cmd);}}' | awk -F' ' -v mysql=mysql\ -h${mysql_host}\ -u${mysql_user}\ -p${mysql_password}\ ${mysql_db} '{if(NR%2==1){id=$1;} if(NR%2==0){_lat=$1;_lng=$2; sql=mysql" -e \"set names utf8;update map_match set _lat="_lat",_lng="_lng" where id="id";\""; print sql; system(sql);}}' > coordTranslate${i}.log 2>&1 &
	#exit
done
