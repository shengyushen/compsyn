read_verilog -container r -libname WORK -01 { /home/ssy/ocaml_prog/test/codec810/xfi/XFIPCS_64B66B_ENC.v /home/ssy/ocaml_prog/test/codec810/xfi/XFIPCS_ASYNC_DRS.v }  
set_top r:/WORK/XFIPCS_64B66B_ENC  

read_verilog -container i -libname WORK -01 { /home/ssy/ocaml_prog/test/codec810/xfi/XFIPCS_64B66B_ENC_nomod_inst.v }  
set_top i:/WORK/XFIPCS_64B66B_ENC  

match  
verify  

exit
