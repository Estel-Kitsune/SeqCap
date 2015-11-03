# How to run the pipeline

1. Run the script "pipeline_setting.pl". 

If you just type "./pipeline_setting.pl" you will get the following information:

```bash
 This script must be run before the pipeline (snakemake). The arguments are as followed

 --ref <file>		 The reference protein FASTA file [COMPULSORY]
 --trans <file1> <file2>	 One or more transcriptome(s) nucleotide fasta file(s) [COMPULSORY]
 --project <name>		 A name for your project [COMPULSORY]
 --gff <file>		 The GFF3 file of your reference genome (from Phytozome) [COMPULSORY]
 --script <directory>	 The directory that contains all the secondary scripts [COMPULSORY]
 --refblast <file>	 A "ref versus ref" blastp tabular output

Ex. : ./pipeline_setting.pl --project My_Project --ref my_reference.protein.fasta --trans my_new_transcriptome.fasta my_other_new_transcriptome.fasta --gff my_ref_proteome.gff --script my_script_folder
```

2- Go into your project directory (created with the previous script)

3- Type "snakemake"


*** What does the pipeline do? ***

1- Do the "ref proteome versus ref proteome" blastp search (except if it has been done before) -> tabular blastp output file

2- Run the "get_low_copy.py" script on this blastp output file -> list of protein names.

3- Run the "parsGff3.py" script on the reference GFF3 file -> list of protein names.

4- Run the "extract_fasta_from_list.pl" script. It uses the 2 lists of protein names -> fasta file of selected protein sequences

5- If 2 "de novo" transcriptome, blastn search of transcriptome 1 against transcriptome 2 -> list of selected nucleotide sequences from transcriptome 1 (that have good blast hits in the other transcriptome)

6- Blastx search of transcriptome/selected nucleotide sequences against selected reference protein sequences -> blastx tabular output file.

[7- Run parseBLASTtable.py]
