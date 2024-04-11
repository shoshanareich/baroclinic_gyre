#!/bin/bash

#SBATCH -J skpp
#SBATCH -o skpp.%j.out
#SBATCH -e skpp.%j.err
#SBATCH -N 3
#SBATCH -n 36
#SBATCH -t 00:25:00

#SBATCH --mail-user=sreich@utexas.edu
#SBATCH --mail-type=begin
#SBATCH --mail-type=end

#--- 0.load modules ------
module purge
module load intel/2023.1.0
module load openmpi4/4.1.5
module load phdf5/1.14.0
module load netcdf-fortran/4.6.0
module load netcdf/4.9.0
module load prun

module list

#echo $LD_LIBRARY_PATH

ulimit -s hard
ulimit -u hard

#--- 2.set dir ------------
basedir=/home/shoshi/MITgcm_c68q/baroclinic_gyre
scratchdir=/scratch/shoshi/baroclinic_gyre

workdir=$scratchdir/run_test

mkdir ${workdir}
cd ${workdir}

#--- 6. NAMELISTS ---------
ln -s ${basedir}/input/* .

#--- 7. executable --------
cp -p ${basedir}/build/mitgcmuv .

# mpiexec --mca btl ^tcp,openib --mca mtl psm2 ${workdir}/mitgcmuv
prun ${workdir}/mitgcmuv
