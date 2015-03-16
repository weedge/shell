#!/bin/bash
#统计/usr目录下的目录空间根据maxdepth调解遍历深度，（默认安装位置，可能给个空间小，可以通过软连将目录转移~~	）
find /usr/ -maxdepth 1 -type d -exec du -sb '{}' \; | sort -nk 1
