#!/bin/bash
# Batschscript to run a serial job
#SBATCH --account=guest
#SBATCH --partition=guest-compute
#SBATCH --qos=low
#SBATCH --time=23:59:00
#SBATCH --job-name=MyResults
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=lenaburdick@brandeis.edu
#SBATCH --output=output_%A_%a.txt
#SBATCH --ntasks=1

module load share_modules/MATLAB/R2017a


setenv MATLABPATH /home/lenaburdick/Sep10Runs/OneSided10

matlab -nodesktop -nojvm -r “OneSided10;exit"
