#!/bin/bash
#@Author: wuyong
#@Date: Mon Jan 26 23:16:49 CST 2015
#@Desc: 统计美团，抠电影，网票有影院排期信息的城市

sh ./meituanCity.sh > meituan_filmshow_cities.txt 

sh ./komovieCity.sh > komovie_filmshow_cities.txt

sh ./wangpiaoCity.sh > wangpiao_filmshow_cities.txt

cat wangpiao_filmshow_cities.txt komovie_filmshow_cities.txt meituan_filmshow_cities.txt | sort | uniq > ./cities/AllSiteCities.txt

