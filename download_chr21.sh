#!/bin/bash
#
#==============================================
#download_chr21.sh
#==============================================
#
#AUTHOR Sophie Goubert
#Version 16 September 2026
#
#Description
#
#1. Create working directory
bash
cd btec640 # Change to btec640 directory
mdir -p btec640/class_exercises # Create class_exercises directory
cd class_exercises # Change to class_exercises directory
mkdir sept14_class # Create sept14_class directory
cd sept14_class # Change to sept14_class directory
mkdir input_data # Create input_data directory
cd input_data # Change to input_data directory
curl -o hg38.ncbiRefSeq.gtf.gz "https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.gtf.gz" # Download chr21 data
less hg38.ncbiRefSeq.gtf.gz # Open file we just downloaded
gunzip hg38.ncbiRefSeq.gtf.gz # Unzip the file
ln -s ../input_data/hg38.ncbiRefSeq.gtf # Do soft link of unzipped file
grep "chr21" hg38.ncbiRefSeq.gtf # Search for chr21 entries
grep -c "chr21" hg38.ncbiRefSeq.gtf # Count number of chr21 entries
grep "NM_" chr21.gtf > refseq_chr21.gtf # Filter for RefSeq transcripts on chr21
awk -F '\t' '{print $9}' refseq_chr21.gtf | head # Find gene name and accession number in column 0
awk -F '\t' '{print $9}' refseq_chr21.gtf | awk -F '"' '{print $2, $4}' | head # Find gene name and accession number in column 9 and seprate it into two fields
awk -F '\t' '{print $9}' refseq_chr21.gtf  | awk -F'"' '!seen[$2]++ {print $2, $4}' refseq_chr21.gtf > gene_accession.txt # Keep only the first occurrence of each gene name and accession number
wc -l gene_accession.txt # Count lines in the gene_accession.txt file
head gene_accession.txt # Display the first 10 lines of the gene_accession.txt file
head -n 10 gene_accession.txt > 10_genes.txt # Create a new file with the first 10 lines of gene_accession.txt
cat 10_genes.txt # Display the contents of 10_genes.txt

while read -r gene accession
do
    curl -o "${gene}.fasta" "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${accession}&rettype=fasta&retmode=text"

done < 10_genes.txt
ls -lh *.fasta # List the downloaded fasta files