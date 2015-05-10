#!/usr/bin/env python

# printsize.py
# Description : Categorizes files based on their size and prints the number of files in different
# categories.
# Author : Imran Ahmed <researcher6@live.com>
# Website : www.experthelpme.com

import os
def get_size(directory):
    total_size=0
    sizes = []
    for dirpath, dirnames,filenames in os.walk(directory): # 
        for filename in filenames:  # Itrate through list of files under each subfolder
            fname = os.path.join(dirpath, filename) # Get full filename
            size = os.path.getsize(fname) # Calculates size in bytes
            #print fname    # FOR DEBUGING ONLY
            size = (size/1024)  # To convert into Kbytes
            sizes.append(size)  # Add to our new list of sizes
    sizes.sort() # Sort the sizes   
    return sizes
    

def main():
    d ="."
    d = raw_input("Enter a path or '.' for current directory : ")
    if os.path.isdir(d):
        sizes =get_size(d)  
        length = len(sizes) # Total length of sizes
        minsize = sizes[0]  # Minimum value in the list
        maxsize = sizes[length-1] # maximum size value
        #print sizes     # FOR DEBUGING ONLY
        #print "Minimum file size : " , minsize , "k"   # FOR DEBUGING ONLY
        #print "Maximum file size : " , maxsize , "k"   # FOR DEBUGING ONLY
        logv = 4
        cat = 1
        print "|||----------------FILE SIZE SUMMARY----------------|||"
        # First we wil print number of files less than 1
        count = 0 # initialize count to 0
        for x in sizes:             # compare all elemnets in the list
            if (x<=1):              # If size is les than 1
                count=count +1      # 
        print " < 1kB                       :" , count , " files"
        while(cat <= maxsize):
            count =0
            oldcat = cat
            cat = cat * logv
            for x in sizes:
                if (oldcat < x <= cat):   
                    #print " Cat: " , cat, " size :" , x    # FOR DEBUGING ONLY
                    count = count +1      
            print oldcat ,"kB to ", cat, "kB                : " , count  , "files"     
    else:
        print "Directory could not be found"
        exit 
if __name__ == "__main__":
    main()
    
