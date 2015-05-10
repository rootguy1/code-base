#!/usr/bin/perl
# Author : Imran Ahmed <researcher6@live.com>
# URL  : www.experthelpme.com
# This is the encryption script. 
# It uses an input file and encrypts it using substitution method.
 
use strict;        # Standard library
use warnings;	   # To display warnings!	

# WE DECLARE VARIABLES BELOW 
my $usage = "Usage: $0 <inputfile>\n";   # THIS WILL BE DISPLAYED UPON ERROR. WE STORE IT IN A VARIABLE NAMED :USAGE
my $secret = 500;		# OUR SECRTET NUMBER (KEY)
my $inputfile = shift or die $usage;   
# INPUT FILE IS THE FIRST ARGUMENT WE TYPE AT COMMAND LINE 

# TO STRIP THE INPUT EXTENSION AND REPLACE WITH .enc
my @values = split('\.', $inputfile);
# OUTPUT FILE NAME IS THE SECOND ARGUMENT .
my $outputfile = $values[0];
# WE ADD THE EXTENSION .enc HERE.

$outputfile = "$outputfile.enc";

# TO MAKE THE KEY 
$secret = $secret % 26;

# WE KEEP OUR ALPHABETIC CHARACTERS IN ARRAYS. HERE WE WILL LET ORU PROGRAM TO RECOGNIZE ALL UPPER AND lower ALPHABETS.

my @lower_chars = ('a'..'z');
my @upper_chars = ('A'..'Z');

# CREATE TWO ARRAYS FOR SMALL ALPHABETS. ONE TO KEEP IN NORMAL ORDER AND SECOND TO KEEP IN SHIFTED ORDER ACCORDING TO SECRET KEY 
my @first = map { chr } ord ( 'a' ) .. ord ( 'z' );

# NOW WE POPULATE TEH SECOND ARRAY
my @second = map { chr } ord ( $lower_chars[$secret] ) .. ord ( 'z' );

push(@second, @lower_chars[0..$secret-1]);

# SIMILARLY CREATE TWO ARRAYS FOR CAPITAL ALPHBETS.
my @first_cap = map { chr } ord ( 'A' ) .. ord ( 'Z' );
my @second_cap = map { chr } ord ( $upper_chars[$secret] ) .. ord ( 'Z' );
push(@second_cap, @upper_chars[0..$secret-1]);
 
# NOW PUT THE SHIFTED ONES INTO FIRST ARRAY
my %key = ();
   for(my $i=0;$i<scalar(@first);++$i){
      $key{$first[$i]} = $second[$i];
   }
   for(my $i=0;$i<scalar(@first_cap);++$i){
      $key{$first_cap[$i]} = $second_cap[$i];
   }

# BELOW WE READ THE ALPHABETS FROM THE INPUT FILE
my @inputfile = ();
open(IN,'<',$inputfile) || die "Could not open $inputfile: $!\n";
while(<IN>){
   chomp;
   push(@inputfile,$_);
}
close(IN);

# BELOW WE PERFORM THE CHARACTER REPLACEMENT AGAINST EACH LINE OF INPUT FILE 
my @mod = ();
foreach my $line (@inputfile){
   my $length = length($line);
   my $mod = '';
   for(my $i=0;$i<$length;++$i){
      my $actual = substr($line,$i,1);
	# If the actual character belongs to normal alphates and not special characters, then we add it to the modified variable
      if ($actual =~ /[^a-zA-Z]/){
         $mod .= $actual;
         next;
      } else {
	# WE DO NOT REPLACE IT OTHERWISE
         my $altered = $key{$actual};
         $mod .= $altered;
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
close(OUT); 
exit(0);
