type description =
	T_description__module_declaration of module_declaration
	| T_description__udp_declaration of udp_declaration
	| T_description__config_declaration of config_declaration
and module_declaration =
	T_module_declaration__1 of (attribute_instance list)*string*(parameter_declaration list)*(port list)*(module_item list)
	| T_module_declaration__2 of(attribute_instance list)*string*(parameter_declaration list)*(port_declaration list)*(module_item list)
and port =
	T_port_position of port_expression
	| T_port_exp of string*port_expression
and port_expression =
	T_port_expression of (port_reference list)
and	port_reference =
	T_port_reference of string*constant_range_expression
and port_declaration =
	T_port_declaration__inout_declaration of (attribute_instance list)*inout_declaration
	| T_port_declaration__input_declaration of (attribute_instance list)*input_declaration
	| T_port_declaration__output_declaration of (attribute_instance list)*output_declaration
and module_item =
	T_module_item__port_declaration of port_declaration
	| T_module_item__generate_region of generate_region
	| T_module_item__specify_block of specify_block
	| T_module_item__parameter_declaration of (attribute_instance list)*parameter_declaration
	| T_module_item__specparam_declaration of (attribute_instance list)*specparam_declaration
	| T_module_item__net_declaration of (attribute_instance list)*net_declaration
	| T_module_item__reg_declaration of (attribute_instance list)*reg_declaration
	| T_module_item__integer_declaration of (attribute_instance list)*integer_declaration
	| T_module_item__real_declaration of (attribute_instance list)*real_declaration
	| T_module_item__time_declaration of (attribute_instance list)*time_declaration
	| T_module_item__realtime_declaration of (attribute_instance list)*realtime_declaration
	| T_module_item__event_declaration of (attribute_instance list)*event_declaration
	| T_module_item__genvar_declaration of (attribute_instance list)*genvar_declaration
	| T_module_item__task_declaration of (attribute_instance list)*task_declaration
	| T_module_item__function_declaration of (attribute_instance list)*function_declaration
	| T_module_item__local_parameter_declaration of (attribute_instance list)*local_parameter_declaration
	| T_module_item__parameter_override of (attribute_instance list)*(defparam_assignment list)
	| T_module_item__continuous_assign of (attribute_instance list)*continuous_assign
	| T_module_item__gate_instantiation of (attribute_instance list)*gate_instantiation
	| T_module_item__udp_instantiation of (attribute_instance list)*udp_instantiation
	| T_module_item__module_instantiation of (attribute_instance list)*module_instantiation
	| T_module_item__initial_construct of (attribute_instance list)*initial_construct
	| T_module_item__always_construct of (attribute_instance list)*always_construct
	| T_module_item__loop_generate_construct of (attribute_instance list)*loop_generate_construct
	| T_module_item__conditional_generate_construct of (attribute_instance list)*conditional_generate_construct
and config_declaration =
	T_config_declaration of identifier*design_statement*(config_rule_statement list)
and design_statement =
	T_design_statement of (library_identifier_period_opt_cell_identifier list)
and library_identifier_period_opt_cell_identifier =
	T_lib_cell_identifier of string*string
and config_rule_statement =
	T_config_rule_statement__default of (string list) 
	| T_config_rule_statement__inst_lib of (string list)*(string list)
	| T_config_rule_statement__inst_use of (string list)*use_clause
	| T_config_rule_statement__cell_lib of library_identifier_period_opt_cell_identifier*(string list)
	| T_config_rule_statement__cell_use of library_identifier_period_opt_cell_identifier*use_clause
and use_clause =
	T_use_clause of library_identifier_period_opt_cell_identifier*colon_config_opt
and colon_config_opt =
	T_colon_config_opt_FALSE
	| T_colon_config_opt_TRUE
and signed =
	T_signed_FALSE 
	| T_signed_TRUE
and local_parameter_declaration =
	T_local_parameter_declaration_1 of signed*range*(param_assignment list)
	| T_local_parameter_declaration_2 of parameter_type*(param_assignment list)
and parameter_declaration =
	T_parameter_declaration_1 of signed*range*(param_assignment list)
	| T_parameter_declaration_2 of parameter_type*(param_assignment list)
and specparam_declaration =
	T_specparam_declaration of range*(specparam_assignment list)
and parameter_type =
	T_parameter_type__INTEGER
	| T_parameter_type__REAL
	| T_parameter_type__REALTIME
	| T_parameter_type__TIME
and inout_declaration =
	T_inout_declaration of net_type*signed*range*(string list)
and input_declaration =
	T_input_declaration of net_type*signed*range*(string list)
and output_declaration =
	T_output_declaration_net of net_type*signed*range*(string list)
	|T_output_declaration_reg of signed*range*(port_identifier_equ1_constant_expression_opt list)
	|T_output_declaration_var of output_variable_type*(port_identifier_equ1_constant_expression_opt list)
and	output_variable_type =
	T_output_variable_type_INTEGER
	| T_output_variable_type_TIME
and event_declaration =
	T_event_declaration of (event_identifier_dimension_list list)
and integer_declaration =
	T_integer_declaration of (variable_type list)
and net_declaration =
	T_net_declaration_net_type1 of net_type*signed*delay3*(net_identifier_dimension_list list)
	| T_net_declaration_net_type2 of net_type*drive_strength*signed*delay3*(net_decl_assignment list)
	| T_net_declaration_net_type3 of net_type*vectored_scalared*signed*range*delay3*(net_identifier_dimension_list list)
	| T_net_declaration_net_type4 of net_type*drive_strength*vectored_scalared*signed*range*delay3*(net_decl_assignment list)
	| T_net_declaration_trireg_1 of charge_strength*signed*delay3*(net_identifier_dimension_list list)
	| T_net_declaration_trireg_2 of drive_strength*signed*delay3*(net_decl_assignment list)
	| T_net_declaration_trireg_3 of charge_strength*vectored_scalared*signed*range*delay3
	| T_net_declaration_trireg_4 of drive_strength*vectored_scalared*signed*range*delay3*(net_decl_assignment list)
and vectored_scalared =
	T_vectored_scalared_NOSPEC
	|T_vectored_scalared_vectored
	|T_vectored_scalared_scalared
and real_declaration =
	T_real_declaration of (real_type list)
and realtime_declaration =
	T_realtime_declaration of (real_type list)
and reg_declaration =
	T_reg_declaration of signed*range*(variable_type list)
and time_declaration =
	T_time_declaration of (variable_type list)
and net_type =
	T_net_type_NOSPEC
	| T_net_type__KEY_SUPPLY0
	| T_net_type__KEY_SUPPLY1
	| T_net_type__KEY_TRI
	| T_net_type__KEY_TRIAND
	| T_net_type__KEY_TRIOR
	| T_net_type__KEY_TRI0
	| T_net_type__KEY_TRI1
	| T_net_type__KEY_UWIRE
	| T_net_type__KEY_WIRE
	| T_net_type__KEY_WAND
	| T_net_type__KEY_WOR
and real_type =
	T_real_type_noass of string*(dimension list)
	| T_real_type_ass of string*constant_expression
and	variable_type =
	T_variable_type_noass of string*(dimension list)
	| T_variable_type_ass of string*constant_expression
and strength =
	KEY_HIGHZ0
	| KEY_HIGHZ1
	| KEY_SUPPLY0	
	| KEY_STRONG0	
	| KEY_PULL0		
	| KEY_WEAK0 
	|	KEY_SUPPLY1	
	| KEY_STRONG1	
	| KEY_PULL1		
	| KEY_WEAK1 
and drive_strength =
	T_drive_strength_NOSPEC
	| T_drive_strength of strength*strength
and charge_strength =
	T_charge_strength_NOSPEC
	| T_charge_strength__small
	| T_charge_strength__medium
	| T_charge_strength__large
and delay3 =
	T_delay3_NOSPEC
	| T_delay3_1 of delay_value
	| T_delay3_minmax1 of mintypmax_expression
	| T_delay3_minmax2 of mintypmax_expression*mintypmax_expression
	| T_delay3_minmax3 of mintypmax_expression*mintypmax_expression*mintypmax_expression
and delay2 =
	T_delay2_NOSPEC
	| T_delay2_1 of delay_value
	| T_delay2_minmax1 of mintypmax_expression
	| T_delay2_minmax2 of mintypmax_expression*mintypmax_expression
and event_identifier_dimension_list =
	T_event_identifier_dimension_list of string*(dimension list)
and net_identifier_dimension_list =
	T_net_identifier_dimension_list of string*(dimension list)
and port_identifier_equ1_constant_expression_opt =
	T_port_identifier_equ1_constant_expression_opt of string*constant_expression
and defparam_assignment =
	T_defparam_assignment of hierarchical_identifier*constant_mintypmax_expression
and net_decl_assignment =
	T_net_decl_assignment of string*expression
and param_assignment =
	T_param_assignment of string*constant_mintypmax_expression
and specparam_assignment =
	T_specparam_assignment of string*constant_mintypmax_expression
	| T_specparam_assignment_pulse1 of constant_mintypmax_expression*constant_mintypmax_expression
	| T_specparam_assignment_pulse2 of specify_input_terminal_descriptor*specify_output_terminal_descriptor*constant_mintypmax_expression*constant_mintypmax_expression
and  dimension =
	T_dimension of constant_expression*constant_expression
and range =
	T_range_NOSPEC
	| T_range of constant_expression*constant_expression
and automatic =
	T_automatic_false
	| T_automatic_true
and function_declaration =
	T_function_declaration_1 of automatic*function_range_or_type*string*(function_item_declaration list)*statement
	| T_function_declaration_2 of automatic*function_range_or_type*string*(attribute_instance_list_tf_input_declaration list)*(block_item_declaration list)*statement
and function_item_declaration =
	T_function_item_declaration_block of block_item_declaration
	| T_function_item_declaration_input of (attribute_instance list)*tf_input_declaration
and attribute_instance_list_tf_input_declaration =
	T_attribute_instance_list_tf_input_declaration of (attribute_instance list)*tf_input_declaration
and function_range_or_type =
	T_function_range_or_type_NOSPEC
	| T_function_range_or_type of signed*range
	| T_function_range_or_type_INTEGER
	| T_function_range_or_type_REAL
	| T_function_range_or_type_REALTIME
	| T_function_range_or_type_TIME
and task_declaration =
	T_task_declaration1 of automatic*string*(task_item_declaration list)*statement
	| T_task_declaration2 of automatic*string*(task_port_item list)*(block_item_declaration list)*statement
and task_item_declaration =
	T_task_item_declaration_block of block_item_declaration
	| T_task_item_declaration_input of tf_input_declaration
	| T_task_item_declaration_output of tf_output_declaration
	| T_task_item_declaration_inout of tf_inout_declaration
and task_port_item =
	T_task_port_item_input of tf_input_declaration
	| T_task_port_item_output of tf_output_declaration
	| T_task_port_item_inout of tf_inout_declaration
and reg =
	T_reg_false
	| T_reg_true
and tf_input_declaration =
	T_tf_input_declaration_reg of reg*signed*range*(string list)
	| T_tf_input_declaration_type of task_port_type*(string list)
and tf_output_declaration =
	T_tf_output_declaration_reg of reg*signed*range*(string list)
	| T_tf_output_declaration_type of task_port_type*(string list)
and tf_inout_declaration =
	T_tf_inout_declaration_reg of reg*signed*range*(string list)
	| T_tf_inout_declaration_type of task_port_type*(string list)
and task_port_type =
	T_task_port_type_integer
	| T_task_port_type_real
	| T_task_port_type_realtime
	| T_task_port_type_time
and block_item_declaration =
	T_block_item_declaration_reg of (attribute_instance list)*signed*range*(block_variable_type list)
	| T_block_item_declaration_integer of (attribute_instance list)*(block_variable_type list)
	| T_block_item_declaration_time of (attribute_instance list)*(block_variable_type list)
	| T_block_item_declaration_real of (attribute_instance list)*(block_real_type list)
	| T_block_item_declaration_realtime of (attribute_instance list)*(block_real_type list)
	| T_block_item_declaration_event of (attribute_instance list)*event_declaration
	| T_block_item_declaration_local_param of (attribute_instance list)*local_parameter_declaration
	| T_block_item_declaration_param of (attribute_instance list)*parameter_declaration
and block_variable_type =
	T_block_variable_type of string*(dimension list)
and block_real_type =
	T_block_real_type of string*(dimension list)
and gate_instantiation =
	T_gate_instantiation_cmos of cmos_switchtype*delay3*(cmos_switch_instance list)
	| T_gate_instantiation_enable of enable_gatetype*drive_strength*delay3*(enable_gate_instance list)
	| T_gate_instantiation_mos of mos_switchtype*delay3*(mos_switch_instance list)
	| T_gate_instantiation_input of n_input_gatetype*drive_strength*delay2*(n_input_gate_instance list)
	| T_gate_instantiation_output of n_output_gatetype*drive_strength*delay2*(n_output_gate_instance list)
	| T_gate_instantiation_pass_en of pass_en_switchtype*delay2*(pass_enable_switch_instance list)
	| T_gate_instantiation_pass of pass_switchtype*(pass_switch_instance list)
	| T_gate_instantiation_pulldown of pulldown_strength*(pull_gate_instance list)
	| T_gate_instantiation_pullup of pullup_strength*(pull_gate_instance list)
and cmos_switch_instance =
	T_cmos_switch_instance of name_of_gate_instance*net_lvalue*expression*expression*expression
and enable_gate_instance =
	T_enable_gate_instance of name_of_gate_instance*net_lvalue*expression*expression
and mos_switch_instance =
	T_mos_switch_instance of name_of_gate_instance*net_lvalue*expression*expression
and n_input_gate_instance =
	T_n_input_gate_instance of name_of_gate_instance*net_lvalue*expression*(expression list)
and n_output_gate_instance =
	T_n_output_gate_instance of name_of_gate_instance*net_lvalue*(net_lvalue list)*expression
and pass_switch_instance =
	T_pass_switch_instance of name_of_gate_instance*net_lvalue*net_lvalue
and pass_enable_switch_instance =
	T_pass_enable_switch_instance of name_of_gate_instance*net_lvalue*net_lvalue*expression
and pull_gate_instance =
	T_pull_gate_instance of name_of_gate_instance*net_lvalue
and name_of_gate_instance =
	T_name_of_gate_instance_NOSPEC
	| T_name_of_gate_instance of string*range
and pulldown_strength =
	T_pulldown_strength_NOSPEC
	| T_pulldown_strength01 of strength*strength
	| T_pulldown_strength10 of strength*strength
	| T_pulldown_strength0 of strength
and pullup_strength =
	T_pullup_strength_NOSPEC
	| T_pullup_strength01 of strength*strength
	| T_pullup_strength10 of strength*strength
	| T_pullup_strength1 of strength
and cmos_switchtype =
	T_cmos_switchtype_CMOS
	| T_cmos_switchtype_RCMOS
and enable_gatetype =
		T_enable_gatetype__BUFIF0
	| T_enable_gatetype__BUFIF1
	| T_enable_gatetype__NOTIF0
	| T_enable_gatetype__NOTIF1
and mos_switchtype =
		T_mos_switchtype_NMOS 	
	| T_mos_switchtype_PMOS 
	| T_mos_switchtype_RNMOS 
	| T_mos_switchtype_RPMOS
and n_input_gatetype =
   	T_n_input_gatetype_AND   
	| T_n_input_gatetype_NAND
	| T_n_input_gatetype_OR  
	| T_n_input_gatetype_NOR 
	| T_n_input_gatetype_XOR 
	| T_n_input_gatetype_XNOR 
and n_output_gatetype =
	T_n_output_gatetype_BUF
	| T_n_output_gatetype_NOT
and pass_en_switchtype =
	  T_pass_en_switchtype_TRANIF0  
	| T_pass_en_switchtype_TRANIF1    
	| T_pass_en_switchtype_RTRANIF1  
	| T_pass_en_switchtype_RTRANIF0 
and pass_switchtype =
	  T_pass_switchtype_TRAN  
	| T_pass_switchtype_RTRAN 
and module_instantiation =
	T_module_instantiation of string*parameter_value_assignment*(module_instance list)
and	module_instance =
	T_module_instance of name_of_module_instance*list_of_port_connections
and name_of_module_instance =
	T_name_of_module_instance of string*range
and parameter_value_assignment =
	T_parameter_value_assignment_NOSPEC
	| T_parameter_value_assignment_order of (expression list)
	| T_parameter_value_assignment_named of (named_parameter_assignment list)
and named_parameter_assignment =
	T_named_parameter_assignment of string*mintypmax_expression
and list_of_port_connections =
	T_list_of_port_connections_NOSPEC
	| T_list_of_port_connections_ordered of (ordered_port_connection list)
	| T_list_of_port_connections_named of (named_port_connection list)
and ordered_port_connection =
	T_ordered_port_connection of (attribute_instance list)*expression
and named_port_connection =
	T_named_port_connection of (attribute_instance list)*string*expression
and generate_region =
	T_generate_region of (module_item list)
and genvar_declaration =
	T_genvar_declaration of (string list)
and loop_generate_construct =
	T_loop_generate_construct of genvar_initialization*genvar_expression*genvar_iteration*generate_block
and	genvar_initialization =
	T_genvar_initialization of string*constant_expression
and genvar_expression =
	T_genvar_expression_primary of genvar_primary
	| T_genvar_expression_1op of unary_operator*(attribute_instance list)*genvar_primary
	| T_genvar_expression_2op of genvar_expression*binary_operator*(attribute_instance list)*genvar_expression
	| T_genvar_expression_sel of genvar_expression*(attribute_instance list)*genvar_expression*genvar_expression
and	genvar_iteration =
	T_genvar_iteration of string*genvar_expression
and	genvar_primary =
	T_genvar_primary_const of constant_primary
	| T_genvar_primary_id of string
and conditional_generate_construct =
	T_conditional_generate_construct_if of if_generate_construct
	| T_conditional_generate_construct_case of case_generate_construct
and case_generate_construct =
	T_case_generate_construct of constant_expression*(case_generate_item list)
and	case_generate_item =
	T_case_generate_item_case of (constant_expression list)*generate_block
	| T_case_generate_item_default of generate_block
and	if_generate_construct =
	T_if_generate_construct of constant_expression*generate_block*generate_block
and	generate_block =
	T_generate_block_NOSPEC
	| T_generate_block_mgi of module_item 
	| T_generate_block_begin of string*(module_item list)
and	udp_declaration =
	T_udp_declaration_1 of (attribute_instance list)*identifier*udp_port_list*(udp_port_declaration list)*udp_body
	| T_udp_declaration_2 of (attribute_instance list)*identifier*udp_declaration_port_list*udp_body
and	udp_port_list =
	T_udp_port_list of string*(string list)
and	udp_declaration_port_list =
	T_udp_declaration_port_list of udp_output_declaration*(udp_input_declaration list)
and	udp_port_declaration =
	T_udp_port_declaration_out of udp_output_declaration
	| T_udp_port_declaration_input of udp_input_declaration
	| T_udp_port_declaration_reg of udp_reg_declaration
and	udp_output_declaration =
	T_udp_output_declaration_output of (attribute_instance list)*string
	| T_udp_output_declaration_reg of (attribute_instance list)*string*constant_expression
and	udp_input_declaration =
	T_udp_input_declaration of (attribute_instance list)*(string list)
and	udp_reg_declaration =
	T_udp_reg_declaration of (attribute_instance list)*string
and	udp_body =
	T_udp_body_comb of (combinational_entry list)
	| T_udp_body_seq of sequential_body
and	combinational_entry =
	T_combinational_entry of (level_symbol list)*output_symbol
and sequential_body =
	T_sequential_body of udp_initial_statement*(sequential_entry list)
and	udp_initial_statement =
	T_udp_initial_statement_NOSPEC
	| T_udp_initial_statement of string*init_val
and init_val =
	T_init_val_bin of Lexing.position*Lexing.position*(int*string)
	| T_init_val_unsigned of Lexing.position*Lexing.position*int
and	sequential_entry =
	T_sequential_entry of seq_input_list*current_state*next_state
and	seq_input_list =
	T_seq_input_list_level of level_symbol list
	| T_seq_input_list_edge of edge_input_list
and	edge_input_list =
	T_edge_input_list of (level_symbol list)*edge_indicator*(level_symbol list)
and	edge_indicator =
	T_edge_indicator_level of level_symbol*level_symbol
	| T_edge_indicator_edge of edge_symbol
and	udp_instantiation =
	T_udp_instantiation of identifier*drive_strength*delay2*(udp_instance list)
and udp_instance =
	T_udp_instance of name_of_udp_instance*net_lvalue*(expression list)
and	name_of_udp_instance =
	T_name_of_udp_instance_NOSPEC
	| T_name_of_udp_instance of string*range
and continuous_assign =
	T_continuous_assign of drive_strength*delay3*(net_assignment list)
and	net_assignment =
	T_net_assignment of net_lvalue*expression
and	initial_construct =
	T_initial_construct of statement
and	always_construct =
	T_always_construct of statement
and blocking_assignment =
	T_blocking_assignment of variable_lvalue*delay_or_event_control*expression
and	nonblocking_assignment =
	T_nonblocking_assignment of variable_lvalue*delay_or_event_control*expression
and	procedural_continuous_assignments =
	T_procedural_continuous_assignments_assign of variable_assignment
	| T_procedural_continuous_assignments_deassign of variable_lvalue
	| T_procedural_continuous_assignments_force1 of variable_assignment
	| T_procedural_continuous_assignments_force2 of net_assignment
	| T_procedural_continuous_assignments_release1 of variable_lvalue
	| T_procedural_continuous_assignments_release2 of net_lvalue
and	variable_assignment =
	T_variable_assignment of variable_lvalue*expression
and	par_block =
	T_par_block of (statement list)
and	seq_block =
	T_seq_block of (statement list)
and statement =
	T_statement_NOSPEC
	| T_statement_blocking_assignment of (attribute_instance list)*blocking_assignment
	| T_statement_case_statement of (attribute_instance list)*case_statement
	| T_statement_conditional_statement of  (attribute_instance list)*conditional_statement
	| T_statement_disable_statement of (attribute_instance list)*disable_statement
	| T_statement_event_trigger of (attribute_instance list)*event_trigger
	| T_statement_loop_statement of (attribute_instance list)*loop_statement
	| T_statement_nonblocking_assignment of (attribute_instance list)*nonblocking_assignment
	| T_statement_par_block of (attribute_instance list)*par_block
	| T_statement_procedural_continuous_assignments of  (attribute_instance list)*procedural_continuous_assignments
	| T_statement_procedural_timing_control_statement of (attribute_instance list)*procedural_timing_control_statement
	| T_statement_seq_block of (attribute_instance list)*seq_block
	| T_statement_system_task_enable of  (attribute_instance list)*system_task_enable
	| T_statement_task_enable of (attribute_instance list)*task_enable
	| T_statement_wait_statement of (attribute_instance list)*wait_statement
and	delay_control =
	T_delay_control_delay_value of delay_value
	| T_delay_control_mintypmax_expression of mintypmax_expression
and	delay_or_event_control =
	T_delay_or_event_control_NOSPEC
	| T_delay_or_event_control_delay_control of delay_control
	| T_delay_or_event_control_event_control of event_control
	| T_delay_or_event_control_3 of expression*event_control
and disable_statement =
	T_disable_statement_task of hierarchical_identifier
	| T_disable_statement_block of hierarchical_identifier
and	event_control =
	T_event_control_eventid of hierarchical_identifier
	| T_event_control_event_exp of event_expression
	| T_event_control_start
and	event_trigger =
	T_event_trigger of hierarchical_identifier*(expression list)
and	event_expression =
	T_event_expression_exp of expression
	| T_event_expression_pos of expression
	| T_event_expression_neg of expression
	| T_event_expression_or of event_expression*event_expression
and	procedural_timing_control =
	T_procedural_timing_control_delay of delay_control
	| T_procedural_timing_control_event of event_control
and	procedural_timing_control_statement =
	T_procedural_timing_control_statement of procedural_timing_control*statement
and wait_statement =
	T_wait_statement of expression*statement
and	conditional_statement =
	T_conditional_statement_ifelse of expression*statement*statement
	| T_conditional_statement_ifelseif of expression*statement*(else_if_lp_expression_rp_statement_or_null list)*statement
and	else_if_lp_expression_rp_statement_or_null =
	T_elseif of expression*statement
and case_statement =
	T_case_statement_case of expression*(case_item list)
	| T_case_statement_casez of expression*(case_item list)
	| T_case_statement_casex of expression*(case_item list)
and case_item =
	T_case_item of (expression list)*statement
	| T_case_item_default of statement
and	loop_statement =
	T_loop_statement_forever of statement
	| T_loop_statement_repeat of expression*statement
	| T_loop_statement_while of expression*statement
	| T_loop_statement_for of variable_assignment*expression*variable_assignment*statement
and	system_task_enable =
	T_system_task_enable of string*(expression list)
and	task_enable =
	T_task_enable of hierarchical_identifier*(expression list)
and specify_block =
	T_specify_block of (specify_item list)
and	specify_item =
	T_specify_item_specparam of specparam_declaration
	| T_specify_item_pulsestyle of pulsestyle_declaration
	| T_specify_item_showcancelled of showcancelled_declaration
	| T_specify_item_path of path_declaration
	(*| T_specify_item_system of system_timing_check*)
and pulsestyle_declaration =
	T_pulsestyle_declaration_oneevent of (specify_output_terminal_descriptor list)
	| T_pulsestyle_declaration_onedetect of (specify_output_terminal_descriptor list)
and	showcancelled_declaration =
	T_showcancelled_declaration_show of (specify_output_terminal_descriptor list)
	| T_showcancelled_declaration_noshow of (specify_output_terminal_descriptor list)
and	path_declaration =
	T_path_declaration_simple of simple_path_declaration
	| T_path_declaration_edge of edge_sensitive_path_declaration 
	| T_path_declaration_state of state_dependent_path_declaration
and	simple_path_declaration =
	T_simple_path_declaration_parallel of parallel_path_description*list_of_path_delay_expressions
	| T_simple_path_declaration_full of full_path_description*list_of_path_delay_expressions
and	parallel_path_description =
	T_parallel_path_description of specify_input_terminal_descriptor*polarity_operator*specify_output_terminal_descriptor
and	full_path_description =
	T_full_path_description of (specify_input_terminal_descriptor list)*polarity_operator*(specify_output_terminal_descriptor list)
and	specify_input_terminal_descriptor =
	T_specify_input_terminal_descriptor of identifier*constant_range_expression
and	specify_output_terminal_descriptor =
	T_specify_output_terminal_descriptor of identifier*constant_range_expression
and	list_of_path_delay_expressions =
	T_list_of_constant_mintypmax_expressions_1 of constant_mintypmax_expression
	| T_list_of_constant_mintypmax_expressions_2 of constant_mintypmax_expression*constant_mintypmax_expression
	| T_list_of_constant_mintypmax_expressions_3 of constant_mintypmax_expression*constant_mintypmax_expression*constant_mintypmax_expression
	| T_list_of_constant_mintypmax_expressions_6 of constant_mintypmax_expression*constant_mintypmax_expression*constant_mintypmax_expression*constant_mintypmax_expression*constant_mintypmax_expression*constant_mintypmax_expression
	| T_list_of_constant_mintypmax_expressions_12 of constant_mintypmax_expression*constant_mintypmax_expression*constant_mintypmax_expression*constant_mintypmax_expression*constant_mintypmax_expression*constant_mintypmax_expression*constant_mintypmax_expression*constant_mintypmax_expression*constant_mintypmax_expression*constant_mintypmax_expression*constant_mintypmax_expression*constant_mintypmax_expression
and	edge_sensitive_path_declaration =
	T_edge_sensitive_path_declaration_parallel of parallel_edge_sensitive_path_description*list_of_path_delay_expressions
	| T_edge_sensitive_path_declaration_full of full_edge_sensitive_path_description*list_of_path_delay_expressions
and	parallel_edge_sensitive_path_description =
	T_parallel_edge_sensitive_path_description of edge_identifier*specify_input_terminal_descriptor*specify_output_terminal_descriptor*polarity_operator*expression
and	full_edge_sensitive_path_description =
	T_full_edge_sensitive_path_description of edge_identifier*(specify_input_terminal_descriptor list)*(specify_output_terminal_descriptor list)*polarity_operator*expression
and	state_dependent_path_declaration =
	T_state_dependent_path_declaration_simple of module_path_expression*simple_path_declaration
	| T_state_dependent_path_declaration_edge of module_path_expression*edge_sensitive_path_declaration
	| T_state_dependent_path_declaration_ifnone of simple_path_declaration
(*stop on A.7.5*)
and	concatenation =
	T_concatenation of expression list
and	constant_concatenation =
	T_constant_concatenation of constant_expression list
and	constant_multiple_concatenation =
	T_constant_multiple_concatenation of constant_expression*constant_concatenation
and	module_path_multiple_concatenation =
	T_module_path_multiple_concatenation of constant_expression*module_path_concatenation
and module_path_concatenation =
	T_module_path_concatenation of module_path_expression list
and	multiple_concatenation =
	T_multiple_concatenation of constant_expression*concatenation
and	constant_function_call =
	T_constant_function_call of string*(attribute_instance list)*(constant_expression list)
and	constant_system_function_call =
	T_constant_system_function_call of string*(constant_expression list)
and	function_call =
	T_function_call of (string list)*(attribute_instance list)*(expression list)
and	system_function_call =
	T_system_function_call of string*(expression list)
and	conditional_expression =
	T_conditional_expression of expression*(attribute_instance list)*expression*expression
and	constant_expression =
	T_constant_expression_NOSPEC
	| T_constant_expression_prim of constant_primary
	| T_constant_expression_op1 of unary_operator*(attribute_instance list)*constant_primary
	|	T_constant_expression_op2 of constant_expression*binary_operator*(attribute_instance list)*constant_expression
	|	T_constant_expression_sel of constant_expression*(attribute_instance list)*constant_expression*constant_expression
and constant_mintypmax_expression =
	T_constant_mintypmax_expression_NOSPEC
	| T_constant_mintypmax_expression_1 of constant_expression
	|	T_constant_mintypmax_expression_3 of constant_expression*constant_expression*constant_expression
and constant_range_expression =
	T_constant_range_expression_NOSPEC
	| T_constant_range_expression_1 of constant_expression
	| T_constant_range_expression_2 of msb_constant_expression*lsb_constant_expression
	|	T_constant_range_expression_addrange of constant_base_expression*width_constant_expression
	| T_constant_range_expression_subrange of constant_base_expression*width_constant_expression
and	msb_constant_expression =
	constant_expression
and	lsb_constant_expression =
	constant_expression
and	constant_base_expression =
	constant_expression
and width_constant_expression =
	constant_expression
and	expression =
	T_expression_NOSPEC
	| T_expression_prim of primary
	| T_expression_op1 of unary_operator*(attribute_instance list)*primary
	| T_expression_op2 of expression*binary_operator*(attribute_instance list)*expression
	|	T_expression_condition of conditional_expression
and	mintypmax_expression =
	T_mintypmax_expression_NOSPEC
	| T_mintypmax_expression_1 of expression
	| T_mintypmax_expression_3 of expression*expression*expression
and	module_path_conditional_expression =
	T_module_path_conditional_expression of module_path_expression*(attribute_instance list)*module_path_expression*module_path_expression
and	module_path_expression =
	T_module_path_expression_prim of module_path_primary
	| T_module_path_expression_op1 of unary_module_path_operator*(attribute_instance list)*module_path_primary
	|	T_module_path_expression_op2 of module_path_expression*binary_module_path_operator*(attribute_instance list)*module_path_expression
	|	T_module_path_expression_sel of module_path_conditional_expression
and	module_path_mintypmax_expression =
	T_module_path_mintypmax_expression_1 of module_path_expression
	| T_module_path_mintypmax_expression_3 of module_path_expression*module_path_expression*module_path_expression
and	range_expression =
	T_range_expression_NOSPEC
	| T_range_expression_1 of expression
	| T_range_expression_2 of msb_constant_expression*lsb_constant_expression
	|	T_range_expression_addrange of base_expression*width_constant_expression
	| T_range_expression_subrange of base_expression*width_constant_expression
and	base_expression = expression
and	constant_primary =
	T_constant_primary_num of number
	| T_constant_primary_param of string*constant_range_expression
	|	T_constant_primary_specparam of string*constant_range_expression
	|	T_constant_primary_concat of constant_concatenation
	| T_constant_primary_mul_concat of constant_multiple_concatenation
	| T_constant_primary_func of constant_function_call
	| T_constant_primary_sysfunc of constant_system_function_call
	| T_constant_primary_mintypmax of constant_mintypmax_expression
	| T_constant_primary_string of string
and	module_path_primary =
	T_module_path_primary_num of number
	| T_module_path_primary_id of identifier
	| T_module_path_primary_concat of module_path_concatenation
	| T_module_path_primary_mul_concat of module_path_multiple_concatenation
	| T_module_path_primary_func of function_call
	| T_module_path_primary_sysfunc of system_function_call
	| T_module_path_primary_mintypmax of module_path_mintypmax_expression
and	primary =
	T_primary_num of number
	| T_primary_id of (string list)
	| T_primary_idexp of (string list)*(expression list)*range_expression
	| T_primary_concat of concatenation
	| T_primary_mulcon of multiple_concatenation
	| T_primary_func of function_call
	| T_primary_sysfunc of system_function_call
	| T_primary_mintypmax of mintypmax_expression
	| T_primary_string of string
and	net_lvalue =
	T_net_lvalue_id of (string list)
	| T_net_lvalue_idexp of (string list)*(constant_expression list)*constant_range_expression
	| T_net_lvalue_lvlist of (net_lvalue list)
and variable_lvalue =
	T_variable_lvalue_id of string list
	| T_variable_lvalue_idexp of (string list)*(expression list)*range_expression
	| T_variable_lvalue_vlvlist of variable_lvalue list
and	delay_value =
	T_delay_value_UNSIGNED_NUMBER of Lexing.position*Lexing.position*int
	| T_delay_value_REAL_NUMBER of  Lexing.position*Lexing.position*string
	| T_delay_value_id of identifier
and	attribute_instance =
	T_attribute_instance of (attr_spec list)
and	attr_spec =
	T_attr_spec of string*constant_expression
and	hierarchical_identifier =
	T_hierarchical_identifier of (identifier_lsq_expression_rsq list)*string
and	identifier_lsq_expression_rsq =
	T_identifier_lsq_expression_rsq of string*expression
and polarity_operator =
	T_polarity_operator_NOSPEC
	| T_polarity_operator_ADD
	| T_polarity_operator_SUB
and edge_identifier =
	T_edge_identifier_NOSPEC
	| T_edge_identifier_POS
	| T_edge_identifier_NEG
and unary_operator =
	T_unary_operator_ADD
	| T_unary_operator_SUB
	| T_unary_operator_GANTANHAO
	| T_unary_operator_BOLANGHAO
	| T_unary_operator_REDUCE_AND
	| T_unary_operator_REDUCE_NAND
	| T_unary_operator_REDUCE_OR
	| T_unary_operator_REDUCE_NOR
	| T_unary_operator_REDUCE_XOR
	| T_unary_operator_REDUCE_XNOR
and binary_operator =
	T_binary_operator_ADD
|	T_binary_operator_SUB
|	T_binary_operator_MUL
|	T_binary_operator_DIV
|	T_binary_operator_MOD
|	T_binary_operator_EQU2
|	T_binary_operator_NEQ2
|	T_binary_operator_EQU3
|	T_binary_operator_NEQ3
|	T_binary_operator_AND2
|	T_binary_operator_OR2
|	T_binary_operator_POWER
|	T_binary_operator_LT
|	T_binary_operator_LE
|	T_binary_operator_GT
|	T_binary_operator_GE
|	T_binary_operator_AND1
|	T_binary_operator_OR1
|	T_binary_operator_XOR
|	T_binary_operator_XNOR
|	T_binary_operator_LOGICAL_RIGHTSHIFT
|	T_binary_operator_LOGICAL_LEFTSHIFT
|	T_binary_operator_ARITHMETIC_RIGHTSHIFT
|	T_binary_operator_ARITHMETIC_LEFTSHIFT
and unary_module_path_operator =
	T_unary_module_path_operator_GANTANHAO
	| T_unary_module_path_operator_BOLANGHAO
	| T_unary_module_path_operator_AND
	| T_unary_module_path_operator_NAND
	| T_unary_module_path_operator_OR
	| T_unary_module_path_operator_NOR
	| T_unary_module_path_operator_XOR
	| T_unary_module_path_operator_XNOR
and binary_module_path_operator =
	T_binary_module_path_operator_EQU2
	| T_binary_module_path_operator_NEQ2
  | T_binary_module_path_operator_AND2
  | T_binary_module_path_operator_OR2
  | T_binary_module_path_operator_AND1
  | T_binary_module_path_operator_OR1
  | T_binary_module_path_operator_XOR
  | T_binary_module_path_operator_XNOR
and level_symbol =
	T_level_symbol_UNSIGNED_NUMBER of Lexing.position*Lexing.position*int
	| T_level_symbol_SIMID of Lexing.position*Lexing.position*string 
	| T_level_symbol_QUESTION of Lexing.position*Lexing.position
and output_symbol =
	T_output_symbol_UNSIGNED_NUMBER of Lexing.position*Lexing.position*int
	| T_output_symbol_SIMID of Lexing.position*Lexing.position*string
and number =
	T_number_UNSIGNED_NUMBER of Lexing.position*Lexing.position*int
	| T_number_UNSIGNED_NUMBER_size of Lexing.position*Lexing.position*(int*int)
	| T_number_OCTAL_NUMBER of Lexing.position*Lexing.position*(int*string)
	| T_number_BINARY_NUMBER of Lexing.position*Lexing.position*(int*string)
	| T_number_HEX_NUMBER of Lexing.position*Lexing.position*(int*string)
	| T_number_REAL_NUMBER of Lexing.position*Lexing.position*string
and current_state =
	T_current_state_UNSIGNED_NUMBER of Lexing.position*Lexing.position*int
	| T_current_state_SIMID of Lexing.position*Lexing.position*string
	| T_current_state_OP2_QUESTION of Lexing.position*Lexing.position
and next_state =
	T_next_state_UNSIGNED_NUMBER of Lexing.position*Lexing.position*int
	| T_next_state_SIMID of  Lexing.position*Lexing.position*string
	| T_next_state_SUB of  Lexing.position*Lexing.position
and edge_symbol =
	T_edge_symbol_SIMID of Lexing.position*Lexing.position*string
	| T_edge_symbol_MUL of Lexing.position*Lexing.position
and identifier =
	T_identifier of Lexing.position*Lexing.position*string
