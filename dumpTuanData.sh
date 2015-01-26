#!/bin/bash
if [ x$1 = "x" ] 
then 
    echo "need args: dev--将线上数据导入开发环境 test--将线上数据导入测试环境 online--将线上数据导出到/search/tuan_sql/中"
    exit
fi

host="**.**.**.**"
user="tuanuser"
passwd="tuandev123"
db="tuan"

if [ x$1 = "xdev" ] 
then
	host="**.**.**.**"
    user="tuanuser"
    passwd="tuandev123"
    db="tuan"
fi 

if [ x$1 = "xtest" ]
then
	host="**.**.**.**"
    user="dhuser"
    passwd="dhtest123"
    db="tuan"
fi 

i=`mysql -h****.mysql.cnc.sogou-op.org -pdhziyuan123 -udhziyuan tuan -e "show tables" | awk '!/Tables_in_tuan/ {print $0}' | xargs echo`
#i=`mysql -hdaohang04.mysql.cnc.sogou-op.org -pdhziyuan123 -udhziyuan tuan -e "show tables" | awk '/mobile/ {print $0}' | xargs echo`

if [ x$1 = "xonline" ];then
    for k in $i;do
        echo "mysqldump -h*****.mysql.cnc.sogou-op.org -pdhziyuan123 -udhziyuan tuan $k > /search/tuan_sql/$k.sql"
        mysqldump -h*****.mysql.cnc.sogou-op.org -pdhziyuan123 -udhziyuan tuan $k > /search/tuan_sql/$k.sql
    done
fi
if [ x$1 = "xdev" ] || [ x$1 = "xtest" ];then
    for k in $i;do 
        echo "mysql -h${host} -u${user} -p${passwd} ${db} -e 'source /search/tuan_sql/$k.sql'"
        mysql -h${host} -u${user} -p${passwd} ${db} -e "source /search/tuan_sql/$k.sql"
    done
fi
