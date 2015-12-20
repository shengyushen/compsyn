open Printf
open Unix
open Misc
open Typedef

let rec print_source_text fc source_text = begin
	fprintf fc "//generated by checker at %s\n" (get_time_string );
	List.iter (print_description fc) source_text
end
and print_description fc description = begin
	match description with
	T_description__module_declaration(module_declaration) -> begin
		print_module_declaration fc module_declaration
	end
	| _ -> assert false
end
and print_module_declaration fc module_declaration = begin
	match module_declaration with
	T_module_declaration__1(
		attribute_instance_list,
		module_identifier,
		module_parameter_port_list_opt,
		list_of_ports,
		module_item_list
	) -> begin
		List.iter (print_attribute_instance fc) attribute_instance_list;
		fprintf fc "module  %s\n" (get_identifier_string module_identifier);

		print_module_parameter_port_list_opt fc module_parameter_port_list_opt ;

		fprintf fc "(";
		list_iter_with_sep list_of_ports (print_port fc) (fun () -> fprintf fc " ,\n");
		fprintf fc ");\n";
		
		List.iter (print_module_item fc) module_item_list;

		fprintf fc "\n\n\n";
		fprintf fc "endmodule\n\n\n";
	end
end
and print_attribute_instance fc attribute_instance = begin
	fprintf fc "(*";
	begin
		match attribute_instance with
		T_attribute_instance(attr_spec_list) -> begin
			list_iter_with_sep attr_spec_list (print_attr_spec fc) (fun () -> fprintf fc ",")
		end
	end
	;
	fprintf fc "*)\n";
end
and print_attr_spec fc attr_spec =begin
	match attr_spec with
	T_attr_spec ( identifier , expression ) -> begin
		print_identifier fc identifier;
		match expression with
		T_expression_NOSPEC -> fprintf fc " ";
		| _ -> print_expression fc expression
	end
end
and print_module_parameter_port_list_opt fc module_parameter_port_list_opt = begin
	match module_parameter_port_list_opt with
	[] -> fprintf fc ""
	| _ -> begin
		fprintf fc "#(\n";
		list_iter_with_sep module_parameter_port_list_opt (print_parameter_declaration_gen fc) (fun () -> fprintf fc ", \n");
		fprintf fc "\n)\n";
	end
end
and print_parameter_declaration_gen fc parameter_declaration_gen = begin
	match parameter_declaration_gen with
	T_parameter_declaration_gen_1(parameter_type_opt,signed_opt,range_opt,param_assignment) -> begin
		fprintf fc "parameter ";
		print_parameter_type_opt fc parameter_type_opt;
		print_signed_opt fc signed_opt;
		print_range_opt fc range_opt;
		print_param_assignment fc param_assignment;
	end
end
and print_parameter_type_opt fc parameter_type_opt = begin
	match parameter_type_opt with
	T_parameter_type__NOSPEC     -> fprintf fc " ";
	| T_parameter_type__INTEGER  -> fprintf fc "integer" 
	| T_parameter_type__REAL     -> fprintf fc "real"
	| T_parameter_type__REALTIME -> fprintf fc "REALTIME"
	| T_parameter_type__TIME     -> fprintf fc "time" 
	| _ -> assert false
end
and print_signed_opt fc signed_opt = begin
	match signed_opt with
	T_signed_FALSE  -> fprintf fc " ";
	| T_signed_TRUE -> fprintf fc "signed";
end
and print_range_opt fc range_opt = begin
	match range_opt with
	T_range_NOSPEC   -> fprintf fc " ";
	| T_range(exp1,exp2) -> begin
		fprintf fc "[";
		print_expression fc exp1;
		fprintf fc ":";
		print_expression fc exp2;
		fprintf fc "]";
	end
end 
and print_expression fc expression  = begin
	match expression with
	T_expression_NOSPEC  -> fprintf fc " "
	| T_expression_prim(primary)  -> print_primary fc primary
	| T_expression_op1 (unary_operator,attribute_instance_list,primary) -> begin
		fprintf fc "(";
		print_unary_operator fc unary_operator;
		List.iter (print_attribute_instance fc) attribute_instance_list;
		print_primary fc primary;
		fprintf fc ")";
	end
	| T_expression_op2 ( exp1 , binary_operator , attribute_instance_list , exp2 ) -> begin
		fprintf fc "(";
			print_expression fc exp1;
			print_binary_operator fc binary_operator;
			List.iter (print_attribute_instance fc) attribute_instance_list;
			print_expression fc exp2;
		fprintf fc ")";
	end
	|	T_expression_condition(conditional_expression ) -> begin
		print_conditional_expression fc conditional_expression
	end
end
and print_conditional_expression fc conditional_expression  = begin
	match conditional_expression with
	T_conditional_expression ( exp1 , attribute_instance_list , exp2 , exp3 ) -> begin
		fprintf fc "(";
			print_expression fc exp1;
		fprintf fc "?";
			List.iter (print_attribute_instance fc) attribute_instance_list;
			print_expression fc exp2;
		fprintf fc ":";
			print_expression fc exp3;
		fprintf fc ")";
	end
end 
and print_primary fc primary = begin
	fprintf fc "(";
	begin
	match primary with
	T_primary_num ( number ) -> print_number fc number
	| T_primary_id ( hierarchical_identifier ) -> print_hierarchical_identifier fc hierarchical_identifier
	| T_primary_concat ( concatenation  ) -> print_concatenation fc concatenation
	| T_primary_mulcon ( multiple_concatenation ) -> print_multiple_concatenation fc multiple_concatenation
	| T_primary_func ( function_call ) -> print_function_call fc function_call
	| T_primary_sysfunc ( system_function_call  ) -> 
		print_system_function_call fc system_function_call
	| T_primary_mintypmax ( mintypmax_expression ) ->
		print_mintypmax_expression fc mintypmax_expression
	| T_primary_string ( str ) ->
		fprintf fc "%s" str
	end;
	fprintf fc ")";
end
and print_number fc number = begin
	fprintf fc "(";
	begin
	match number with
	T_number_UNSIGNED_NUMBER ( _ ,_ , i )  -> 
		fprintf fc "%d" i
	| T_number_UNSIGNED_NUMBER_size ( _,_,(i1,i2)) -> 
		fprintf fc "%d'd%d" i1 i2
	| T_number_OCTAL_NUMBER (_,_,(i,str)) ->
		fprintf fc "%d'o%s" i str
	| T_number_BINARY_NUMBER (_,_,(i,str)) -> 
		fprintf fc "%d'b%s" i str
	| T_number_HEX_NUMBER (_,_,(i,str)) -> 
		fprintf fc "%d'h%s" i str
	| T_number_REAL_NUMBER (_,_,str) -> 
		fprintf fc "%s" str
	end;
	fprintf fc ")";
end
and print_identifier fc identifier = begin
	match identifier with
	T_identifier_NOSPEC -> fprintf fc " ";
	| T_identifier ( _ , _ , str) -> fprintf fc "%s" str
end
and print_unary_operator fc unary_operator = begin
	match unary_operator with
	 T_unary_operator_LOGIC_NEG ->
	 	fprintf fc " ! "
	| T_unary_operator_BITWISE_NEG ->
		fprintf fc  " ~ "
	| T_unary_operator_REDUCE_NOR ->
		fprintf fc " ~| "
	| T_unary_operator_REDUCE_NAND ->
		fprintf fc " ~& "
	| T_unary_operator_ADD ->
		fprintf fc " + "
	| T_unary_operator_SUB ->
		fprintf fc " - "
	| T_unary_operator_REDUCE_AND ->
		fprintf fc " & "
	| T_unary_operator_REDUCE_OR -> 
		fprintf fc " | "
	| T_unary_operator_REDUCE_XOR -> 
		fprintf fc " ^ "
	| T_unary_operator_REDUCE_XNOR ->
		fprintf fc " ~^ "
end
and print_binary_operator fc binary_operator = begin
	match binary_operator with
	T_binary_operator_MUL -> 
		fprintf fc " * "
|	T_binary_operator_DIV ->
		fprintf fc " / "
|	T_binary_operator_MOD ->
		fprintf fc " %% "
|	T_binary_operator_EQU2 ->
		fprintf fc " == "
|	T_binary_operator_NEQ2 ->
		fprintf fc " != "
|	T_binary_operator_EQU3 ->
		fprintf fc " === "
|	T_binary_operator_NEQ3 ->
		fprintf fc " !== "
|	T_binary_operator_POWER ->
		fprintf fc " ** "
|	T_binary_operator_LT ->
		fprintf fc " < "
|	T_binary_operator_LE ->
		fprintf fc " <= "
|	T_binary_operator_GT ->
		fprintf fc " > "
|	T_binary_operator_GE ->
		fprintf fc " >= "
|	T_binary_operator_LOGICAL_RIGHTSHIFT ->
		fprintf fc " >> "
|	T_binary_operator_LOGICAL_LEFTSHIFT ->
		fprintf fc " << "
|	T_binary_operator_ARITHMETIC_RIGHTSHIFT ->
		fprintf fc " >>> "
|	T_binary_operator_ARITHMETIC_LEFTSHIFT ->
		fprintf fc " <<< "
|	T_binary_operator_ADD ->
		fprintf fc " + "
|	T_binary_operator_SUB ->
		fprintf fc " - "
|	T_binary_operator_AND ->
		fprintf fc " & "
|	T_binary_operator_OR ->
		fprintf fc " | "
|	T_binary_operator_AND2 -> 
		fprintf fc " && "
|	T_binary_operator_OR2 ->
		fprintf fc " || "
|	T_binary_operator_XOR ->
		fprintf fc " ^ "
|	T_binary_operator_XNOR ->
		fprintf fc " ~^ "
end 
and print_hierarchical_identifier fc hierarchical_identifier = begin
	match hierarchical_identifier with
	T_hierarchical_identifier ( identifier_lsq_expression_rsq_list ) -> begin
		List.iter (print_identifier_lsq_expression_rsq fc) identifier_lsq_expression_rsq_list
	end
end
and print_identifier_lsq_expression_rsq fc identifier_lsq_expression_rsq = begin
	match identifier_lsq_expression_rsq with
	T_identifier_lsq_expression_rsq ( identifier , range_expression_list ) -> begin
		print_identifier fc identifier;
		List.iter (print_range_expression fc ) range_expression_list
	end
end
and print_range_expression fc range_expression = begin
	match range_expression with
	T_range_expression_NOSPEC -> 
		fprintf fc " "
	| T_range_expression_1 ( expression ) -> begin
		fprintf fc " [ ";
		print_expression fc expression;
		fprintf fc " ] ";
	end
	| T_range_expression_2 ( msb_expression , lsb_expression ) -> begin
		fprintf fc " [ ";
		print_expression fc msb_expression;
		fprintf fc " : ";
		print_expression fc lsb_expression;
		fprintf fc " ] ";
	end
	|	T_range_expression_addrange ( base_expression , width_expression ) -> begin
		fprintf fc " [ ";
		print_expression fc base_expression;
		fprintf fc " +: ";
		print_expression fc width_expression;
		fprintf fc " ] ";
	end
	| T_range_expression_subrange ( base_expression , width_expression ) -> begin
		fprintf fc " [ ";
		print_expression fc base_expression;
		fprintf fc " -: ";
		print_expression fc width_expression;
		fprintf fc " ] ";
	end
end
and print_concatenation fc concatenation = begin
	fprintf fc "{";
	begin
	match concatenation with
	T_concatenation ( expression_list ) -> 
		list_iter_with_sep expression_list (print_expression fc) (fun () -> fprintf fc " , ")
	end ;
	fprintf fc "}";
end
and print_multiple_concatenation fc multiple_concatenation = begin
	match multiple_concatenation with
	T_multiple_concatenation ( expression , concatenation ) -> begin
		fprintf fc "{";
			print_expression fc expression;
			print_concatenation fc concatenation;
		fprintf fc "}";
	end
end
and print_function_call fc function_call = begin
	match function_call with
	T_function_call ( hierarchical_identifier , attribute_instance_list , expression_list ) -> begin
		print_hierarchical_identifier fc hierarchical_identifier;
		List.iter (print_attribute_instance fc) attribute_instance_list;
		fprintf fc "(";
		list_iter_with_sep expression_list (print_expression fc) (fun () -> fprintf fc " , ");
		fprintf fc ")";
	end
end
and print_system_function_call fc system_function_call = begin
	match system_function_call with
	T_system_function_call ( system_function_identifier , expression_list ) -> begin
		print_system_function_identifier fc system_function_identifier;
		if(isnotempty expression_list) then begin
			fprintf fc "(";
				list_iter_with_sep expression_list (print_expression fc) (fun () -> fprintf fc " , ");
			fprintf fc ")";
		end
	end
end
and print_mintypmax_expression fc mintypmax_expression = begin
	match mintypmax_expression with
	T_mintypmax_expression_NOSPEC -> fprintf fc " "
	| T_mintypmax_expression_1 ( expression ) -> 
		print_expression fc expression
	| T_mintypmax_expression_3 ( exp1 , exp2 , exp3 ) -> begin
		print_expression fc exp1;
		fprintf fc " : ";
		print_expression fc exp2;
		fprintf fc " : ";
		print_expression fc exp3;
	end
end
and print_system_function_identifier fc system_function_identifier = begin
	match system_function_identifier with
	T_system_function_identifier ( _ , _ , str ) -> 
		fprintf fc "%s" str
end
and print_param_assignment fc param_assignment = begin
	match param_assignment with
	T_param_assignment ( identifier , mintypmax_expression ) -> begin
		print_identifier fc identifier;
		fprintf fc " = " ;
		print_mintypmax_expression fc mintypmax_expression
	end
end
and print_port fc port = begin
	match port with
	T_port_exp ( identifier , port_expression ) -> begin
		fprintf fc " ." ;
		print_identifier fc identifier;
		fprintf fc "(" ;
		print_port_expression fc port_expression;
		fprintf fc ") " ;
	end
	| T_port_net ( io_type , netreg_type , signed , range , port_expression , expression )  -> begin
		print_io_type fc io_type;
		print_netreg_type fc netreg_type;
		print_range fc range;
		print_port_expression fc port_expression;
		match expression with
		T_expression_NOSPEC -> fprintf fc " ";
		| _ -> begin
			fprintf fc " = " ;
			print_expression fc expression
		end
	end
end
and print_port_expression fc port_expression = begin
	match port_expression with
	T_port_expression ( port_reference_list ) -> begin
		match port_reference_list with
		[port_reference] -> print_port_reference fc port_reference
		| hd::tl -> list_iter_with_sep port_reference_list (print_port_reference fc) (fun () -> fprintf fc " , ")
		| _ -> assert false
	end
end
and print_io_type fc io_type = begin
	match io_type with
	T_io_type_NOSPEC -> fprintf fc "";
	| T_io_type_output -> fprintf fc "output";
	| T_io_type_input  -> fprintf fc "input";
	| T_io_type_inout  -> fprintf fc "inout";
end
and print_netreg_type fc netreg_type = begin
	match netreg_type with
	T_netreg_type__NOSPEC      -> fprintf fc "";
	| T_netreg_type__KEY_SUPPLY0 -> fprintf fc "supply0";	
	| T_netreg_type__KEY_SUPPLY1 -> fprintf fc "supply1";	
	| T_netreg_type__KEY_TRI		 -> fprintf fc "tri";	
	| T_netreg_type__KEY_TRIAND	 -> fprintf fc "triand";	
	| T_netreg_type__KEY_TRIOR	 -> fprintf fc "trior";	
	| T_netreg_type__KEY_TRI0		 -> fprintf fc "tri0";	
	| T_netreg_type__KEY_TRI1		 -> fprintf fc "tri1";	
	| T_netreg_type__KEY_UWIRE	 -> fprintf fc "uwire";	
	| T_netreg_type__KEY_WIRE		 -> fprintf fc "wire";	
	| T_netreg_type__KEY_WAND		 -> fprintf fc "wand";		
	| T_netreg_type__KEY_WOR		 -> fprintf fc "wor";	
	| T_netreg_type__KEY_REG		 -> fprintf fc "reg";	
	| T_netreg_type__KEY_INTEGER -> fprintf fc "integer";	
	| T_netreg_type__KEY_TIME		 -> fprintf fc "time";	
end
and print_range fc range = begin
	match range with
	T_range_NOSPEC   -> fprintf fc " ";
	| T_range(exp1,exp2) -> begin
		fprintf fc "[";
		print_expression fc exp1;
		fprintf fc ":";
		print_expression fc exp2;
		fprintf fc "]";
	end
end
and print_port_reference fc port_reference = begin
	match port_reference with
	T_port_reference ( identifier , range_expression ) -> begin
		print_identifier fc identifier ;
		print_range_expression fc range_expression
	end
end
and print_module_item fc module_item = begin
	match module_item with
	T_module_item__port_declaration ( port_declaration ) -> begin
		print_port_declaration fc port_declaration;
		fprintf fc " ;\n"
	end
	| T_module_item__generate_region ( generate_region )  -> 
		print_generate_region fc generate_region 
	| T_module_item__specify_block ( specify_block )  -> begin
		assert false
	end
	| T_module_item__parameter_declaration ( attribute_instance_list , parameter_declaration ) -> begin
		List.iter (print_attribute_instance fc) attribute_instance_list;
		print_parameter_declaration fc parameter_declaration;
		fprintf fc ";\n";
	end
	| T_module_item__specparam_declaration ( attribute_instance_list , specparam_declaration ) -> begin
		assert false
	end
	| T_module_item__net_declaration  ( attribute_instance_list , net_declaration ) -> begin
		List.iter (print_attribute_instance fc) attribute_instance_list;
		print_net_declaration fc net_declaration
	end
	| T_module_item__reg_declaration ( attribute_instance_list , reg_declaration  ) -> begin
		List.iter (print_attribute_instance fc) attribute_instance_list;
		print_reg_declaration fc reg_declaration
	end
	| T_module_item__integer_declaration ( attribute_instance_list , integer_declaration ) -> begin
		List.iter (print_attribute_instance fc) attribute_instance_list;
		print_integer_declaration fc integer_declaration
	end
	| T_module_item__real_declaration ( attribute_instance_list , real_declaration ) -> begin
		List.iter (print_attribute_instance fc) attribute_instance_list;
		print_real_declaration fc real_declaration
	end
	(*| T_module_item__time_declaration of (attribute_instance list)*time_declaration
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
	| T_module_item__conditional_generate_construct of (attribute_instance list)*conditional_generate_construct*)
	| _  -> fprintf fc ""
end
and print_port_declaration fc port_declaration = begin
	match port_declaration with
	T_port_declaration__inout_declaration ( attribute_instance_list , inout_declaration ) -> begin
		List.iter (print_attribute_instance fc) attribute_instance_list;
		print_inout_declaration fc inout_declaration
	end
	| T_port_declaration__input_declaration ( attribute_instance_list , input_declaration ) -> begin
		List.iter (print_attribute_instance fc) attribute_instance_list;
		print_input_declaration fc input_declaration
	end
	| T_port_declaration__output_declaration ( attribute_instance_list , output_declaration ) -> begin
		List.iter (print_attribute_instance fc) attribute_instance_list;
		print_output_declaration fc output_declaration
	end
end
and print_inout_declaration fc inout_declaration = begin
	match inout_declaration with
	T_inout_declaration ( net_type , signed , range , identifier_list ) -> begin
		fprintf fc "  inout ";
		print_net_type fc net_type;
		print_signed_opt fc signed;
		print_range fc range;
		list_iter_with_sep identifier_list (print_identifier fc) (fun () -> fprintf fc ",")
	end
end
and print_input_declaration fc input_declaration = begin
	match input_declaration with
	T_input_declaration ( net_type , signed , range , identifier_list ) -> begin
		fprintf fc "  input ";
		print_net_type fc net_type;
		print_signed_opt fc signed;
		print_range fc range;
		list_iter_with_sep identifier_list (print_identifier fc) (fun () -> fprintf fc ",")
	end
end
and print_output_declaration fc output_declaration = begin
	match output_declaration with
	T_output_declaration_net ( net_type , signed , range , identifier_list ) -> begin
		fprintf fc "  output ";
		print_net_type fc net_type;
		print_signed_opt fc signed;
		print_range fc range;
		list_iter_with_sep identifier_list (print_identifier fc) (fun () -> fprintf fc ",")
	end
	|T_output_declaration_reg ( signed , range , port_identifier_equ1_expression_opt_list ) -> begin
		fprintf fc "  output reg ";
		print_signed_opt fc signed;
		print_range fc range;
		list_iter_with_sep port_identifier_equ1_expression_opt_list (print_port_identifier_equ1_expression_opt fc)  (fun () -> fprintf fc ",")
	end
	|T_output_declaration_var ( output_variable_type , port_identifier_equ1_expression_opt_list ) -> begin
		fprintf fc "  output ";
		print_output_variable_type fc output_variable_type;
		list_iter_with_sep port_identifier_equ1_expression_opt_list (print_port_identifier_equ1_expression_opt fc)  (fun () -> fprintf fc ",")
	end
end
and print_port_identifier_equ1_expression_opt fc port_identifier_equ1_expression_opt = begin
	match port_identifier_equ1_expression_opt with
	T_port_identifier_equ1_expression_opt ( port_identifier , equ1_expression_opt ) -> begin
		print_identifier fc port_identifier ;
		match equ1_expression_opt with
		T_expression_NOSPEC -> fprintf fc "";
		| _ -> begin
			fprintf fc " = ";
			print_expression fc equ1_expression_opt
		end
	end
end
and	print_output_variable_type fc output_variable_type = begin
	match output_variable_type with
	T_output_variable_type_INTEGER -> fprintf fc " integer "
	| T_output_variable_type_TIME  -> fprintf fc " time "
end
and print_net_type fc net_type = begin
	match net_type with
	T_net_type_NOSPEC          -> fprintf fc "";      
	| T_net_type__KEY_SUPPLY0  -> fprintf fc " supply0 ";       
	| T_net_type__KEY_SUPPLY1  -> fprintf fc " supply1 ";         
	| T_net_type__KEY_TRI      -> fprintf fc " tri     ";    
	| T_net_type__KEY_TRIAND   -> fprintf fc " triand  ";      
	| T_net_type__KEY_TRIOR    -> fprintf fc " trior   ";      
	| T_net_type__KEY_TRI0     -> fprintf fc " tri0    ";     
	| T_net_type__KEY_TRI1     -> fprintf fc " tri1    ";    
	| T_net_type__KEY_UWIRE    -> fprintf fc " uwire   ";      
	| T_net_type__KEY_WIRE     -> fprintf fc " wire    ";      
	| T_net_type__KEY_WAND     -> fprintf fc " wand    ";       
	| T_net_type__KEY_WOR      -> fprintf fc " wor     ";     
end
and print_generate_region fc generate_region  = begin
	match generate_region with
	T_generate_region ( module_item_list ) -> begin
		List.iter (print_module_item fc) module_item_list
	end
end
and print_parameter_declaration fc parameter_declaration = begin
	match parameter_declaration with
	T_parameter_declaration_1 ( signed , range , param_assignment_list ) -> begin
		fprintf fc "parameter ";
		print_signed_opt fc signed;
		print_range fc range;
		list_iter_with_sep param_assignment_list (print_param_assignment fc) (fun () -> fprintf fc " , ");
		fprintf fc ";\n";
	end
	| T_parameter_declaration_2 ( parameter_type , param_assignment_list ) -> begin
		fprintf fc "parameter ";
		print_parameter_type fc parameter_type;
		list_iter_with_sep param_assignment_list (print_param_assignment fc) (fun () -> fprintf fc " , ");
	end
end
and print_parameter_type fc parameter_type = begin
	match parameter_type with
	T_parameter_type__NOSPEC     -> fprintf fc "";  
	| T_parameter_type__INTEGER  -> fprintf fc " integer  "; 
	| T_parameter_type__REAL     -> fprintf fc " real     ";  
	| T_parameter_type__REALTIME -> fprintf fc " realtime ";  
	| T_parameter_type__TIME     -> fprintf fc " time     "; 
end
and print_net_declaration fc net_declaration = begin	
	match net_declaration with
	  T_net_declaration_net_type3 ( net_type , drive_strength , vectored_scalared , signed , range , delay3 , net_identifier_dimension_list_list ) -> begin
			print_net_type fc net_type ;
			print_drive_strength fc drive_strength;
			print_vectored_scalared fc vectored_scalared;
			print_signed_opt fc signed;
			print_range fc range;
			print_delay3 fc delay3;
			list_iter_with_sep net_identifier_dimension_list_list (print_net_identifier_dimension_list fc) (fun () -> fprintf fc " , ");
			fprintf fc " ;\n";
		end
	| T_net_declaration_net_type4 ( net_type , drive_strength , vectored_scalared , signed , range , delay3 , net_decl_assignment_list ) -> begin
			print_net_type fc net_type ;
			print_drive_strength fc drive_strength;
			print_vectored_scalared fc vectored_scalared;
			print_signed_opt fc signed;
			print_range fc range;
			print_delay3 fc delay3;
			list_iter_with_sep net_decl_assignment_list (print_net_decl_assignment fc) (fun () -> fprintf fc " , ");
			fprintf fc " ;\n";
	end
	| _ -> assert false
end
and print_drive_strength fc drive_strength = begin
	match drive_strength with
	T_drive_strength_NOSPEC -> fprintf fc ""
	| T_drive_strength ( strength1 , strength2 ) -> begin
		fprintf fc " ( ";
		print_strength fc strength1;
		fprintf fc " , ";
		print_strength fc strength2;
		fprintf fc " ) ";
	end
end
and print_strength fc strength = begin
	match strength with
	  KEY_HIGHZ0  -> fprintf fc " highz0  "; 
	| KEY_HIGHZ1  -> fprintf fc " highz1  ";
	| KEY_SUPPLY0	-> fprintf fc " supply0	";  
	| KEY_STRONG0	-> fprintf fc " strong0	";
	| KEY_PULL0	  -> fprintf fc " pull0	  ";	 
	| KEY_WEAK0   -> fprintf fc " weak0   ";
	|	KEY_SUPPLY1	-> fprintf fc " supply1	"; 
	| KEY_STRONG1	-> fprintf fc " strong1	"; 
	| KEY_PULL1		-> fprintf fc " pull1		";  
	| KEY_WEAK1   -> fprintf fc " weak1   "; 
end
and print_vectored_scalared fc vectored_scalared = begin
	match vectored_scalared with
	T_vectored_scalared_NOSPEC    -> fprintf fc ""
	|T_vectored_scalared_vectored -> fprintf fc " vectored "; 
	|T_vectored_scalared_scalared -> fprintf fc " scalared ";
end
and print_delay3 fc delay3 = begin
	match delay3 with
	T_delay3_NOSPEC -> fprintf fc ""
	| T_delay3_1  (  delay_value ) -> begin
			fprintf fc " # ";
			print_delay_value fc delay_value;
		end
	| T_delay3_minmax1 ( mintypmax_expression ) -> 
			fprintf fc " # ( ";
			print_mintypmax_expression fc mintypmax_expression;
			fprintf fc " ) ";
	| T_delay3_minmax2 (  mintypmax_expression1 , mintypmax_expression2 ) -> begin
			fprintf fc " # ( ";
			print_mintypmax_expression fc mintypmax_expression1;
			fprintf fc " , ";
			print_mintypmax_expression fc mintypmax_expression2;
			fprintf fc " ) ";
	end
	| T_delay3_minmax3 ( mintypmax_expression1 , mintypmax_expression2 , mintypmax_expression3 ) -> begin
			fprintf fc " # ( ";
			print_mintypmax_expression fc mintypmax_expression1;
			fprintf fc " , ";
			print_mintypmax_expression fc mintypmax_expression2;
			fprintf fc " , ";
			print_mintypmax_expression fc mintypmax_expression3;
			fprintf fc " ) ";
	end
end
and print_delay_value fc delay_value = begin
	match delay_value with
	T_delay_value_UNSIGNED_NUMBER ( _ , _ , i ) -> fprintf fc " %d " i
	| T_delay_value_REAL_NUMBER ( _ , _ , str ) -> fprintf fc " %s " str
	| T_delay_value_id ( identifier ) -> print_identifier fc identifier
end
and print_net_identifier_dimension_list fc net_identifier_dimension_list = begin
	match net_identifier_dimension_list with
	T_net_identifier_dimension_list ( identifier , dimension_list ) -> begin
		print_identifier fc identifier;
		List.iter (print_dimension fc) dimension_list ;
	end
end
and print_dimension fc dimension = begin
	match dimension with
	T_dimension ( expression1 , expression2 ) -> begin
		fprintf fc " [ ";
			print_expression fc expression1;
		fprintf fc " : ";
			print_expression fc expression2;
		fprintf fc " ] ";
	end
end
and print_net_decl_assignment fc net_decl_assignment = begin
	match net_decl_assignment with
	T_net_decl_assignment ( identifier , expression ) -> begin
		print_identifier fc identifier;
		fprintf fc " = ";
		print_expression fc expression;
	end
end
and print_reg_declaration fc reg_declaration = begin
	match reg_declaration with
	T_reg_declaration ( signed , range , variable_type_list ) -> begin
		fprintf fc " reg " ;
		print_signed_opt fc signed;
		print_range fc range ;
		list_iter_with_sep variable_type_list (print_variable_type fc) (fun () -> fprintf fc " , ");
		fprintf fc " ;\n"
	end
end
and print_variable_type fc variable_type = begin
	match variable_type with
	T_variable_type_noass ( identifier , dimension_list ) -> begin
		print_identifier fc identifier;
		List.iter (print_dimension fc) dimension_list
	end
	| T_variable_type_ass ( identifier , expression ) -> begin
		print_identifier fc identifier;
		fprintf fc " = " ;
		print_expression fc expression
	end
end
and print_integer_declaration fc integer_declaration = begin
	match integer_declaration with
	T_integer_declaration ( variable_type_list ) -> begin
		fprintf fc " integer ";
		list_iter_with_sep variable_type_list (print_variable_type fc) (fun () -> fprintf fc " , ");
		fprintf fc " ;\n"
	end
end
and print_real_declaration fc real_declaration = begin
	match real_declaration with
	T_real_declaration ( real_type_list ) -> begin
		fprintf fc " real ";
		list_iter_with_sep real_type_list (print_real_type fc) (fun () -> fprintf fc " , ");
		fprintf fc " ;\n"
	end
end
and print_real_type fc real_type = begin
	match real_type with
	T_real_type_noass ( identifier , dimension_list ) -> begin
		print_identifier fc identifier;
		List.iter (print_dimension fc) dimension_list;
	end
	| T_real_type_ass ( identifier , expression ) -> begin
		print_identifier fc identifier;
		fprintf fc " = ";
		print_expression fc expression
	end
end
