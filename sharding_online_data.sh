#!/bin/bash
seq_num=`seq 0 14`
for i in $seq_num; do
	mysqldump -h10.12.143.215 -utuanuser -ptuandev123 tuan --table online_data > create_online_data_table.sql

	awk '$0~/PRIMARY/{$0=substr($0,0,length($0)-1);} $0!~/category2/{print;}' create_online_data_table.sql > create_online_data_table_tmp.sql  

	sed_str='s/online_data/old_data_'${i}'/g'
	sed -i ${sed_str} create_online_data_table_tmp.sql
	create_table_sql='create_old_data_table'${i}'.sql'
	mv create_online_data_table_tmp.sql $create_table_sql
	sql=`cat ${create_table_sql}`
	#echo $sql
	mysql -h10.12.143.215 -utuanuser -ptuandev123 tuan -e "${sql}"
	del_sql='DROP TABLE IF EXISTS online_td_'${i}';'
	mysql -h10.12.143.215 -utuanuser -ptuandev123 tuan -e "${del_sql}"
done
