#!/bin/bash
# Author: Imran Ahmed <researcher6@live.com>
# URL : www.experthelpme.com
# Description : This is a custom script which reboots the sever if the memory usage exeeds 95% usage.


percent_allowed=95            #Memory threshhold
memusage=$(top -n 1 -b | grep "Mem")
MAXMEM=$(echo $memusage | cut -d" " -f2 | awk '{print substr($0,1,length($0)-1)}')
USEDMEM=$(echo $memusage | cut -d" " -f4 | awk '{print substr($0,1,length($0)-1)}')

USEDMEM1=$(expr $USEDMEM \* 100)
PERCENTAGE=$(expr $USEDMEM1 / $MAXMEM)
    
swapusage=$(top -n 1 -b | grep "Swap")
MAXSWAP=$(echo $swapusage | cut -d" " -f2 | awk '{print substr($0,1,length($0)-1)}')
USEDSWAP=$(echo $swapusage | cut -d" " -f4 | awk '{print substr($0,1,length($0)-1)}')
USEDSWAP1=$(expr $USEDSWAP \* 100)
percentswap=$(expr $USEDSWAP1 / $MAXSWAP)

echo $percentswap $PERCENTAGE
if [ $PERCENTAGE -gt $percent_allowed ] || [ $percentswap -gt $percent_allowed ]; then 
date >> /var/log/reboot.log
echo  "   Memory threshold exceeded!" >> /var/log/reboot.log
echo "Current Memory usage is :$PERCENTAGE % and allowed threshold is : $percent_allowed % " >> /var/log/reboot.log
echo "Current swap usage is :$percentswap % and allowed threshold is : $percent_allowed % " >> /var/log/reboot.log


free -g >> /var/log/reboot.log
vmstat 4 4 >> /var/log/reboot.log
top -n 1 -b | grep "Mem" >> /var/log/reboot.log
top -n 1 -b | grep "Swap" >> /var/log/reboot.log
date >>  /var/log/top.log
top -n 1 -b  >> /var/log/top.log

date >> /var/log/ps.log
ps aux >> /var/log/ps.log


echo -n `date` >> /var/log/reboot.log
echo "  The server is going to restart now!" >> /var/log/reboot.log

/sbin/init 6
fi


#!/bin/bash
# Author: Imran Ahmed <researcher6@live.com>
# URL : www.experthelpme.com
# Description : This is a custom script which reboots the sever if the memory usage exeeds 95% usage.


percent_allowed=95            #Memory threshhold
memusage=$(top -n 1 -b | grep "Mem")
MAXMEM=$(echo $memusage | cut -d" " -f2 | awk '{print substr($0,1,length($0)-1)}')
USEDMEM=$(echo $memusage | cut -d" " -f4 | awk '{print substr($0,1,length($0)-1)}')

USEDMEM1=$(expr $USEDMEM \* 100)
PERCENTAGE=$(expr $USEDMEM1 / $MAXMEM)
    
swapusage=$(top -n 1 -b | grep "Swap")
MAXSWAP=$(echo $swapusage | cut -d" " -f2 | awk '{print substr($0,1,length($0)-1)}')
USEDSWAP=$(echo $swapusage | cut -d" " -f4 | awk '{print substr($0,1,length($0)-1)}')
USEDSWAP1=$(expr $USEDSWAP \* 100)
percentswap=$(expr $USEDSWAP1 / $MAXSWAP)

echo $percentswap $PERCENTAGE
if [ $PERCENTAGE -gt $percent_allowed ] || [ $percentswap -gt $percent_allowed ]; then 
date >> /var/log/reboot.log
echo  "   Memory threshold exceeded!" >> /var/log/reboot.log
echo "Current Memory usage is :$PERCENTAGE % and allowed threshold is : $percent_allowed % " >> /var/log/reboot.log
echo "Current swap usage is :$percentswap % and allowed threshold is : $percent_allowed % " >> /var/log/reboot.log


free -g >> /var/log/reboot.log
vmstat 4 4 >> /var/log/reboot.log
top -n 1 -b | grep "Mem" >> /var/log/reboot.log
top -n 1 -b | grep "Swap" >> /var/log/reboot.log
date >>  /var/log/top.log
top -n 1 -b  >> /var/log/top.log

date >> /var/log/ps.log
ps aux >> /var/log/ps.log


echo -n `date` >> /var/log/reboot.log
echo "  The server is going to restart now!" >> /var/log/reboot.log

/sbin/init 6
fi


