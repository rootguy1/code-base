#!/usr/bin/perl
# Name: decrypt.pl
# Author : Imran Ahmed <researcher6@live.com>
# Description : This is the decryption script which takes an   encrypted file as input and outputs the plain text content after decrypting. It needs the encrypt.pl script to encrypt the input file.
 
use strict;
use warnings;
 
# THIS IS ALMOST SAME AS ENCRYPT SCRIPT HOWEVER IT REVERSES WHAT WE DID IN ENCRYPT SCRIPT
# VARIABLE DECLARATION
my $usage = "Usage: $0 <inputfile>\n";
my $secret = 500;
# HERE INPUT FILE WILL NOT BE THE PLAINTEXT BUT THE ENCRYPTED TEXT
my $inputfile = shift or die $usage;
$secret = $secret % 26;
# AGAIN TO SAVE THE DECRYPTED FILE WITH SAME NAME BUT DIFFERENT EXTENSION (.dec) WE USE SPLIT FUNCTION.
my @values = split('\.', $inputfile);
# FIRST FIELD WILL BE FILE NAME SO WE TAKE IT AND DISCARD OLD EXTENTION (FIELD 2)
my $outputfile = $values[0];
# NOW WE ADD (.dec) TO IT AND PUT INTO A VARIABLE.
$outputfile = "$outputfile.dec";


# WE CREATE TWO ARRAYS . ONE FOR NORMAL ALPHABETS AND ONE FOR SHIFTED ALPHABETS (same as encrypt script)
my @lower_characters = ('a'..'z');
my @upper_characters = ('A'..'Z');
# WE POPULATE OUR FIRST AND SECOND ARRAYS SO THAT WE CAN SEE WHAT TO BE REPLACED WITH WHICH CHARACTER.
my @first = map { chr } ord ( 'a' ) .. ord ( 'z' );
# THE SECOND ARRAY NEEDS TO BE POPULATED IN TWO STAGES. 
# AT INITIAL STAGE WE FILL THE ARRAY FROM SECRET INDEX UPTO Z. 
my @second = map { chr } ord ( $lower_characters[$secret] ) .. ord ( 'z' );
# IN SECOND PHASE WE POPULATE FROM START (0 INDEX) TO SECRET INDEX.
push(@second, @lower_characters[0..$secret-1]);
#SAME PROCESS GOES FOR CAPITAL ALPHABETS 
my @first_cap = map { chr } ord ( 'A' ) .. ord ( 'Z' );
my @second_cap = map { chr } ord ( $upper_characters[$secret] ) .. ord ( 'Z' );
push(@second_cap, @upper_characters[0..$secret-1]);
 
# WE START A HASH
# THIS WILL ACTUALLY PERFORM SUBSTITUTION (SWAPING) OF ELEMENTS
my %key = ();

   for(my $i=0;$i<scalar(@first);++$i){
      $key{$second[$i]} = $first[$i];
   }
   for(my $i=0;$i<scalar(@first_cap);++$i){
      $key{$second_cap[$i]} = $first_cap[$i];
   }

# NOW WE OPEN THE FILE TO BE DECRYPTED
my @inputfile = ();
open(IN,'<',$inputfile) || die "Could not open $inputfile: $!\n";
while(<IN>){
   chomp;
   push(@inputfile,$_);
}
close(IN);
 # LOOP THROUGH EACH LINE AND COPY IT TO AN ARRAY 
my @mod = ();
foreach my $line (@inputfile){
   my $length = length($line);
   my $mod = '';
# NOW COMPARE EACH CHARACTER FROM INPUT FILE AND REPLACE ACCORDINGLY
   for(my $i=0;$i<$length;++$i){
      my $original = substr($line,$i,1);
      if ($original =~ /[^a-zA-Z]/){
         $mod .= $original;
         next;
      } else {
         my $replaced = $key{$original};
         $mod .= $replaced;
      }
   }
   push(@mod,$mod);
}
# NOW WE NEED TO SAVE THE ENCRYPTED TEXT TO OUTPUT FILE
my @outpuffile =();
open(OUT,'>',$outputfile) || die " Could not write to $outputfile: $!\n";
        foreach my $line (@mod){
        print OUT "$line\n";
        }
# WE CLOSE OUR OUTPUT FILE
close(OUT);
 
 
exit(0);
