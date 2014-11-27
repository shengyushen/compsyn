######################################
# following two variables are the only 
# two that need to be modified by user
######################################
# where to find include files and synthesis lib
set my_lib_path "  \
      DC_INCPATH \
      ~/compsyn/lib \
"
set filelist "FILELIST"
set top_design TOP_DESIGN


######################################
# following variables should
# not be edited by user
######################################
set synthetic_library {ssy.db} 
set target_library [list ssy.db        ]

set link_library " *	  \
		   ssy.db \
		   "
set symbol_library [list ssy.sdb ]


set search_path "\
		$search_path  \
		$my_lib_path "
set wastefile "wastefile"

set verilogout_no_tri true
set verilogout_single_bit true
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
set_ideal_network [get_ports *]
set_ideal_network [get_ports *]

current_design ${top_design}
remove_attribute [get_designs ${top_design}] max_area
current_design ${top_design}
set_map_only [get_cells *] true
set_max_transition 100000 [all_designs]
set_max_fanout 10000 [all_designs]
set_max_capacitance 10000 [all_designs]

current_design ${top_design}
set_dont_use ssy/*
remove_attribute [list ssy/AN2] dont_use
remove_attribute [list ssy/OR2] dont_use
remove_attribute [list ssy/IV] dont_use
remove_attribute [list ssy/FD1] dont_use

current_design ${top_design}
remove_bus *
set_ultra_optimization false
# for dc 2004
#compile -map_effort low
# for dc 2007 and latter
#compile -map_effort low -no_design_rule -area_effort none
#preventing using QN of FD1
compile_ultra -no_seq_output_inversion 

#source ../scr/gen_scr.tcl

write -f verilog -o dc_synres_dual_blif.v 
#write -f equation -o ssy.equation -no_implicit

quit
