How to run the pipeline?

1- Run the script "pipeline_setting.pl". If you just type 2./pipeline_setting.pl" you will get hel information:

 This script must be run before the pipeline (snakemake). The arguments are as followed

 --ref file		 The reference protein FASTA file [COMPULSORY]
 --trans file1 file2	 One or more transcriptome(s) nucleotide fasta file(s) [COMPULSORY]
 --project name		 A name for yout project [COMPULSORY]
 --gff file		 The GFF3 file of your reference proteome (from Phytozome) [COMPULSORY]
 --script folder	 The folder that contains all the secondary scripts [COMPULSORY]
 --refblast file	 A "ref versus ref" blastp tabular output

Ex. : ./pipeline_setting.pl --project My_Project --ref my_reference.protein.fasta --trans my_new_transcriptome.fasta my_other_new_transcriptome.fasta --gff my_ref_proteome.gff --script my_script_folder

2- Go into your project directory (created with the previous script)

3- Type "snakemake"
