#!/bin/bash
sug_id=("sucrose" "galactose" "trehalose")

for sugar in "${sug_id[@]}"
do
	for conc in 0.05 0.15 0.5
	do
		mkdir -p "$sugar"_"$conc"
		for tri in  0 2 4
		do
			for file in ../../../Sequences/*.fasta
			do 

				filename=$(basename "$file")
        		base="${filename%.fasta}"
        		echo $base

				mkdir -p "$sugar"_"$conc"/trial"$tri"
				mkdir -p "$sugar"_"$conc"/trial"$tri"/"$base"

				dir_path="$sugar"_"$conc"/trial"$tri"/"$base"

				cp "$file" "$dir_path/$base.fasta"

				cp Martini3-IDP_Poplyply.ff SystemPrep.sh minimization.mdp relax_nvt.mdp relax_npt.mdp equil.mdp run.mdp $dir_path
                cp min_vac.mdp calcRE.py $dir_path
                cp set_sugnum.py MS_multEquil.slurm $dir_path

				if [ "$sugar" == "sucrose" ]; then
					cp SUC.gro $dir_path/sugar.gro

				elif [ "$sugar" == "galactose" ]; then
					cp GAL.gro $dir_path/sugar.gro 
					
				elif [ "$sugar" == "trehalose" ]; then
					cp TREH.gro $dir_path/sugar.gro  
				fi


                cd $dir_path
				sbatch MS_multEquil.slurm "$base" $conc

                cd ../../../
         		done
    		done 
	done
done


