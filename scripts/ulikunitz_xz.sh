#!/usr/bin/bash

#vulnerable projects
cat output/ulikunitz_xz/vulnerable.html | 
grep "^project" | 
sed 's/.*"https:\/\///;s/">.*//;s/^github\.com\///;s/\//_/g' |
sort |
uniq > data/ulikunitz_xz/projects;

#deforked projects
cat data/ulikunitz_xz/projects |
~/lookup/getValues -f p2P |
cut -d\; -f2 |
sort |
uniq > data/ulikunitz_xz/Projects;

#last_active
cat data/ulikunitz_xz/Projects |
while read line; do
	lt=$(	echo $line |
		~/lookup/getValues -f P2c | cut -d\; -f2 | 
		~/lookup/getValues c2dat | cut -d\; -f2 | 
		sort -rn | head -1);
	echo $line\;$lt; 
done > data/ulikunitz_xz/P2t;
##active in 2021
t=1609477200;
cat data/ulikunitz_xz/P2t |
awk -F\; -v t=$t '{if ($2 > t) print }' |
wc -l;

#number of stars
cat data/ulikunitz_xz/Projects |
while read line; do
	ns=$(	zcat /da5_data/basemaps/gz/ght.P2w.cnt |
		grep "^$line\;" |
		cut -d\; -f2);
	echo $line\;$ns;
done > data/ulikunitz_xz/P2ns;

