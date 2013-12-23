#!/bin/bash
#killall conky 2> /dev/null;
sleep 10
conky -c ~/.conkyrc & 
conky -p 6 -c ~/.conky/conkyconfig/configs/conky_cpu &
conky -p 8 -c ~/.conky/conkyconfig/configs/conky_ram
exit

