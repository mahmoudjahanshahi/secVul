#!/usr/bin/bash

#vulnerable projects
cat output/ulikunitz_xz/vulnerable.html | 
grep "^project" | 
sed 's/.*\.com\///;s/<.*$//;s/\//_/' |
sort |
uniq > data/ulikunitz_xz/projects;

#deforked projects
cat data/ulikunitz_xz/projects |
~/lookup/getValues -f p2P |
cut -d\; -f2 |
sort |
uniq > data/ulikunitz_xz/Projects;

