#!/usr/bin/bash

p=$1;
mkdir data/$p

#projects
echo "Total projects";
for i in {vulnerable,not-vulnerable}; do
	cat output/$p/$i.html | 
	grep "^project" | 
	sed 's/.*"https:\/\///;s/">.*//;s/^github\.com\///;s/\//_/g' |
	sort |
	uniq > data/$p/$i.projects;
	echo $i;
	cat data/$p/$i.projects | wc -l;
done;

#deforked projects
echo "Deforkd projects";
for i in {vulnerable,not-vulnerable}; do
	cat data/$p/$i.projects |
	~/lookup/getValues -f p2P |
	cut -d\; -f2 |
	sort |
	uniq > data/$p/$i.Projects;
	echo $i;
        cat data/$p/$i.Projects | wc -l;
done;

#last_active
for i in {vulnerable,not-vulnerable}; do
	cat data/$p/$i.Projects |
	while read line; do
		lt=$(	echo $line |
			~/lookup/getValues -f P2c | cut -d\; -f2 | 
			~/lookup/getValues c2dat | cut -d\; -f2 | 
			~/lookup/lsort 10G -rn | head -1);
		echo $line\;$lt; 
	done > data/$p/$i.P2t;
done;
##recently active
t6=1609477200;
t18=1577854800;
echo "Active in last 6 and 18 months";
for i in {vulnerable,not-vulnerable}; do
	echo $i;
	cat data/$p/$i.P2t |
	awk -F\; -v t=$t6 '{if ($2 > t) print }' |
	wc -l;
	cat data/$p/$i.P2t |
        awk -F\; -v t=$t18 '{if ($2 > t) print }' |
        wc -l;
done;

#number of stars
for i in {vulnerable,not-vulnerable}; do
	cat data/$p/$i.Projects |
	while read line; do
		ns=$(	zcat /da5_data/basemaps/gz/ght.P2w.cnt |
			grep "^$line\;" |
			cut -d\; -f2);
		echo $line\;$ns;
	done > data/$p/$i.P2ns;
done;
##
echo "More than 1, 10, 100, 1000, 10000 stars";
for i in {vulnerable,not-vulnerable}; do
	echo $i;
	for j in {1,10,100,1000,10000}; do
		cat data/$p/$i.P2ns |
		awk -F\; -v threshold=$j '{if ($2 > threshold) print}' | wc -l;
	done;
done;

