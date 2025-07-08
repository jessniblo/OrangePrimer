#!/bin/bash

module load gromacs
salt_id=("NaCl")
protein_key="Hist"

for salt in "${salt_id[@]}"
do
	for conc in 0.05 0.15 0.5
	do
		mkdir -p "$salt"_"$conc"
		for tri in  0 2 4
		do
			for file in ../../sequences/*.fasta
			do 

				filename=$(basename "$file")
        		base="${filename%.fasta}"
        		echo $base

				mkdir -p "$salt"_"$conc"/trial"$tri"
				mkdir -p "$salt"_"$conc"/trial"$tri"/"$base"

				dir_path="$salt"_"$conc"/trial"$tri"/"$protein_key"_"$base"

				cp "$file" "$dir_path/$base.fasta"

				cp Martini3-IDP_Poplyply.ff SystemPrep.sh minimization.mdp relax_nvt.mdp relax_npt.mdp equil.mdp run.mdp $dir_path
                cp min_vac.mdp calcRE.py $dir_path
                cp MS_multEquil.slurm $dir_path

                cd $dir_path
				sbatch MS_multEquil.slurm "$base" $conc

                cd ../../../
         		done
    		done 
	done
done


