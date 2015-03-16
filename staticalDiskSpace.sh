#!/bin/bash
#统计/usr目录下的目录空间根据maxdepth调解遍历深度，（默认安装位置，可能给个空间小，可以通过软连将目录转移~~	）
find /usr/ -maxdepth 1 -type d -exec du -sb '{}' \; | sort -nk 1

#比如统计发现/usr/local/percona中的data文件夹过大，木有定时删除, 或者不想删除，可以将其percona转移的其他文件夹
ls /usr/local/ | grep percona | xargs rm -r && ln -s /search/local/percona percona

