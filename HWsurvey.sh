#! /bin/bash

## >>>>>>>>>>  Start CPU Survey  <<<<<<<<<<

(echo "Running CPU analysis..."
echo "Remove unnecessary data..."
cat ./HostFiles/Ct* | grep -E "(p_model|expavg_credit)" > preprocess.data
cat preprocess.data | grep 'p_model' > preprocessID.data & 
cat preprocess.data | grep 'expavg_credit' | grep -Eon "[0-9]+\.[0-9]+" > preprocessRAC.data &

wait
echo "Parsing CPU data..."

rm -f currentHOST.data
touch -f currentHOST.data


cat preprocessID.data | sed  's/\[[^]]*\]//g'  | sed  '/^$/!{s/<[^>]*>//g;p;}' | sed 's/GHz.*/GHz/g' > preprocessID.temp &
cat preprocessRAC.data | sed  's/:/    /g' | awk '{if ($2>25) print "~"; else print "x"}' | cut -f 1 -d' ' > LineNumbers.data &


wait
rm preprocessID.data
echo "Check for inactive hosts..."

paste LineNumbers.data preprocessID.temp | grep '~' |cut -c 4- > currentHOST.data 

echo "Count CPU models and generate output file"
cat currentHOST.data | sort | uniq --count | sort -rn  > CPU_Survey.data


rm preprocess.data
rm LineNumbers.data
rm currentHOST.data
rm preprocessRAC.data
rm preprocessID.temp)&


## >>>>>>>>>>  Start GPU Survey  <<<<<<<<<<


echo "Running GPU analysis..."
echo "Remove unnecessary data..."
cat ./HostFiles/Ct* | grep  -A 2 "coprocs"  > preprocess2.data
cat preprocess2.data | grep 'coprocs' > preprocessID2.data & 
cat preprocess2.data | grep 'expavg_credit' | grep -Eon "[0-9]+\.[0-9]+" > preprocessRAC2.data &

wait
echo "Parsing GPU data..."

rm -f currentHOST2.data
touch -f currentHOST2.data


cat preprocessID2.data  | sed  's%</coprocs>%%' | sed 's%<coprocs>%%'  > preprocessID2.temp &
cat preprocessRAC2.data | sed  's/:/    /g' | awk '{if ($2>25) print "~"; else print "x"}' | cut -f 1 -d' ' > LineNumbers2.data &


wait
rm preprocessID2.data
echo "Check for inactive hosts..."

paste LineNumbers2.data preprocessID2.temp | grep '~' |cut -c 4- > currentHOST2.data 



echo "Count GPU models and generate output file"
cat currentHOST2.data | sed  's%\]\[CUDA%\]\n\[CUDA%g' | sed  's%\]\[INTEL%\]\n\[INTEL%g' | sed  's%\]\[CAL%\]\n\[CAL%g' \
	| sed  's%\]\[vbox%\]\n\[vbox%g' |  gawk '{sub("MB.*", "");print}' | sed -r 's/[0-9]{1,10}$//'  \
	| sed 's/^[ \t]+//g'| sed 's/^ *//g' | sort | uniq --count | sort -rn  > GPU_Survey.temp

cat GPU_Survey.temp | grep 'BOINC' > BOINCversion_Survey.data
cat GPU_Survey.temp | grep 'vbox' > VBOXversion_Survey.data
cat GPU_Survey.temp | grep -vE "(vbox|BOINC)" > GPU_Survey.data
cat GPU_Survey.data | grep 'CUDA' > NVIDIAmodel.data
cat GPU_Survey.data | grep 'CAL'  > AMDmodel.data
cat GPU_Survey.data | grep 'INTEL' > intelGPUmodel.data

rm preprocess2.data
rm LineNumbers2.data
rm currentHOST2.data
rm preprocessRAC2.data
rm preprocessID2.temp




echo "Survey Calculations Complete"