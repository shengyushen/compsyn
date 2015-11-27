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
	| T_config_rule_statement__inst_lib of (string list)*liblist_clause
	| T_config_rule_statement__inst_use of (string list)*use_clause
	| T_config_rule_statement__cell_lib of cell_clause*liblist_clause
	| T_config_rule_statement__cell_use of cell_clause*use_clause
and 
