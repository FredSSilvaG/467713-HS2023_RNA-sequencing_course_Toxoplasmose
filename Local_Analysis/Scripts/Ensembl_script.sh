#!/bin/bash

#SBATCH --time=48:00:00
#SBATCH --mem=20G
#SBATCH --output=Count.out
#SBATCH --error=Count.error
#SBATCH --job-name=Ensembl_id
#SBATCH --cpus-per-task=16
#SBATCH --mail-user=federico.silvagutierrez@students.unibe.ch
#SBATCH --mail-type=begin,end

#load modules

 #--------------------------------------------------------------------
 #Federico Silva Gutierrez| 29.01.2024
 #--------------------------------------------------------------------


## --------------------------------------------------------------------
## C | Ensembl_ids
## --------------------------------------------------------------------


## Setting the variables
## --------------------------------------------------------------------

# List of Ensembl IDs
input_file=/data/users/fsilvagutierrez/RNA_seq_Toxop_project/05_ensembl/ensembl_ids_Blood.txt

# Output file for storing gene information
output_file=/data/users/fsilvagutierrez/RNA_seq_Toxop_project/05_ensembl/gene_info_Blood.txt

# Create an empty output file
 touch "$output_file"

# Function to get gene name from Ensembl webpage
get_gene_name() {
  gene_id=$1
  url="https://www.ensembl.org/Mus_musculus/Gene/Summary?db=core;g=${gene_id}"

  # Use curl to fetch the HTML content
  html_content=$(curl -Ls "$url")

  # Extract the gene name using grep
  gene_name=$(echo "$html_content" | awk -F 'Gene: ' 'NF > 1{print $2; exit}' | awk '{print $1}')

  # Check if gene_name is not empty
  if [ -n "$gene_name" ]; then
    echo "ID: $gene_id Gene: $gene_name" >> "$output_file"
  else
    echo "ID: $gene_id No information found" >> "$output_file"
  fi
}

# Loop through the list of gene IDs and get gene information
while IFS= read -r gene_id; do
  get_gene_name "$gene_id"
done < "$input_file"

echo "Gene information saved to $output_file"