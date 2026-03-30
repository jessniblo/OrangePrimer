#!/bin/bash

CSV="sequences_to_sub.csv"

for line in $(cat $CSV); do
    name=$(echo $line | cut -d',' -f1)
    sequence=$(echo $line | cut -d',' -f2)
    echo "Submitting: $name $sequence"
    sbatch --output=src/logs/${name}.log --error=src/logs/${name}.err src/run_multiple_IDR.slurm $name $sequence
done

