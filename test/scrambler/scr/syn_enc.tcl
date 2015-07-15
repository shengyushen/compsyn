######################################
# following two variables are the only 
# two that need to be modified by user
######################################
# where to find include files and synthesis lib
set my_lib_path "  \
			~/compsyn/lib \
      /home/syshen/compsyn_ips/xgxs/src/XGXSPCS \
"
set filelist "../src/scrambler.v"
set top_design scrambler


######################################
# following variables should
# not be edited by user
######################################
set synthetic_library {ssy.db} 
set target_library [list ssy.db        ]

set link_library " *	  \
		   ssy.db \
		   "
#set symbol_library [list ssy.sdb ]


set search_path "\
		$search_path  \
		$my_lib_path "
set wastefile "wastefile"

set verilogout_no_tri true
set verilogout_equation false
set verilogout_single_bit false
set verilogout_show_unconnected_pins true
set gen_show_created_symbols true
set view_log_file  "view_log.log"
set view_command_log_file  "view_command.log"
set exit_delete_filename_log_file false
set view_report_output2file true
set sh_enable_line_editing true
set trans_dc_max_depth 1  
set hdlin_seqmap_sync_search_depth 1 
set compile_seqmap_enable_output_inversion false
define_design_lib WORK -path WORK

analyze \
	-library WORK \
	-f verilog  \
	${filelist}
elaborate ${top_design}
current_design ${top_design}
link
uniquify
ungroup -all -flatten -simple_names
replace_synthetic -ungroup

current_design ${top_design}
set_ideal_network [get_ports CLK]
set maxD 8
create_clock -name CLK -period ${maxD} -waveform [list 0.0 [expr ${maxD}/2.0]] [ get_ports CLK]
set_max_delay ${maxD} -from [all_inputs] -to [all_outputs]

current_design ${top_design}
set_max_transition 0.2 [all_designs]
set_max_fanout 10 [all_designs]
set_max_area 0

current_design ${top_design}
#set_dont_use ssy/*
#remove_attribute [list ssy/AN2] dont_use
#remove_attribute [list ssy/OR2] dont_use
#remove_attribute [list ssy/IV] dont_use
#remove_attribute [list ssy/FD1] dont_use

current_design ${top_design}
compile_ultra

#source ../scr/gen_scr.tcl
change_names -hier -rules verilog
write -f verilog -o dc_synres.v 

report_timing -transition_time -net -cap -nospl -max_paths 100 -from [all_registers -clock_pins] -to [all_registers -data_pins] 
report_timing -transition_time -net -cap -nospl -max_paths 100 -from [all_inputs               ] -to [all_registers -data_pins] 
report_timing -transition_time -net -cap -nospl -max_paths 100 -from [all_registers -clock_pins] -to [all_outputs             ] 
report_timing -transition_time -net -cap -nospl -max_paths 100 -from [all_inputs               ] -to [all_outputs             ] 

report_area
quit

