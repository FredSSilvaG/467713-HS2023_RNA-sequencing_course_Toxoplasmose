#!/bin/bash

#SBATCH --time=48:00:00
#SBATCH --mem=1000M
#SBATCH --output=QC.out
#SBATCH --error=QC.error
#SBATCH --job-name=QC
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL

#load modules
module add UHTS/Quality_control/fastqc/0.11.7

## --------------------------------------------------------------------
## A | Quality Control - FastQC
## --------------------------------------------------------------------


#quality control
fastqc -t 4  -q /data/users/fsilvagutierrez/RNA_seq_Toxop_project/reads/reads/* -o /data/users/fsilvagutierrez/RNA_seq_Toxop_project/02_QC

#remove no longer needed files
rm /data/users/fsilvagutierrez/RNA_seq_Toxop_project/02_QC/*.zip

#running time notification
echo 'A - Quality Control done'


