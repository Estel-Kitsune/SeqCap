#!/usr/bin/perl -w
use strict;
use Getopt::Long;


my ($ref,@list,$help,$out);

GetOptions ('ref=s'     => \$ref,
	    'list=s{1,2}' => \@list,
	    'out=s'     => \$out)	    
or die("Error in command line arguments\n");

if ((! -e $ref) || (!(defined($out)))){
    print_error();
}

#Get the gene names that are present in the list(s) (intersection) and put them in the @keep array
my (%gene,$x,%seq,@keep);
foreach my $list (@list){
    if (! -e $list){
	print_error();
    }
    open(LI, " < $list");
    while(<LI>){
	chomp;
	$gene{$_}++;
    }
    close(LI);
}

foreach my $k(keys(%gene)){
    if ($gene{$k} == $#list+1){
	push(@keep,$k);
    }
}

#Get the sequences of the selected genes and print them in the $out output file
open(REF, " < $ref");
while(<REF>){
    chomp;
    if ($_ =~ /^>(\S+)/){
	$x = $1;
    }
    else {
	$seq{$x}.=$_;
    }
}
close(REF);

open(OUT, " > $out");
foreach my $i (@keep){
    print OUT ">$i\n$seq{$i}\n";
}




sub print_error {
    print "\n This script takes a fasta file containing the reference proteome,and 2 lists of gene names obtained previously,\n and returns a fasta file containing only the protein sequences of the genes present in those 2 lists.\n\n";
    print " --ref file\t\t The protein FASTA file\n --list list1,list2\t The 2 lists, separated by a comma\n --out file\t\tThe output file containing the sequences\n\n";
    exit(0);
}

exit(0)    






