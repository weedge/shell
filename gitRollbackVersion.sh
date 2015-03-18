#!/bin/bash
#@desc: 一键回滚commit提交的版本（maybe 已经push到远程库）；eg:0=第一次(本次)ci 1=前一次ci 2=前二次ci; 依次类推
#@author: wuyong

#$# 是传给脚本的参数个数
#$0 是脚本本身的名字
#$1是传递给该shell脚本的第一个参数
#$2是传递给该shell脚本的第二个参数
#$@ 是传给脚本的所有参数的列表

if [ "$1" -ge 0 ] 2>/dev/null ;then  
	[ "$1" -eq 0 ] && echo -e "回滚至第1次(本次)版本\n"
    [ "$1" -gt 0 ] && echo -e "回滚至前$1次版本\n"  
	v=`expr $1 + 1`
	sha1=`git log | awk -F' ' '$0~ /^commit /{print $2}' | head -n $v | tail -n 1`
	git reset --hard $sha1
	HEAD=`git branch | awk -F' ' '{if($1=="*")print $2;}'`
	echo -e "回滚分支${HEAD}版本SHA1值：$sha1\n"
	git push origin $HEAD --force
	#git pull origin $HEAD
else  
	echo -e 'eg: 0=第一次(本次)ci 1=前一次ci 2=前二次ci; 依次类推\n'  
fi  
