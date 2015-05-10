#!/usr/bin/python
import os,sys
# check_load_relative.py
# Author: Imran Ahmed
# Desciption : This scrips displays the relative load for system with multi core cpus.


# CONCEPTS
# ---------
# First of all we need to explain how cpu load works (for linux at least!) 
# For a single core cpu if the load is 1 that means its running on full capacity.
# This means the percentage load is 100%. 
# Similarly if the load is 0.5 on a single core cpu then percentage load is 50%.
# We can display the calculations for 1 , 8 and 16 core cpus as below:
# ===============================================================================
# ||# of CPUs || LOAD || ABSOLUTE PERCENT(ABS%)|| RELATIVE PERCENT  (REL%)    ||
# ===============================================================================
# ||    01    || 0.50 || = 100 X LOAD = 50.0%  || ABS% /# of CPUs =50/01 =50% ||
# ||    01    || 1.00 || = 100 X 1.0  = 100%   || 100/01 = 100%               ||
# ||    01    || 2.00 || = 100 X 2.0  = 200%   || 200/01 = 200%		    ||
# ||    01    || 10.2 || = 100 X 10.2 = 1020%  || 1020/01= 1020%	            ||
# ||    08    || 0.50 || = 100 X 0.50 = 50.0%  || 50/08  = 6.25%   	    ||
# ||    08    || 1.00 || = 100 X 1.0  = 100%   || 100/08 = 12.5%             ||
# ||    08    || 2.00 || = 100 X 2.0  = 200%   || 200/08 = 25.0%		    ||
# ||    08    || 10.2 || = 100 X 10.2 = 1020%  || 1020/08= 127.5%	    ||
# ||    16    || 0.50 || = 100 X 0.50 = 50.0%  || 50/16  = 3.125%	    ||
# ||    16    || 1.00 || = 100 X 1.0  = 100%   || 100/16 = 6.25%             ||
# ||    16    || 2.00 || = 100 X 2.0  = 200%   || 200/16 = 12.5%		    ||
# ||    16    || 10.2 || = 100 X 10.2 = 1020%  || 1020/16= 63.75%	    ||
# ===============================================================================
# As we can see from the above table that ABS% values do not reflect accurate results when # of CPUs is greater than 1.
# This can be addressed in REL%.

argc= len(sys.argv)
# Check for valid number of arguments 
# It is ok to provide only warning threshold and no critical threshold
# as we default it to 200

if argc<2:
	print "Usage: " 
	print sys.argv[0] , " <warning threshold> [critical threshold]" 
	sys.exit(3)
	
#variables
warning=float(sys.argv[1])
if argc>2:
	critical=float(sys.argv[2])
else:
	critical=200.0

loadavg= [0,0,0]

#get the loadavg values from system
loadavg[0]=os.popen("cat /proc/loadavg | awk '{print $1}'").readline().strip()
loadavg[1]=os.popen("cat /proc/loadavg | awk '{print $2}'").readline().strip()
loadavg[2]=os.popen("cat /proc/loadavg | awk '{print $3}'").readline().strip()

#We will use only highest load value out of the three above.
maxLoad =float(max(loadavg))
# We calculate relative load = 100 * maxLoad/# of CPUs
# So first we will calculate no of CPUs.
# This is for UBUNTU ! (for other distros we need to change the command)

noCpu =os.popen("cat /proc/cpuinfo | grep processor | wc -l").readline().strip()
noCpu = int(noCpu)
maxLoad = (100 * maxLoad)/noCpu 

if maxLoad >= critical:
	# If load is higher than warning threshold.
	print "CRITICAL - relative load is  %s" %maxLoad + "%"
	sys.exit(2)
elif maxLoad >= warning:
	print "WARNING - relative load is %s" %maxLoad + "%"
	sys.exit(1)
elif maxLoad < warning:
	print "OK - relative load is %s" %maxLoad + "%"
	sys.exit(0)
else:
	print "UNKNOWN - relative load is %s" %maxLoad + "%"
	sys.exit(3)

