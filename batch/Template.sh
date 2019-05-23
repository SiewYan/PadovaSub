#!/bin/bash

PWD=`pwd`
WorkingDir=${PWD}/../YYYYYY
TMPDir=/lustre/cmswork/hoh/tmp/

echo "PWD:"
eval cd ${TMPDir}
#pwd
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh
#RANDOMSEED=`od -vAn -N4 -tu4 < /dev/urandom`
scp -r ${WorkingDir} ${TMPDir}/batch_YYYYYY_XXXX

eval cd ${TMPDir}/batch_YYYYYY_XXXX

echo "environment:"
echo
env > local.env
env

sed -i 's/1111111/XXXX/g' YYYYYY.sh
echo "running"

./YYYYYY.sh

mv YYYYYY_XXXX.root ${WorkingDir}/sherpa_YYYYYY_XXXX_GEN_SIM.root
echo "Cleaning up"
#rm -rf ${TMPDir}/batch_YYYYYY_XXXX
exit $?
echo ""
