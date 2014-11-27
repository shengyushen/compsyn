read_verilog -container r -libname WORK -01 { resulting_dual_cnf.v } 
set_top r:/WORK/resulting_dual 
read_verilog -container i -libname WORK -vcs "+incdir+..src/XGXSPCS" -01 { ../resulting_dual_cnf.v} 
set_top i:/WORK/resulting_dual 
match 
verify 

