#!/bin/bash

#SBATCH --time=48:00:00
#SBATCH --mem=20G
#SBATCH --output=Count_%J.out
#SBATCH --error=Count_%J.error
#SBATCH --job-name=Counting
#SBATCH --cpus-per-task=16
#SBATCH --mail-user=federico.silvagutierrez@students.unibe.ch
#SBATCH --mail-type=begin,end

#load modules

module add UHTS/Analysis/subread/2.0.1

 #--------------------------------------------------------------------
 #Federico Silva Gutierrez| 14.11.2023
 #--------------------------------------------------------------------


## --------------------------------------------------------------------
## C | Counts
## --------------------------------------------------------------------


## Setting the variables
## --------------------------------------------------------------------


#Define the folder where your annotation file is located
ANNOTATION_FOLDER=/data/users/fsilvagutierrez/RNA_seq_Toxop_project/Reference 

#Define the folder for output
OUTPUT_FOLDER=/data/users/fsilvagutierrez/RNA_seq_Toxop_project/04_counts 

# Annotation files in the annotation folder
ANNOTATION_FILE=($ANNOTATION_FOLDER/*.gtf)

#Define the bam files
#BAM_FILES=/data/users/fsilvagutierrez/RNA_seq_Toxop_project/03_mapping/*mappedReads.bam
BAM_FILES=/data/users/fsilvagutierrez/RNA_seq_Toxop_project/03_mapping/*mappedReads_sorted.bam



## Execution of the code
## --------------------------------------------------------------------


# Generate the count file

featureCounts -s 2 -p -a $ANNOTATION_FILE -o $OUTPUT_FOLDER/counts_table_toxop.txt $BAM_FILES


echo "count_table generated."

