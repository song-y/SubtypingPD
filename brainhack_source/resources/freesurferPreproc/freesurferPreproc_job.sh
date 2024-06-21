#!/bin/bash
#SBATCH --time=23:59:00
#SBATCH --account=def-hanganua-ab
#SBATCH --mem-per-cpu=10G
#SBATCH --output=slurm/long/%j.out


#sh freesurferPreproc.sh l 2 "$1"
sh freesurferPreproc.sh l 1 sub-004
