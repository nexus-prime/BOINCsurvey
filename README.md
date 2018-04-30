# BOINCsurvey
Get a breakdown of what hardware is being actively used for BOINC projects

    bash UpdateDatabaseFiles.sh cpu
    bash HWsurvey.sh

__________________________________________________________________________________________________________________
**bash UpdateDatabaseFiles.sh [Project Type] [debug]**
    
    [Project Type]	:	Choose which project types to get data for (cpu/gpu/all)
    [debug]		:	Can specify debug to enable progress bars
    
UpdateDatabaseFiles.sh downloads host and team data from the various BOINC projects on the Gridcoin whitlist
and saves the needed data to the local computer. 
___________________________________________________________________________________________________________________
**bash HWsurvey.sh**

HWsurvey.sh generates tables of how frequently different models of CPUs and GPUs occur in the BOINC project host
files. Hosts with less than 25 RAC are skipped to remove hosts that no longer participate. Results are output to
the directory in several files.

BOINCversion_Survey.data
VBOXversion_Survey.data

GPU_Survey.data
NVIDIAmodel.data
AMDmodel.data
intelGPUmodel.data

CPU_Survey.data

