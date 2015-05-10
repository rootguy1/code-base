#!/usr/bin/perl
use strict;
use warnings;
# Variable Declaration
my @patterns;
my @messages;
my $len;
my $i=0;
# Open file containing patterns or keywords
open FILE,"<","keyword.txt" or die $!;
#Load the patterns in an array
while(my $line=<FILE>) {
	push(@patterns,$line);
	$len = length($patterns[$i]);
	$len-=1;
	$patterns[$i] = substr $patterns[$i], 0, $len;	
	#Remove the \n from the end of the patterns
	$i+=1;	
}
close(FILE);
# Now populate the messages array.
$i=0;
open FILE,"<","/var/log/messages" or die $!;
#Load the syslog messages in an array
while(my $line=<FILE>) {
	push(@messages,$line);
	$len = length($messages[$i]);
        $len-=1;
        $messages[$i] = substr $messages[$i], 0, $len; 
        #Remove the \n from the end of the syslog messages
        $i+=1;
}
close(FILE);

my $patterns_size = scalar @patterns;	#Get the no.of keywords in first array
my $messages_size = scalar @messages;	#Get the no.of lines in second array

for($i=0;$i<$patterns_size;$i+=1) {
	for(my $j=0;$j<$messages_size;$j+=1) {						
	#Search each keyword in all the messages
		if($messages[$j] =~ m/$patterns[$i]/) {					
	#To search the keyword in the message, just use plain matching regex		
		open FILE,">>","output-inter.txt" or die $!;	
		my ( $timeStamp, $log ) = unpack 'A15 A*', $messages[$j];
		$log =~ s/^\s+//;
		my @values = split(' ',$log);
		my $vlen = scalar @values;
		my $hostname = $values[0];
		my $facility = $values[1];
		my $data ="";
		for(my $k=2;$k<$vlen;$k+=1) {
#Rewrite the matched syslog message in the desired format using the attributes
			$data = join(' ',$data,$values[$k]);			

			}
		print FILE  "**$patterns[$i]** $hostname $timeStamp $data $facility\n";	
		#Output the formatted messages to a file
			close(FILE);
		}
	}
}	


