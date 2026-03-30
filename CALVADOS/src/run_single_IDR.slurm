#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --output=logs/single_IDR.log
#SBATCH --error=logs/single_IDR.err



srun python simple_single_IDR.py

