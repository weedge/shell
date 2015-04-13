#!/bin/bash
# 2015年 04月 03日 星期四 16:53:34 CST
# wuyong
# kill mysql locked sql
mysql_host=**.**.**.**
mysql_user=****
mysql_password=****
mysql_db=tuan 

mysql="mysql -h${mysql_host} -u${mysql_user} -p${mysql_password} ${mysql_db}"

${mysql} -e "show processlist;" | grep Locked |awk -F' ' '{print $1}' |xargs -I '{}' ${mysql} -e "kill '{}'"
