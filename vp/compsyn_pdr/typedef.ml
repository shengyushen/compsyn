(*types of SAT solving and interpolants*)
type result = SATISFIABLE | UNSATISFIABLE 
type result_uniq = RES_UNIQ | RES_NONU | RES_UNK
(*type proofitem = Tproofitem_0B of int list*)
(*I dont need B's cls*)
type proofitem = Tproofitem_0B
		| Tproofitem_1A of int list
		| Tproofitem_chain of int*((int*int) list)(* *(int list)*)  (*learned cls id,  clsA   (varB*clsB) list   learned cls*)

type iterpCircuit = TiterpCircuit_true
		| TiterpCircuit_false
		| TiterpCircuit_refcls of int
		| TiterpCircuit_refvar of int
		| TiterpCircuit_and of iterpCircuit list
		| TiterpCircuit_or of iterpCircuit list
		| TiterpCircuit_not of iterpCircuit
		| TiterpCircuit_none
		| TiterpCircuit_printed of int


(*types of parsing*)
type	module_def	=
		T_module_def of string*(port list)*(module_item list)
		| T_module_def_NOSPEC
and	port		=
		string list
and	module_item	=
		T_parameter_declaration of param_assignment list
		| T_input_declaration    of range*(string list)
		| T_output_declaration    of range*(string list)
		| T_inout_declaration    of range*(string list)
		| T_net_declaration    of string*charge_strength*expandrange*delay*(string list)
		| T_reg_declaration   of range*(register_variables list)
		| T_time_declaration   of register_variables list
		| T_integer_declaration   of register_variables list
		| T_real_declaration   of string list
		| T_event_declaration   of string list
		| T_gate_declaration of string*drive_strength*delay*(gate_instance list)
		| T_module_instantiation   of string*drive_strength*(expression list)*(module_instance list)
		| T_parameter_override   of param_assignment list
		| T_continuous_assign   of continuous_assign
		| T_specify_block   of specify_item list
		| T_initial_statement   of statement
		| T_always_statement   of statement
		| T_task   of string*(module_item list)*statement
		| T_function_avoid_amb   of range_or_type*string*(module_item list)*statement
and	statement	=
		T_blocking_assignment of blocking_assignment
		| T_non_blocking_assignment of non_blocking_assignment
		| T_if_statement of expression*statement
		| T_if_else_statement of expression*statement*statement
		| T_case_statement of expression*(case_item list)
		| T_seq_block of string*(module_item list)*(statement list)
		| T_statement_NOSPEC
		| T_forever_statement of statement
		| T_repeat_statement of expression*statement
		| T_while_statement of expression*statement
		| T_for_statement of assignment*expression*assignment*statement
		| T_event_statement of event_control*statement
		| T_wait_statement of expression*statement
		| T_leadto_event of string
		| T_par_block of string*(module_item list)*(statement list)
		| T_task_enable of string*(expression list)		
		| T_system_task_enable of string*(expression list)
		| T_disable_statement of string  
		| T_force_statement of assignment
		| T_release_statement of lvalue
		| T_casez_statement of expression*(case_item list)
		| T_casex_statement of expression*(case_item list)
		| T_delay_statement of delay_control*statement
and	blocking_assignment	=
	  T_blocking_assignment_direct of lvalue*expression
	| T_blocking_assignment_delay of lvalue*expression*delay_control
	| T_blocking_assignment_event of lvalue*expression*event_control
and	non_blocking_assignment	=
	  T_non_blocking_assignment_direct of lvalue*expression
	| T_non_blocking_assignment_delay of lvalue*expression*delay_control
	| T_non_blocking_assignment_event of lvalue*expression*event_control
and	arrayassign	=
	  T_arrayassign of int*int*expression	(*only for defining array assignment*)
and	expression	=
	  T_primary of primary
	| T_primary_4arrayassign of (arrayassign list)   (*only for defining array assignment*)
	| T_add1 of primary
	| T_sub1 of primary
	| T_logicneg of primary
	| T_bitneg of primary
	| T_reduce_and of primary
	| T_reduce_nand of primary
	| T_reduce_or of primary
	| T_reduce_nor of primary
	| T_reduce_xor of primary
	| T_reduce_xnor of primary
	| T_add2 of expression*expression
	| T_sub2 of expression*expression
	| T_mul2 of expression*expression
	| T_div of expression*expression
	| T_mod of expression*expression
	| T_logic_equ of expression*expression
	| T_logic_ine of expression*expression
	| T_case_equ of expression*expression
	| T_case_ine of expression*expression
	| T_logic_and2 of expression*expression
	| T_logic_or2 of expression*expression
	| T_lt of expression*expression
	| T_le of expression*expression
	| T_gt of expression*expression
	| T_ge of expression*expression
	| T_bit_and2 of expression*expression
	| T_bit_or2 of expression*expression
	| T_bit_xor2 of expression*expression
	| T_bit_equ of expression*expression
	| T_leftshift of expression*expression
	| T_rightshift of expression*expression
	| T_selection of expression*expression*expression
	| T_string of string
	| T_expression_NOSPEC of int
and	case_item	=
	T_case_item_normal of (expression list)*statement
	| T_case_item_default of statement
and	assignment	=
	T_assignment of lvalue*expression
and	delay_control	= T_delay_control of expression
and	event_control	=
	T_event_control_id of string list
	| T_event_control_evexp of event_expression list
and	lvalue 		=
	T_lvalue_id of string list
	| T_lvalue_arrbit  of (string list)*expression
	| T_lvalue_arrrange of (string list)*expression*expression
	| T_lvalue_concat of expression list
and	primary		=
	T_primary_num of number
	| T_primary_id of string list
	| T_primary_arrbit of (string list)*expression
	| T_primary_arrrange of (string list)*expression*expression
	| T_primary_concat of expression list
	| T_primary_multiconcat of expression*(expression list)
	| T_primary_funcall of (string list)*(expression list)
	| T_primary_sysfuncall of (string list)*(expression list)
	| T_primary_minmaxexp of mintypmax_expression
and	event_expression	=
	T_event_expression of expression
	| T_event_expression_posedge of expression
	| T_event_expression_negedge of expression
and	number	=
	T_number_unsign of int
	| T_number_base of int*char*(string)
	| T_number_float of float
and	mintypmax_expression	=
	T_mintypmax_expression_1 of expression
	| T_mintypmax_expression_3 of expression*expression*expression
and	param_assignment	=
	T_param_assignment of (string list)*expression
and	specify_item	= int
and	drive_strength	=
	T_drive_strength of string*string
	| T_drive_strength_NOSPEC
and	delay	=
	 T_delay_number of number
	 | T_delay_id of string list
	 | T_delay_minmax1 of mintypmax_expression
	 | T_delay_minmax3 of mintypmax_expression*mintypmax_expression*mintypmax_expression
	 | T_delay_NOSPEC
and	gate_instance	=
	T_gate_instance of string*(expression list)
and	integer_declaration	= register_variables list
and	register_variables	=
	T_register_variables_ID of string 
	| T_register_variables_IDrange of string*expression*expression
and	range	=
	T_range of expression*expression
	| T_range_int of int*int		(*this can only be generated by Rtl.elab_range*)
	| T_range_NOSPEC
and	module_instance	=
	T_module_instance of string*list_of_module_connections
and	list_of_module_connections	=
	T_list_of_module_connections_unnamed of expression list
	| T_list_of_module_connections_named of named_port_connection list
and	named_port_connection	=
	T_named_port_connection of string*expression
and	continuous_assign	=
	T_continuous_assign_assign of drive_strength*delay*(assignment list)
	| T_continuous_assign_net of string*drive_strength*expandrange*delay*(assignment list)
and	expandrange	=
	T_expandrange_range of range
	| T_expandrange_scalared of range
	| T_expandrange_vectored of range
	| T_expandrange_NOSPEC
and	charge_strength	=
	T_charge_strength_SMALL
	| T_charge_strength_MEDIUM
	| T_charge_strength_LARGE
	| T_charge_strength_NOSPEC
and	range_or_type	=
	T_range_or_type_range of range
	| T_range_or_type_INTEGER
	| T_range_or_type_REAL
	| T_range_or_type_NOSPEC
;;
