#!/usr/bin/perl
use strict;
use warnings;

my @messages;
my @keywords;
open FILE,"<","output-inter.txt" or die $!;
#Load the formatted lines in an array
while(my $line=<FILE>) {
	my $len = length($line);
	$len-=1;
	$line = substr $line, 0, $len;
	push(@messages,$line);
	#separate the keywords from the file and store them in a separate array
	$line =~ m/(\*\*)(.*)(\*\*)/;	
	push(@keywords,$2);
}
close(FILE);

my $len = scalar @keywords;
my @numbers = (1..$len);
for(my $i=0;$i<$len;$i+=1) {
	for(my $j=0;$j<$len-1;$j+=1) {		
	#We perform a bubble sort on the keywords extracted from the message. 
		if($keywords[$j] gt $keywords[$j+1]) {
			my $temp = $keywords[$j];
			$keywords[$j] = $keywords[$j+1];
			$keywords[$j+1] = $temp;	
		}
	}
}

my @ordered_messages;
for(my $i=0;$i<$len;$i+=1) {
	push(@ordered_messages,$messages[$numbers[$i]-1]);		
	#We use the sorted keywords' indices to order the lines in messages	
}
my @unique;
my %seen;
foreach my $value (@ordered_messages) {		
	#A hash is used to remove duplicates
	if(! $seen{$value}) {
		push @unique, $value;
		$seen{$value} = 1; 
	}
}

my @timestamp;
my @mod_timestamp;
$len = scalar @unique;

for(my $i=0;$i<$len;$i+=1) {
	$unique[$i] =~ m/(.*)(([A-Za-z][a-z][a-z]).(\d+).((\d\d):(\d\d):(\d\d)))/;
	my $time = $2;
	push(@timestamp,$time);
	$time =~ s/Jan/AA/g;
	$time =~ s/Feb/BB/g;
	$time =~ s/Mar/CC/g;
	$time =~ s/Apr/DD/g;
	$time =~ s/May/EE/g;
	$time =~ s/Jun/FF/g;
	$time =~ s/Jul/GG/g;
	$time =~ s/Aug/HH/g;
	$time =~ s/Sep/II/g;
	$time =~ s/Oct/JJ/g;
	$time =~ s/Nov/KK/g;
	$time =~ s/Dec/LL/g;
	push(@mod_timestamp,$time);	
}

my @key_strings;
for(my $i=0;$i<$len;$i+=1) {
push(@key_strings,$unique[$i]);
       $key_strings[$i] =~ s/$timestamp[$i]//g;
}
for(my $i=0;$i<$len;$i+=1) {
	for(my $j=0;$j<$len-1;$j+=1) {          
		if($key_strings[$j] gt $key_strings[$j+1]) {
			my $temp = $timestamp[$j];
			my $mod_temp = $mod_timestamp[$j];
			my $temp_key = $key_strings[$j];
                        $timestamp[$j] = $timestamp[$j+1];
			$mod_timestamp[$j] = $mod_timestamp[$j+1];
                        $key_strings[$j] = $key_strings[$j+1];
                        $timestamp[$j+1] = $temp;
			$mod_timestamp[$j+1] = $mod_temp;
                        $key_strings[$j+1] = $temp_key;
                }
        }
}

my $previous = "";
my $count = 0;
my $i=0;
my @times;
my @output;
foreach my $value (@key_strings) {
	if($seen{$value}) {
		push(@times,$mod_timestamp[$i]);
		$count+=1;
	} else {
		$seen{$value} = 1;
		$len = length($previous);
		if($len>1) {
			my @tokens = split(' ',$previous);
			my $words = scalar @tokens;
			my $data = "";
			$data = join(' ',$data,$tokens[0],$tokens[1]);
			my $count_string = "#".$count;
			my @sorted_time = sort @times;
			my $start_time = $sorted_time[0];
			my $end_time = $sorted_time[(scalar @sorted_time)-1];
			$start_time =~ s/AA/Jan/g;
			$start_time =~ s/BB/Feb/g;
			$start_time =~ s/CC/Mar/g;
			$start_time =~ s/DD/Apr/g;
			$start_time =~ s/EE/May/g;
			$start_time =~ s/FF/Jun/g;
			$start_time =~ s/GG/Jul/g;
			$start_time =~ s/HH/Aug/g;
			$start_time =~ s/II/Sep/g;
			$start_time =~ s/JJ/Oct/g;
			$start_time =~ s/KK/Nov/g;
			$start_time =~ s/LL/Dec/g;
			$end_time =~ s/AA/Jan/g;
			$end_time =~ s/BB/Feb/g;
			$end_time =~ s/CC/Mar/g;
			$end_time =~ s/DD/Apr/g;
			$end_time =~ s/EE/May/g;
			$end_time =~ s/FF/Jun/g;
			$end_time =~ s/GG/Jul/g;
			$end_time =~ s/HH/Aug/g;
			$end_time =~ s/II/Sep/g;
			$end_time =~ s/JJ/Oct/g;
			$end_time =~ s/KK/Nov/g;
			$end_time =~ s/LL/Dec/g;
			my $tstamp = join('-',$start_time,$end_time);
			$data = join(' ',$data, $count_string, $tstamp);
for(my $i=2;$i<$words;$i+=1) {
				$data = join(' ',$data,$tokens[$i]); 
			}
			push(@output,$data);
for(my $i=0;$i<$count;$i+=1) {
				pop(@times);
			}			
			$previous = $value;
			push(@times,$mod_timestamp[$i]);
                        $count = 1;
		} else {
			$previous = $value;
			push(@times,$mod_timestamp[$i]);
			$count+=1;
		}
	}
	$i+=1;
}
open FILE, ">", "output-final.txt" or die $!;
foreach my $value (@output) {
	print FILE "$value\n";
}
close(FILE);
		

