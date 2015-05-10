#!/usr/bin/python
# ldap2grep.py
# Author:Imran Ahmed <researcher6@live.com
# Description : Changes the format of an ldap file so that 'grep' can be used on it.

import sys, re
argc = len(sys.argv)
if argc<2:
        print "Usage :"
        print sys.argv[0]," <ldif-file>"
        sys.exit(3)

fo = sys.argv[1]
file = open(fo)
data = []
for line in file:
        match = re.match( '^ (.*\n)', line )
        #We look for lines starting with white spaces 
        if match:
                # Pop the last line from list
                lastline = re.sub( '(.*)\n', '\\1', data.pop() )
                # Remove the space at the begining of this line and add at end of the last line
                newline = lastline + match.group(1)
                data.append( newline )
                 # Add it to the list again
        else:
                # if no match is found then just go to next line
                data.append(line)
#print the output
for line in data:
        print line
file.close()
