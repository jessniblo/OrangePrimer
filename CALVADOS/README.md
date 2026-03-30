to run a single IDR: 

1) modify simple_single_IDR.py with sequence info
	1A) change sequence name on line 15
	1B) change sequence on line 16
	1C) can change temperature/salt concentration/pH on lines 17-19 
2) submit with sbatch run_single_IDR.slurm 
	***this runs on 4cpus and a 16 residue sequence takes about 7 minutes 


to run multiple IDRs:

1)create a csv named "sequences_to_sub.csv" with the format name,sequence 
2) run ./submit_all_seq.sh 
	**this will submit each sequence as an idependent job 
