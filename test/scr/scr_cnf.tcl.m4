read_verilog -container r -libname WORK -01 { SRCFILE }  
read_db { /CAD/synopsys/libraries/syn/lsi_10k.db } 
set_top r:/WORK/TOPMOD

read_verilog -container i -libname WORK -01 { CONTAINER/dumpout/inst1_\
TOPMOD.v }  
set_top i:/WORK/TOPMOD  

match
verify

exit
