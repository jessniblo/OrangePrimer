#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --output=run.log
#SBATCH --error=run.err
#SBATCH --partition=normal,compute_zone2,longjobs 

eval "$(${HOME}/miniforge/bin/conda shell.bash hook)"
conda init 
conda activate SolvSens

# default modules
module --ignore_cache load autotools
module --ignore_cache load ohpc
module --ignore_cache load gnu12/12.3.0
module --ignore_cache load hwloc
module --ignore_cache load ucx
module --ignore_cache load libfabric
module --ignore_cache load prun/2.2
threads=24
protein=$1
conc=$2
gmx="/home/jkniblo/software/gromacs-2021.5/build/bin/gmx"

cwd=$(pwd)

export JOB_TMPDIR=/tmp/${USER}_${SLURM_JOB_ID}
mkdir -p $JOB_TMPDIR

cp * $JOB_TMPDIR
cd $JOB_TMPDIR

./SystemPrep.sh $protein $conc
wait

$gmx grompp -f minimization.mdp -p PRO_topol_SOL_IONS.top -c PRO_SOL_IONS.gro -o min.tpr -maxwarn 3
wait 

$gmx mdrun -deffnm min -ntmpi 1 -ntomp $threads -v >& run_min.out
wait 

#relaxation -- NVT
$gmx grompp -f relax_nvt.mdp -p PRO_topol_SOL_IONS.top -c min.gro -r min.gro -o relax_nvt.tpr -maxwarn 2 -v >& run_relax_grompp_nvt.out
#wait 
$gmx mdrun -s relax_nvt.tpr -cpi relax_nvt.cpt -deffnm relax_nvt -ntmpi 1 -ntomp $threads -v >& run_relax_nvt.out
#echo "Done nvt relaxation!" >> fyi.txt

# relaxation -- NPT
$gmx grompp -f relax_npt.mdp -p PRO_topol_SOL_IONS.top -c relax_nvt.gro -r relax_nvt.gro -o relax_npt.tpr -maxwarn 2  -v
#wait 
$gmx mdrun -s relax_npt.tpr -cpi relax_npt.cpt -deffnm relax_npt -ntmpi 1 -ntomp $threads -v >& run_relax_npt.out

### Second NPT with accurate ensemble 
$gmx grompp -f equil.mdp -p PRO_topol_SOL_IONS.top -c relax_npt.gro  -o equil.tpr -maxwarn 2  -v
#wait
$gmx mdrun -s equil.tpr -deffnm equil -ntmpi 1 -ntomp $threads -v >& run_equil.out


# Production -- Standard 
$gmx grompp -f run.mdp -p PRO_topol_SOL_IONS.top -c equil.gro -o prodrun.tpr -maxwarn 2  -v
#wait 
$gmx mdrun -s prodrun.tpr -ntmpi 1 -ntomp $threads -v >& run_prod.out
#echo "Done production!" >> fyi.txt
#wait 

echo -e "0\n0" | gmx trjconv -s prodrun.tpr -f traj_comp.xtc -o traj_comp_corrected.xtc -pbc mol -center


echo "Protein" | gmx gyrate -s prodrun.tpr -f traj_comp_corrected.xtc -o rg_gyrate.xvg

#touch Production_Complete.txt

mv /tmp/${USER}_${SLURM_JOB_ID}/* $cwd
