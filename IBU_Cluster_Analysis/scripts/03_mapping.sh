#!/bin/bash

#SBATCH --time=48:00:00
#SBATCH --mem=20G
#SBATCH --output=Mapping_%J.out
#SBATCH --error=Mapping_%J.error
#SBATCH --job-name=Mapping
#SBATCH --cpus-per-task=16
#SBATCH --mail-user=federico.silvagutierrez@students.unibe.ch
#SBATCH --mail-type=ALL

# Load modules
module add UHTS/Aligner/hisat/2.2.1
module add UHTS/Analysis/samtools/1.10

 #--------------------------------------------------------------------
 # Federico Silva Gutierrez| 09.11.2023
 #--------------------------------------------------------------------

# Set the number of threads
THREADS=$SLURM_CPUS_PER_TASK
MEMORY=$SLURM_MEM


## --------------------------------------------------------------------
## B | Mapping - Hisat
## --------------------------------------------------------------------


## Setting the variables
## --------------------------------------------------------------------

# Set the index basename
INDEX_BASENAME=mus_genome_index
#INDEX_BASENAME=/data/users/fsilvagutierrez/Cluster_1/IBU_Cluster_Analysis/scripts/Mus_Index

# Define the folder where your sample files are located
SAMPLE_FOLDER=/data/users/fsilvagutierrez/Cluster_1/IBU_Cluster_Analysis/reads 

# Define the folder for output
OUTPUT_FOLDER=/data/users/fsilvagutierrez/Cluster_1/IBU_Cluster_Analysis/03_mapping 

# List all files in the sample folder
SAMPLE_FILES=($SAMPLE_FOLDER/*_1.fastq.gz)

# Define the reference sequence
REFERENCE_SEQUENCE_FASTA=/data/users/fsilvagutierrez/Cluster_1/IBU_Cluster_Analysis/Reference/*.fa


## Execution of the code
## --------------------------------------------------------------------

# Add the index basename
hisat2-build $REFERENCE_SEQUENCE_FASTA $INDEX_BASENAME

# Loope over the sample files
for PAIR1_FILE in ${SAMPLE_FILES[@]} ;  do
	# Extract the sample name from the pair1 file
	SAMPLE=$(basename $PAIR1_FILE _1.fastq.gz)

	# Extract the paths to mate 1 and mate 2 files
	PAIR2_FILE=$SAMPLE_FOLDER/${SAMPLE}_2.fastq.gz
	
	# Define the output SAM file
	OUTPUT_SAM=$OUTPUT_FOLDER/${SAMPLE}_mappedReads.sam

	# Define the output BAM file
	OUTPUT_BAM=$OUTPUT_FOLDER/${SAMPLE}_mappedReads.bam

	
	# Run HISAT2
	hisat2 -x $INDEX_BASENAME -1 $PAIR1_FILE -2 $PAIR2_FILE -S $OUTPUT_SAM -p ${THREADS} --rna-strandness RF

	# Convert SAM to BAM
	samtools view -hbS $OUTPUT_SAM > $OUTPUT_BAM

	# Sort the BAM file
	samtools sort -@ $THREADS -o ${OUTPUT_BAM%.bam}_sorted.bam -T $SCRATCH $OUTPUT_BAM

	# Index the sorted BAM file
	samtools index ${OUTPUT_BAM%.bam}_sorted.bam

	# Remove intermediate SAM file if needed
    rm $OUTPUT_SAM

    # Print a message indicating completion for this sample
    echo "Alignment for $SAMPLE completed. BAM file created."

done
