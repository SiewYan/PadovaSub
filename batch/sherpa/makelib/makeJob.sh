#!/bin/bash

## add the script in PATH

work=$1
njobs=$2
queue=$3
dryrun=$4

if [ ! -d "jobs" ];then
    mkdir -p jobs
fi

for job in `seq 1 1 $njobs`
do
    RANDOMSEED=`od -vAn -N4 -tu4 < /dev/urandom`
    RANDOMSEED=`echo $RANDOMSEED | rev | cut -c 3- | rev`
    scp Template.sh jobs/job_${RANDOMSEED}.sh
    ##sub
    sed -i 's/XXXX/'${RANDOMSEED}'/g' jobs/job_${RANDOMSEED}.sh
    sed -i 's/YYYYYY/'${work}'/g' jobs/job_${RANDOMSEED}.sh
    ##
    chmod 755 jobs/job_${RANDOMSEED}.sh
    if [ "$dryrun" -eq 0 ] || [ -z "$dryrun" ];then
	echo "bsub -q $queue -o jobs/job_${RANDOMSEED}_logs < jobs/job_${RANDOMSEED}.sh"
	bsub -q $queue -o jobs/job_${RANDOMSEED}_logs < jobs/job_${RANDOMSEED}.sh
    else
	echo "Dry Run"
	echo "bsub -q $queue -o jobs/job_${RANDOMSEED}_logs < jobs/job_${RANDOMSEED}.sh"
	ls jobs
    fi
done