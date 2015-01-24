#!/bin/bash

sh ./meituanCity.sh > meituan_cinema_cities.txt

sh ./komovieCity.sh > komovie_cinema_cities.txt

sh ./wangpiaoCity.sh > wangpiao_cinema_cities.txt

cat wangpiao_cinema_cities.txt komovie_cinema_cities.txt meituan_cinema_cities.txt > cities.txt

cat cities.txt | sort | uniq -c | awk -F' ' '{if($1>0)print $2}' > AllSiteCities.txt



