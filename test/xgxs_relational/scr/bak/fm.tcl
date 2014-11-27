read_verilog -container r -libname WORK -01 { ssy.v } 
read_db { /CAD/synopsys/libraries/syn/lsi_10k.db } 
set_top r:/WORK/XGXSSYNTH_ENC_8B10B 
read_verilog -container i -libname WORK -vcs "+incdir+..src/XGXSPCS" -01 { ../src/XGXSPCS/XGXSSYNTH_ENC_8B10B.v } 
set_top i:/WORK/XGXSSYNTH_ENC_8B10B 
match 
verify 
quit
