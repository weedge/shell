#!/bin/bash
# 2015年 04月 03日 星期四 16:53:34 CST
# wuyong
# 用expect登陆远程服务器执行命令

path=`dirname $0`

expect_exited=`rpm -qa | grep expect`
if [ x$expect_exited == "x" ] ; then
	yum install -y expect.x86_64
fi
if [ $# -eq 4 ] ; then
	${path}/ssh-buildTuanIndex.expect $1 $2 $3 $4
fi

