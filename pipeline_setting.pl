#!/usr/bin/perl -w
use strict;
use Getopt::Long;


my ($x,$ref,@trans,$help,$refblast,$project,$gff,$script);

GetOptions ('ref=s{1}'      => \$ref,
	    'trans=s'       => \@trans,
	    'blast=s{1}' => \$refblast,
	    'project=s{1}'  => \$project,
	    'gff=s{1}'      => \$gff,
	    'script=s'        => \$script)	    
    or die("Error in command line arguments\n");


### Catching errors in parameters - BEGIN ###

if (! -e $ref){
    print "ERROR: The file $ref does not exist.\n";
    print_error();
}

if (! -e $gff){
    print "ERROR: The file $gff does not exist.\n";
    print_error();
}
@trans = split(/,/, join(",",@trans));
foreach my $i (@trans){
    print "I $i\n";
    if (! -e $i){
	print "ERROR: The file $i does not exist.\n";
	print_error();
    }
}

if (defined( $refblast)){
    if (! -e $refblast){
	print "ERROR: The file $refblast does not exist.\n";
	print_error();
    }
}

if (-d $project){
    print "ERROR: The project directory $project already exists. Please choose another name for your project.\n";
    print_error();
}

if (! -d $script){
    print "ERROR: The directory $script does not exist.\n";
    print_error();
}
### Catching errors - END ###


### Default blastp parameters ###
my $blastparam = "-max_target_seqs 2 -outfmt 6 -num_threads 8";


### Create project directory and move files ###
$x = "mkdir $project"; system($x);
my ($suf_ref) = $ref =~ /([^\/]+)$/;
$x = "cp $ref $project"; system($x); $ref = $suf_ref;
my @suf_trans;
foreach my $i (@trans){
    ($x)  = $i =~ /([^\/]+)$/;
    push(@suf_trans,$x);
    $x = "cp $i $project"; system($x);
}
if (defined($refblast)){
    my ($suf_blast) = $refblast =~ /([^\/]+)$/;
    $x = "cp $refblast $project/ref_vs_ref.blastp.out"; system($x); $refblast = $suf_blast;
}
my ($suf_gff) = $gff =~ /([^\/]+)$/;
$x = "cp $gff $project"; system($x); $gff = $suf_gff;


### Building the CONFIG file ###
open(CONF, " > $project/pipeline.conf");
print CONF "#This is the reference protein fasta file. This file must come from Phytozome (preferably).\n";
print CONF "REF = \"$ref\"\n\n";
print CONF "#One (or more) transcriptome fasta file you want to work with.\n";
$x = "TRANSCRIPT_";
for my $i (0..$#suf_trans){
    my $y = $x.$i;
    print CONF "$y = \"$suf_trans[$i]\"\n";
}
my $numtrans = $#suf_trans+1;
print CONF "NUMTRANS = $numtrans\n";
print CONF "\n#This is the GFF3 file of the reference proteome. This file must come from Phytozome (or must have been converted to a Phytozome-likely GFF3).\nGFF = \"$gff\"\n\n";
if (defined($refblast)){
    print CONF "#This is the \"ref versus ref\" blastp tabular output\n";
    print CONF "REFBLAST = \"$refblast\"\nFLAGBLAST = 0\n\n";
}
else {
    print CONF "#These are the parameters for running the \"ref versus ref\" blastp search. You can modify the num_threads parameter if you can run blastp on more than one CPU (default: 1).\n";
    print CONF "BLASTPARAM = \"$blastparam\"\nFLAGBLAST = 1\n\n";
}
close(CONF);

#symlink Snakefile in the project directory
$x = "ln -s ../Snakefile $project"; system($x);
#$x = "ln -s ../run_snakefile.sh $project"; system($x);

exit(0);

    





### Functions ###

sub print_error {
    print "\n This script must be run before the pipeline (snakemake). The arguments are as followed\n\n";
    print " --ref file\t\t The reference protein FASTA file [COMPULSORY]\n --trans file1 file2\t One or more transcriptome(s) nucleotide fasta file(s) [COMPULSORY]\n --project name\t\t A name for your project [COMPULSORY]\n --gff file\t\t The GFF3 file of your reference genome (from Phytozome) [COMPULSORY]\n --script folder\t The folder that contains all the secondary scripts [COMPULSORY]\n --refblast file\t A \"ref versus ref\" blastp tabular output\n\n";
    print "Ex. : ./pipeline_setting.pl --project My_Project --ref my_reference.protein.fasta --trans my_new_transcriptome.fasta my_other_new_transcriptome.fasta --gff my_ref_proteome.gff --script my_script_folder\n\n";
    exit(0);
}
