#!/bin/bash
#统计访问端口为80的访问量前10的ip
tcpdump -i eth0 -tnn dst port 80 -c 1000 | cut -d' ' -f2 | awk -F'.' '{print $1"."$2"."$3"."$4}' | sort| uniq -c | sort -nr |head -10

