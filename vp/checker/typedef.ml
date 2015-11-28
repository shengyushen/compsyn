type description =
	T_description__module_declaration of module_declaration
	| T_description__udp_declaration of udp_declaration
	| T_description__config_declaration of config_declaration
and module_declaration =
	T_module_declaration__1 of (attribute_instance list)*string*(module_parameter_port list)*(port list)*(module_item list)
	| T_module_declaration__2 of(attribute_instance list)*string*(module_parameter_port list)*(port_declaration list)*(module_item list)
and port =
	T_port_position of port_expression
	| T_port_name of string*port_expression
and port_expression =
	T_port_expression of (port_reference list)
and 
and range_expression =
	T_range_expression_NOSPEC
	| T_range_expression_1 of expression
	| T_range_expression_2 of expression*expression
	| T_range_expression_2_add of expression*expression
	| T_range_expression_2_sub of expression*expression
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
	T_config_declaration of string*design_statement*(config_rule_statement list)
and design_statement =
	T_design_statement of (library_identifier_period_opt_cell_identifier list)
and library_identifier_period_opt_cell_identifier =
	T_lib_cell_identifier of string*string
and config_rule_statement = 
	T_config_rule_statement__default of liblist_clause
	| T_config_rule_statement__inst_lib of (string list)*(string list)
	| T_config_rule_statement__inst_use of (string list)*use_clause
	| T_config_rule_statement__cell_lib of library_identifier_period_opt_cell_identifier*(string list)
	| T_config_rule_statement__cell_use of library_identifier_period_opt_cell_identifier*use_clause
and use_clause =
	T_use_clause of library_identifier_period_opt_cell_identifier*colon_config_opt
and colon_config_opt = 
	T_colon_config_opt_FALSE
	| T_colon_config_opt_TRUE
and signed : 
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
and 
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
	|T_output_declaration_reg of signed*range*(string list)
	|T_output_declaration_var of output_variable_type*(string list)
and event_declaration =
	T_event_declaration of (event_identifier_dimension_list list)
and integer_declaration =
	T_integer_declaration of list_of_variable_identifiers
and net_declaration =
	T_net_declaration_net_type1 of net_type*signed*delay3*(net_identifier_dimension_list list)
	| T_net_declaration_net_type2 of net_type*drive_strength*signed*delay3*(net_identifier_dimension_list list)
	| T_net_declaration_net_type3 of net_type*vectored_scalared*signed*range*delay3*(net_identifier_dimension_list list)
	| T_net_declaration_net_type4 of net_type*drive_strength*vectored_scalared*signed*range*delay3*(net_decl_assignments list)
	| T_net_declaration_trireg_1 of charge_strength*signed*delay3*(net_identifier_dimension_list list)
	| T_net_declaration_trireg_2 of drive_strength*signed*delay3*(net_decl_assignments list)
	| T_net_declaration_trireg_3 of charge_strength*vectored_scalared*signed*range*delay3*
	| T_net_declaration_trireg_4 of drive_strength*vectored_scalared*signed*range*delay3*(net_decl_assignments list)
and vectored_scalared =
	T_vectored_scalared_NOSPEC
	|T_vectored_scalared_vectored
	|T_vectored_scalared_scalared
and real_declaration =
	T_real_declaration of (real_type list)
and realtime_declaration =
	T_realtime_declaration of (real_type list)
and reg_declaration =
	T_reg_declaration of signed*range*list_of_variable_identifiers
and time_declaration =
	T_time_declaration of list_of_variable_identifiers
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
and 
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
	T_charge_strength__small
	| T_charge_strength__medium
	| T_charge_strength__large
and 
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
and net_identifier_dimension_list :
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
and
and range =
	T_range_NOSPEC
	| T_range of constant_expression*constant_expression
and automatic =
	T_automatic_false
	| T_automatic_true
and function_declaration =
	T_function_declaration_1 of automatic*function_range_or_type*string*(function_item_declaration list)*function_statement
	| T_function_declaration_2 of automatic*function_range_or_type*string*(attribute_instance_list_tf_input_declaration list)*(block_item_declaration list)*function_statement
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
and task_port_item
	T_task_port_item_input of tf_input_declaration
	| T_task_port_item_output of tf_output_declaration
	| T_task_port_item_inout of tf_inout_declaration
and reg =
	T_reg_false
	| T_reg_true
and tf_input_declaration =
	T_tf_input_declaration_reg of reg*signed*range*(port_identifier list)
	| T_tf_input_declaration_type of task_port_type*(port_identifier list)
and tf_output_declaration =
	T_tf_output_declaration_reg of reg*signed*range*(port_identifier list)
	| T_tf_output_declaration_type of task_port_type*(port_identifier list)
and tf_inout_declaration =
	T_tf_inout_declaration_reg of reg*signed*range*(port_identifier list)
	| T_tf_inout_declaration_type of task_port_type*(port_identifier list)
and task_port_type =
	T_task_port_type_integer
	| T_task_port_type_real
	| T_task_port_type_realtime
	| T_task_port_type_time
and block_item_declaration =
	T_block_item_declaration_reg of (attribute_instance list)*signed*range*(block_variable_type list)
	| T_block_item_declaration_integer of (attribute_instance list)*(block_variable_type list)
	| T_block_item_declaration_time of (attribute_instance list)*(block_variable_type list)
	| T_block_item_declaration_real of (attribute_instance list)*(block_variable_type list)
	| T_block_item_declaration_realtime of (attribute_instance list)*(block_variable_type list)
	| T_block_item_declaration_event of (attribute_instance list)*local_parameter_declaration
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
and 
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
	T_module_instantiation of string*parameter_value_assignment
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
	T_generate_region of (module_or_generate_item list)
and genvar_declaration
	T_genvar_declaration of (genvar_identifier list)




and statement =
	T_statement_NOSPEC
	| T_statement???
and constant_expression =
	T_constant_expression_NOSPEC
	| ???
and constant_mintypmax_expression
	T_constant_mintypmax_expression_NOSPEC
	| ???
and	mintypmax_expression
	T_mintypmax_expression_NOSPEC
	| ???
