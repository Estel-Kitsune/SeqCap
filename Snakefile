include: "pipeline.conf"

rule all:
     input: "trans_vs_ref.blastx.out"

#If the "ref versus ref" blastp search has not been done, we do it now
if FLAGBLAST == 1:
   rule ref_vs_ref_blastp:
   	input: REF
	output: "ref_vs_ref.blastp.out"
	shell: "makeblastdb -in {input} -dbtype prot ; blastp -query {input} -db {input} {BLASTPARAM} -out {output}"



#If there are 2 "new transcriptomes", we "blastn" one against the other and keep the genes from one that have hits in the other
if NUMTRANS == 2:
   rule new_vs_new_blastn:
   	input: new0 = TRANSCRIPT_0, new1 = TRANSCRIPT_1
	output: blast = "new_vs_new.blastn.out", list = "list_new.txt"
	shell: "makeblastdb -in {input.new0} -dbtype nucl ; blastn -query {input.new1} -db {input.new0} {BLASTPARAM} -evalue 1e-10 -out {output.blast} ; cut -f 1 {output.blast} | sort | uniq > {output.list}"

if NUMTRANS == 2:
   rule extract_nuseq:
   	input: list = "list_new.txt" , db = TRANSCRIPT_1
	output: "selected_new.fa"
	shell: "perl ../scripts/extract_fasta_from_list.pl --ref {input.db} --list {input.list} --out {output}"



rule get_low_copy:
	input: "ref_vs_ref.blastp.out"
	output: "list_from_get_low_copy"
	shell: "python ../scripts/get_low_copy.py {input} 0.0001 > {output}"



rule parse_gff:
	input: GFF
	output: "list_from_parseGFF"
	shell: "python ../scripts/parsGff3.py --gff3 {GFF} > {output}"



rule extract_seq:
	input: low = "list_from_get_low_copy", gff = "list_from_parseGFF", ref = REF
	output: "selected_ref_sequences.protein.fa"
	shell: "perl ../scripts/extract_fasta_from_list.pl --ref {input.ref} --list {input.low},{input.gff} --out {output}"


if NUMTRANS == 1:
   rule blastx:   
   	  input: prot = "selected_ref_sequences.protein.fa", nu = TRANSCRIPT_0
     	  output: "trans_vs_ref.blastx.out"
     	  shell: "makeblastdb -in {input.prot} -dbtype prot ; blastx -query {input.nu} -db {input.prot} -max_target_seqs 2 -outfmt 6 -num_threads 8 -out {output}"	

if NUMTRANS == 2:
   rule blastx_2:   
   	  input: prot = "selected_ref_sequences.protein.fa", nu = "selected_new.fa"
     	  output: "trans_vs_ref.blastx.out"
     	  shell: "makeblastdb -in {input.prot} -dbtype prot ; blastx -query {input.nu} -db {input.prot} -max_target_seqs 2 -outfmt 6 -num_threads 8 -out {output}"	