#!/bin/bash

sh ./meituanCity.sh > meituan_cinema_cities.txt

sh ./komovieCity.sh > komovie_cinema_cities.txt

sh ./wangpiaoCity.sh > wangpiao_cinema_cities.txt

cat wangpiao_cinema_cities.txt komovie_cinema_cities.txt meituan_cinema_cities.txt | sort | uniq > AllSiteCities.txt



