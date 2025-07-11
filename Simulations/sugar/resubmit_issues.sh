#!/bin/bash

module load gromacs

conc=0.15
issue_file="issues.txt"

while read -r trial name; do

	trial=$(echo "$trial" | tr -d "'")
	name=$(echo "$name" | tr -d "'")
	
	echo "$name $trial"
	base=$name
    	mkdir -p "$base"
        mkdir -p "$base/trial$trial"
	
	dir_path="$base/trial$trial"
	file="sequences/$base.fasta"

        cp "$file" "$base/trial$trial/$base.fasta"

        cp Martini3-IDP_Poplyply.ff SystemPrep.sh minimization.mdp relax_nvt.mdp relax_npt.mdp equil.mdp run.mdp $dir_path
        cp min_vac.mdp calcRE.py $dir_path
        cp MS_multEquil.slurm $dir_path

        cd $dir_path

        sbatch MS_multEquil.slurm $base $conc


        cd ../../


done < "$issue_file"



