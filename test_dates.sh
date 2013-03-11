#!/bin/bash

#DAY=15
for i in {01..31}
do
    date +%Y%m%d -s "201303$i"
    ./FINAL.sh
done

date +%Y%m%d -s "20130401"
./FINAL.sh
