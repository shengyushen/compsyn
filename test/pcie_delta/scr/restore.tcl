
# NC-Sim Command File
# TOOL:	ncsim	05.50-p004
#
#
# You can restore this configuration with:
#
# ncverilog ../src/verilog/filelist_sim.v +incdir+../src/verilog/ +access+rwc +tcl+../scr/restore.tcl +gui +tcl+restore.tcl
#
set tcl_prompt1 {puts -nonewline "ncsim> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 0
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
alias . run
alias quit exit

simvision -input ../scr/restore.tcl.sv
