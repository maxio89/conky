#!/bin/bash
killall conky
sleep 20
conky -c ~/.conkyrc & 
conky -p 6 -c ~/.conky/conkyconfig/configs/conky_cpu &
conky -p 8 -c ~/.conky/conkyconfig/configs/conky_ram
exit
