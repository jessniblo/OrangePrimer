#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=4

seq_name=$1
sequence=$2

srun python src/simple_multiple_IDR.py $seq_name $sequence

