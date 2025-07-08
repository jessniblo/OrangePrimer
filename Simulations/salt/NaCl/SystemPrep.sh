#!/bin/bash

eval "$(${HOME}/miniforge/bin/conda shell.bash hook)"
conda init
conda activate SolvSens


module load autotools
module load prun
module load gnu12
module load hwloc
module load ucx
module load libfabric
module load ohpc

which insane
which conda 
export LANG=C
export LC_ALL=C

protein=$1
conc=$2
gmx_mpi="/home/jkniblo/software/gromacs-2021.5/build/bin/gmx" 

forcefield_dir=/home/jkniblo/SolutionSensitivity_martini3-idp/martini_v300/

polyply gen_params -seqf "$protein".fasta -f  Martini3-IDP_Poplyply.ff -name Protein -o PRO.itp
echo "Done gen_params"


touch PRO_topol.top
cat <<EOF > PRO_topol.top
#include "$forcefield_dir/martini_v3.0.0.itp"
#include "PRO.itp"
#include "$forcefield_dir/martini_v3.0.0_ions_v1.itp"
#include "$forcefield_dir/martini_v3.0.0_solvents_v1.itp"

[ system ]
Title of the system

[ molecules ]
Protein    1

EOF


boxL=$(python calcRE.py 65)

polyply gen_coords -p PRO_topol.top -o IDR.gro -name IDR -box $boxL $boxL $boxL



#gmx_mpi editconf -f IDR.gro -o PRO_CG.gro -bt cubic -box $boxL $boxL $boxL <<EOF
#1
#EOF


#echo Protein | gmx genrestr -f IDR.gro -o posre.itp -fc 1000 1000 1000


$gmx_mpi grompp -p PRO_topol.top -f min_vac.mdp -c IDR.gro -o minimization-vac.tpr -maxwarn 1
$gmx_mpi mdrun -deffnm minimization-vac -ntomp 2 -v

group=1
echo -e "$group\n$group" | gmx trjconv -f minimization-vac.gro -s minimization-vac.tpr -pbc mol -center -o centered.gro


touch PRO_topol_SOL_IONS.top

insane -f centered.gro -o PRO_SOL_IONS.gro -pbc keep -salt $conc -sol W -center -p PRO_topol_SOL_IONS.top


#Remove #include include martini.itp and substitute ion names in topology file

perl -pi -e's/#include "martini.itp"//g' PRO_topol_SOL_IONS.top
perl -pi -e's/NA\+/NA/g' PRO_topol_SOL_IONS.top
perl -pi -e's/CL-/CL/g' PRO_topol_SOL_IONS.top


#Rename molecule_0.itp to PRO.itp and rename "molecule_0" as "Protein" in PRO.itp file
#mv molecule_0.itp PRO.itp
#perl -pi -e's/molecule_0/Protein/g' PRO.itp

cat <<EOF >> PRO_topol_SOL_IONS.top
#ifdef POSRES
#include "posre.itp"
#endif
EOF


#Add "#include .itp" lines to PRO_topol_SOL_IONS.top
touch others.top #create empty topology file
cat <<EOF > others.top
#include "$forcefield_dir/martini_v3.0.0.itp"
#include "PRO.itp"
#include "$forcefield_dir/martini_v3.0.0_ions_v1.itp"
#include "$forcefield_dir/martini_v3.0.0_solvents_v1.itp"
EOF

##combine modified martini with Pro_topol_SOL_IONS.top 
cat others.top PRO_topol_SOL_IONS.top >a
mv a PRO_topol_SOL_IONS.top

