#!/bin/bash

set -e

CARDDIR=${PWD}/process
TMPDir=$PWD

echo "PWD:"
eval cd ${TMPDir}
#pwd
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh
#RANDOMSEED=`od -vAn -N4 -tu4 < /dev/urandom`

if [[ -z "${CMSSW_BASE}" ]]; then
    echo "CMSSW_BASE is missing".
    exit 0
else
    echo "Copying working folder"
    scp -r ${CARDDIR} ${TMPDir}/batch_job_YYYYYY_XXXX
fi

eval cd ${TMPDir}/batch_job_YYYYYY_XXXX
scp ${CARDDIR}/Run.dat_YYYYYY .
scp ${CMSSW_BASE}/src/GeneratorInterface/SherpaInterface/data/MakeSherpaLibs.sh .
#scp ${CMSSW_BASE}/src/GeneratorInterface/SherpaInterface/data/PrepareSherpaLibs.sh .
chmod +x MakeSherpaLibs.sh

echo "environment:"
echo
env > local.env
env
echo "Running"
echo "./MakeSherpaLibs.sh -p YYYYYY -o LBCR -v -m mpirun -M '-n 15'"
./MakeSherpaLibs.sh -p YYYYYY -o LBCR -v -m mpirun -M '-n 15'
echo "END"
exit $?
echo ""
