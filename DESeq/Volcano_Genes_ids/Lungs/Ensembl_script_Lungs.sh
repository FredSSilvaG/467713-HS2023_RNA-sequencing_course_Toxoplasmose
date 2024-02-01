#!/bin/bash

# List of Ensembl IDs
input_file="Lung_Highlighted_gene_ids.txt"

# Output file for storing gene information
output_file="gene_info_Lungs.txt"

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