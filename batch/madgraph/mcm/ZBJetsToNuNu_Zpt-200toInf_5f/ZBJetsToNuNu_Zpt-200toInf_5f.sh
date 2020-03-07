#!/bin/bash
export SCRAM_ARCH=slc6_amd64_gcc630
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_9_3_9_patch1/src ] ; then 
 echo release CMSSW_9_3_9_patch1 already exists
else
scram p CMSSW CMSSW_9_3_9_patch1
fi
cd CMSSW_9_3_9_patch1/src
eval `scram runtime -sh`

curl -s --insecure https://cms-pdmv.cern.ch/mcm/public/restapi/requests/get_fragment/HIG-RunIIFall17wmLHEGS-01908 --retry 2 --create-dirs -o Configuration/GenProduction/python/HIG-RunIIFall17wmLHEGS-01908-fragment.py 
[ -s Configuration/GenProduction/python/HIG-RunIIFall17wmLHEGS-01908-fragment.py ] || exit $?;

scram b
cd ../../
seed=$(date +%s)
cmsDriver.py Configuration/GenProduction/python/HIG-RunIIFall17wmLHEGS-01908-fragment.py --fileout file:ZBJetsToNuNu_Zpt-200toInf_5f_1111111.root --mc --eventcontent RAWSIM,LHE --datatier GEN-SIM,LHE --conditions 93X_mc2017_realistic_v3 --beamspot Realistic25ns13TeVEarly2017Collision --step LHE,GEN,SIM --geometry DB:Extended --era Run2_2017 --python_filename cmsRun_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring --customise_commands process.RandomNumberGeneratorService.externalLHEProducer.initialSeed=1111111 -n 100 || exit $? ; 

cmsRun cmsRun_cfg.py