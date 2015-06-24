open Intlist
open Printf

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



let compose f g = function x -> f(g(x));;

let print_v_printlst voutch lst dofunc sepfunc = begin
	match lst with
	[]	->	()
	| head::tail -> begin
		dofunc voutch head ;
		List.iter (compose (dofunc voutch) (sepfunc voutch) ) tail
	end
end
;;

let print_dot voutch a = begin
	fprintf voutch ".";
	flush stdout;
	a
end
;;

let print_comma voutch a = begin
  fprintf voutch " , ";
  flush stdout;
  a
end
;;

let print_comma_endline voutch a = begin
	fprintf voutch " , \n";
	flush stdout;
	a
end
;;

let print_or voutch a = begin
	fprintf voutch " or ";
	flush stdout;
	a
end
;;
let print_simplyendline voutch a = begin
	fprintf voutch  "";
	flush stdout;
	a
end
;;
let rec exp2int_simple exp = begin
	match exp with
	T_primary(prim) -> prim2int_simple prim
	| T_add1(prim) -> prim2int_simple prim
	| T_sub1(prim) -> -1*(prim2int_simple prim)
	| T_add2(expl,expr) -> (exp2int_simple expl)+(exp2int_simple expr)
	| T_sub2(expl,expr) -> (exp2int_simple expl)-(exp2int_simple expr)
	| T_mul2(expl,expr) -> (exp2int_simple expl)*(exp2int_simple expr)
	| _ -> begin
		Printf.printf "fatal error : exp2int_simple not proper\n";
		exit 1
	end
end
and exp2lv exp =begin
	match exp with 
	T_primary(T_primary_id(idlst)) -> T_lvalue_id(idlst)
	| T_primary(T_primary_concat(explst)) -> T_lvalue_concat(explst)
	| T_primary(T_primary_arrbit(idlst,exp)) -> T_lvalue_arrbit(idlst,exp)
	| T_primary(T_primary_arrrange(idlst,exp1,exp2)) -> T_lvalue_arrrange(idlst,exp1,exp2)
	| T_expression_NOSPEC(nn) -> begin
		Printf.printf "fatal error : exp2lv not support T_expression_NOSPEC(%d)\n" nn;
		exit 1
	end
	| _ -> begin
		Printf.printf "fatal error : exp2lv not support such expr format \n";
		print_v_expression stdout exp;
		exit 1
	end
end
and prim2int_simple prim = begin
	match prim with
	T_primary_num(num) -> num2int_simple num
	| T_primary_minmaxexp(T_mintypmax_expression_1(exp)) -> exp2int_simple exp
	| _ -> begin
		Printf.printf "fatal error : prim2int_simple not proper\n";
		exit 1
	end
end
and num2int_simple num = begin
	match num with
	T_number_unsign(i) -> i
	| _ -> begin
		Printf.printf "fatal error : num2int_simple not proper\n";
		exit 1
	end
end
and dep_statement stat = begin
	let lst = begin
	match stat with
	T_blocking_assignment(ba) -> begin
		match ba with
		T_blocking_assignment_direct(_,exp) -> dep_expression exp
		| T_blocking_assignment_delay(_,exp,_) -> dep_expression exp
		| T_blocking_assignment_event(_,exp,_) -> dep_expression exp
	end
	| T_non_blocking_assignment(nba) -> begin
		match nba with
		T_non_blocking_assignment_direct(_,exp) -> dep_expression exp
		| T_non_blocking_assignment_delay(_,exp,_) -> dep_expression exp
		| T_non_blocking_assignment_event(_,exp,_) -> dep_expression exp
	end
	| T_if_statement(exp,stat) -> 
		(dep_expression exp) @ (dep_statement stat)
	| T_if_else_statement(exp,stat1,stat2) -> 
		(dep_expression exp) @ (dep_statement stat1) @ (dep_statement stat2)
	| T_case_statement(exp,cilst) -> 
		(dep_expression exp) @ (List.concat (List.map dep_ci cilst))
	| T_seq_block(_,_,statlst) -> 
		List.concat (List.map dep_statement statlst)
	| _ -> begin
		Printf.printf "fatal error : not supported dep_statement\n";
		exit 1
	end
	(*| T_statement_NOSPEC
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
	| T_delay_statement of delay_control*statement*)
	end
	in
	listUniq lst
end
and dep_expression exp = begin
	let lst = begin
	match exp with
	T_primary(prim) -> dep_prim prim
	| T_primary_4arrayassign(_) -> assert false
	| T_add1(prim) -> dep_prim prim
	| T_sub1(prim) -> dep_prim prim
	| T_logicneg(prim) -> dep_prim prim
	| T_bitneg(prim) -> dep_prim prim
	| T_reduce_and(prim) -> dep_prim prim
	| T_reduce_nand(prim) -> dep_prim prim
	| T_reduce_or(prim) -> dep_prim prim
	| T_reduce_nor(prim) -> dep_prim prim
	| T_reduce_xor(prim) -> dep_prim prim
	| T_reduce_xnor(prim) -> dep_prim prim
	| T_add2(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_sub2(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_mul2(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_div(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_mod(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_logic_equ(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_logic_ine(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_case_equ(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_case_ine(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_logic_and2(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_logic_or2(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_lt(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_le(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_gt(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_ge(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_bit_and2(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_bit_or2(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_bit_xor2(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_bit_equ(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_leftshift(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_rightshift(exp1,exp2) -> (dep_expression exp1) @ (dep_expression exp2)
	| T_selection(exp1,exp2,exp3) -> (dep_expression exp1) @ (dep_expression exp2) @ (dep_expression exp3)
	| T_string(_) -> []
	| T_expression_NOSPEC(_) -> []
	end
	in
	listUniq lst
end
and dep_prim prim =begin
	let lst = begin
	match prim with
	T_primary_num(_) -> []
	| T_primary_id([str]) -> [str]
	| T_primary_arrbit([str],exp) -> str::(dep_expression exp)
	| T_primary_arrrange([str],exp1,exp2) -> (str::(dep_expression exp1))@(dep_expression exp2)
	| T_primary_concat(explst) -> List.concat (List.map dep_expression explst)
	| T_primary_multiconcat(exp,explst) -> List.concat (List.map dep_expression explst)
	| _ ->  begin
		Printf.printf "fatal error : not supported dep_prim\n";
		exit 1
	end
	(*| T_primary_funcall of (string list)*(expression list)
	| T_primary_sysfuncall of (string list)*(expression list)
	| T_primary_minmaxexp of mintypmax_expression*)
	end
	in
	listUniq lst
end
and dep_ci ci = begin
	match ci with
	T_case_item_normal(explst,stat) -> (List.concat (List.map dep_expression explst))@(dep_statement stat)
	| T_case_item_default(stat) -> dep_statement stat
end
and statement2regnamelist stat = begin
	let lst= begin
	match stat with
	T_blocking_assignment(blkass) -> blocking_assignment2regnamelist blkass
	| T_non_blocking_assignment(nba) -> non_blocking_assignment2regnamelist nba
	| T_if_statement(_,statif) -> statement2regnamelist statif
	| T_if_else_statement(_,statif,statelse) -> (statement2regnamelist statif) @ (statement2regnamelist statelse)
	| T_case_statement(_,cilst) -> List.concat (List.map ci2reglist cilst)
	| T_seq_block(_,_,statlst) -> List.concat (List.map statement2regnamelist statlst)
	| T_statement_NOSPEC -> []
	| _ -> begin
		Printf.printf "fatal error : not supported statement2regnamelist\n";
		exit 1
	end
	(*| T_forever_statement of statement
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
	| T_delay_statement of delay_control*statement*)
	end
	in listUniq lst
end
and blocking_assignment2regnamelist blkass = begin
	let lst= begin
	match blkass with
	T_blocking_assignment_direct(lv,_) -> lv2regnamelist lv
	| T_blocking_assignment_delay(lv,_,_) -> lv2regnamelist lv
	| T_blocking_assignment_event(lv,_,_) -> lv2regnamelist lv
	end
	in listUniq lst
end
and lv2regnamelist lv = begin
	let lst= begin
	match lv with
	T_lvalue_id(id) -> [id2string id]
	| T_lvalue_arrbit(id,_) -> [id2string id]
	| T_lvalue_arrrange(id,_,_) -> [id2string id]
	| T_lvalue_concat(explst) -> List.concat (List.map exp2reglist explst)
	end
	in listUniq lst
end
and exp2reglist exp = begin
	let lst= begin
	match exp with
	T_primary(prim) -> prim2reglist prim
	| _ -> begin
		Printf.printf "fatal error : only prim can be used as lv";
		exit 1
	end
	end
	in listUniq lst
end
and prim2reglist prim = begin
	let lst= begin
	match prim with
	T_primary_id(id) -> [id2string id]
	| T_primary_arrbit(id,_) -> [id2string id]
	| T_primary_arrrange(id,_,_) -> [id2string id]
	| T_primary_concat(explst) ->  List.concat (List.map exp2reglist explst)
	| _ -> begin
		Printf.printf "fatal error : not supported lv";
		exit 1
	end
	end
	in listUniq lst
end
and non_blocking_assignment2regnamelist nba = begin
	let lst= begin
	match nba with
	T_non_blocking_assignment_direct(lv,_) -> lv2regnamelist lv
	| T_non_blocking_assignment_delay(lv,_,_) -> lv2regnamelist lv
	| T_non_blocking_assignment_event(lv,_,_) -> lv2regnamelist lv
	end
	in listUniq lst
end
and ci2reglist ci = begin
	let lst= begin
	match ci with
	T_case_item_normal(_,stat) -> statement2regnamelist stat
	| T_case_item_default(stat) -> statement2regnamelist stat
	end
	in listUniq lst
end
and id2string strlst = begin
	String.concat "/" strlst
end
and extract_idlst_from_prim prim = begin
		match prim with 
		T_primary_num(_) -> []
		| T_primary_id(id) -> [id]
		| T_primary_arrbit(id,exp1) -> [id]@(extract_idlst_from_exp exp1)
		| T_primary_arrrange(id,exp1,exp2) -> [id]@(extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_primary_concat(epxlst) -> List.concat (List.map (extract_idlst_from_exp) epxlst)
		| T_primary_multiconcat(exp,epxlst) -> (extract_idlst_from_exp exp) @ (List.concat (List.map (extract_idlst_from_exp) epxlst))
		| T_primary_funcall(_,explst) -> List.concat (List.map (extract_idlst_from_exp) explst)
		| T_primary_sysfuncall(_,explst) -> List.concat (List.map (extract_idlst_from_exp) explst)
		| T_primary_minmaxexp(minmaxexp) -> begin
			match minmaxexp with
			T_mintypmax_expression_1(exp1) -> extract_idlst_from_exp exp1
			| T_mintypmax_expression_3(exp1,exp2,exp3) -> (extract_idlst_from_exp exp1) @ (extract_idlst_from_exp exp2) @ (extract_idlst_from_exp exp3)
		end
end
and extract_idlst_from_exp exp = begin
		match exp with
		T_primary(prim) -> extract_idlst_from_prim prim
		| T_primary_4arrayassign(arrayassignlist) -> begin
			let arrass2exp aahd = match aahd with T_arrayassign(_,_,exparrass) -> exparrass
			in
			let explst=(List.map arrass2exp arrayassignlist)
			in
			List.concat (List.map (extract_idlst_from_exp) explst)
		end
		| T_add1(prim) -> extract_idlst_from_prim prim
		| T_sub1(prim) -> extract_idlst_from_prim prim
		| T_logicneg(prim) -> extract_idlst_from_prim prim
		| T_bitneg(prim) -> extract_idlst_from_prim prim
		| T_reduce_and(prim) -> extract_idlst_from_prim prim
		| T_reduce_nand(prim) -> extract_idlst_from_prim prim
		| T_reduce_or(prim) -> extract_idlst_from_prim prim
		| T_reduce_nor(prim) -> extract_idlst_from_prim prim
		| T_reduce_xor(prim) -> extract_idlst_from_prim prim
		| T_reduce_xnor(prim) -> extract_idlst_from_prim prim
		| T_add2(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_sub2(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_mul2(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_div(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_mod(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_logic_equ(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_logic_ine(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_case_equ(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_case_ine(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_logic_and2(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_logic_or2(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_lt(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_le(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_gt(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_ge(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_bit_and2(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_bit_or2(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_bit_xor2(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_bit_equ(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_leftshift(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_rightshift(exp1,exp2) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)
		| T_selection(exp1,exp2,exp3) -> (extract_idlst_from_exp exp1)@(extract_idlst_from_exp exp2)@(extract_idlst_from_exp exp3)
		| T_string(_) -> []
		| T_expression_NOSPEC(_) -> []
end
and extract_var_from_eventexp evexp = begin
	match evexp with
	T_event_expression(exp) -> extract_idlst_from_exp exp
	| T_event_expression_posedge(exp) -> extract_idlst_from_exp exp
	| T_event_expression_negedge(exp) -> extract_idlst_from_exp exp
end
and suggest_name_for_prim prim = begin
		match prim with 
		T_primary_num(_) -> []
		| T_primary_id(id) -> [id]
		| T_primary_arrbit(id,exp1) -> [id]@(suggest_name_for_exp exp1)
		| T_primary_arrrange(id,exp1,exp2) -> [id]@(suggest_name_for_exp exp1)@(suggest_name_for_exp exp2)
		| T_primary_concat(epxlst) -> List.concat (List.map (suggest_name_for_exp) epxlst)
		| T_primary_multiconcat(exp,epxlst) -> (suggest_name_for_exp exp) @ (List.concat (List.map (suggest_name_for_exp) epxlst))
		| T_primary_funcall(_,explst) -> List.concat (List.map (suggest_name_for_exp) explst)
		| T_primary_sysfuncall(_,explst) -> List.concat (List.map (suggest_name_for_exp) explst)
		| T_primary_minmaxexp(minmaxexp) -> begin
			match minmaxexp with
			T_mintypmax_expression_1(exp1) -> suggest_name_for_exp exp1
			| T_mintypmax_expression_3(exp1,exp2,exp3) -> (suggest_name_for_exp exp1) @ (suggest_name_for_exp exp2) @ (suggest_name_for_exp exp3)
		end
end
and suggest_name_for_exp exp = begin
		match exp with
		T_primary(prim) -> suggest_name_for_prim prim
		| T_primary_4arrayassign(arrayassignlist) -> begin
			let arrass2exp aahd = match aahd with T_arrayassign(_,_,exparrass) -> exparrass
			in
			let explst=(List.map arrass2exp arrayassignlist)
			in
			List.concat (List.map (suggest_name_for_exp) explst)
		end
		| T_add1(prim) -> [["positive"]]@(suggest_name_for_prim prim)
		| T_sub1(prim) -> [["negative"]]@(suggest_name_for_prim prim)
		| T_logicneg(prim) -> [["ln"]]@(suggest_name_for_prim prim)
		| T_bitneg(prim) -> [["bn"]]@(suggest_name_for_prim prim)
		| T_reduce_and(prim) -> [["redand"]]@(suggest_name_for_prim prim)
		| T_reduce_nand(prim) -> [["rednand"]]@(suggest_name_for_prim prim)
		| T_reduce_or(prim) -> [["redor"]]@(suggest_name_for_prim prim)
		| T_reduce_nor(prim) -> [["rednor"]]@(suggest_name_for_prim prim)
		| T_reduce_xor(prim) -> [["redxor"]]@(suggest_name_for_prim prim)
		| T_reduce_xnor(prim) -> [["redxnor"]]@(suggest_name_for_prim prim)
		| T_add2(exp1,exp2) -> (suggest_name_for_exp exp1)@[["add"]]@(suggest_name_for_exp exp2)
		| T_sub2(exp1,exp2) -> (suggest_name_for_exp exp1)@[["sub"]]@(suggest_name_for_exp exp2)
		| T_mul2(exp1,exp2) -> (suggest_name_for_exp exp1)@[["mul"]]@(suggest_name_for_exp exp2)
		| T_div(exp1,exp2) -> (suggest_name_for_exp exp1)@[["div"]]@(suggest_name_for_exp exp2)
		| T_mod(exp1,exp2) -> (suggest_name_for_exp exp1)@[["mod"]]@(suggest_name_for_exp exp2)
		| T_logic_equ(exp1,exp2) -> (suggest_name_for_exp exp1)@[["le"]]@(suggest_name_for_exp exp2)
		| T_logic_ine(exp1,exp2) -> (suggest_name_for_exp exp1)@[["lie"]]@(suggest_name_for_exp exp2)
		| T_case_equ(exp1,exp2) -> (suggest_name_for_exp exp1)@[["ce"]]@(suggest_name_for_exp exp2)
		| T_case_ine(exp1,exp2) -> (suggest_name_for_exp exp1)@[["cie"]]@(suggest_name_for_exp exp2)
		| T_logic_and2(exp1,exp2) -> (suggest_name_for_exp exp1)@[["land2"]]@(suggest_name_for_exp exp2)
		| T_logic_or2(exp1,exp2) -> (suggest_name_for_exp exp1)@[["lor2"]]@(suggest_name_for_exp exp2)
		| T_lt(exp1,exp2) -> (suggest_name_for_exp exp1)@[["lt"]]@(suggest_name_for_exp exp2)
		| T_le(exp1,exp2) -> (suggest_name_for_exp exp1)@[["le"]]@(suggest_name_for_exp exp2)
		| T_gt(exp1,exp2) -> (suggest_name_for_exp exp1)@[["gt"]]@(suggest_name_for_exp exp2)
		| T_ge(exp1,exp2) -> (suggest_name_for_exp exp1)@[["ge"]]@(suggest_name_for_exp exp2)
		| T_bit_and2(exp1,exp2) -> (suggest_name_for_exp exp1)@[["band2"]]@(suggest_name_for_exp exp2)
		| T_bit_or2(exp1,exp2) -> (suggest_name_for_exp exp1)@[["bor2"]]@(suggest_name_for_exp exp2)
		| T_bit_xor2(exp1,exp2) -> (suggest_name_for_exp exp1)@[["bxor2"]]@(suggest_name_for_exp exp2)
		| T_bit_equ(exp1,exp2) -> (suggest_name_for_exp exp1)@[["be"]]@(suggest_name_for_exp exp2)
		| T_leftshift(exp1,exp2) -> (suggest_name_for_exp exp1)@[["ls"]]@(suggest_name_for_exp exp2)
		| T_rightshift(exp1,exp2) -> (suggest_name_for_exp exp1)@[["rs"]]@(suggest_name_for_exp exp2)
		| T_selection(exp1,exp2,exp3) -> [["sel"]]@(suggest_name_for_exp exp1)@(suggest_name_for_exp exp2)@(suggest_name_for_exp exp3)
		| T_string(_) -> []
		| T_expression_NOSPEC(_) -> []
end
and uniquify_idlst idlst = begin
	match idlst with
	hdid::tailidlst -> begin
		if (List.exists (fun x ->  (String.concat "/" x)=(String.concat "/" hdid) ) tailidlst)  then (uniquify_idlst tailidlst)
		else hdid::(uniquify_idlst tailidlst)
	end
	| [] -> []
end
and idequ id1 id2 = begin
	let str1 = get_str_from_strlst id1
	and str2 = get_str_from_strlst id2
	in
	if str1 = str2 then true
	else false
end
and get_lvidlst_from_always_comb stm = begin
	let res= begin
		match stm with 
		T_blocking_assignment(ba) -> begin
			match ba with
			T_blocking_assignment_direct(lv,exp) -> lvalue2idlst lv
			| _ -> begin
				Printf.printf "fatal error: get_lvidlst_from_always_comb currently unsupported complex blocking_assignment \n";
				print_v_statement stdout stm;
				exit 1
			end
		end
		| T_non_blocking_assignment(nba) -> begin
			Printf.printf "warning:currently unsupported non blocking assignment in comb logic declaration\n";
			print_v_statement stdout stm;
			match nba with
			T_non_blocking_assignment_direct(lv,exp) -> lvalue2idlst lv
			| _ -> begin
				Printf.printf "fatal error: get_lvidlst_from_always_comb currently unsupported complex non_blocking_assignment\n";
				print_v_statement stdout stm;
				exit 1
			end
		end
		| T_if_statement(exp,stat) -> 
			get_lvidlst_from_always_comb stat
		| T_if_else_statement(exp,stat1,stat2) -> 
			(get_lvidlst_from_always_comb stat1)@(get_lvidlst_from_always_comb stat2)
		| T_case_statement(expcaseold,cilst) -> 
			List.concat (List.map (get_lvidlst_from_always_comb) (List.map caseitem2stm cilst))
		| T_casex_statement(expcaseold,cilst) -> 
			List.concat (List.map (get_lvidlst_from_always_comb) (List.map caseitem2stm cilst))
		| T_casez_statement(expcaseold,cilst) -> 
			List.concat (List.map (get_lvidlst_from_always_comb) (List.map caseitem2stm cilst))
		| T_seq_block(str,milst,statlst) -> begin
			if (List.length milst) > 0 then begin
				Printf.printf "fatal error: get_lvidlst_from_always_comb unsuopported mi declaration in always";
				exit 1
			end
			;
			List.concat (List.map (get_lvidlst_from_always_comb) statlst)
		end
		| T_statement_NOSPEC -> []
		| T_for_statement(ass1,expstep,ass2,stmtfor) -> begin
			get_lvidlst_from_always_comb stmtfor
		end
		| _ -> begin
			Printf.printf "fatal error: get_lvidlst_from_always_comb improper statement in always elab_always_comblogic";
			exit 1
		end
	end
	in uniquify_idlst res
end
and get_depidlst_from_always_comb stm = begin
	let res= begin
		match stm with 
		T_blocking_assignment(ba) -> begin
			match ba with
			T_blocking_assignment_direct(lv,exp) -> begin
				match lv with
				T_lvalue_arrbit(_,expidx) -> (extract_idlst_from_exp expidx)@(extract_idlst_from_exp exp)
				| T_lvalue_arrrange(_,expidx1,expidx2) -> (extract_idlst_from_exp expidx1)@(extract_idlst_from_exp expidx2)@(extract_idlst_from_exp exp)
				| T_lvalue_concat(explst) -> (List.concat (List.map extract_idlst_from_exp explst))@(extract_idlst_from_exp exp)
				| _ -> []
			end
			| _ -> begin
				Printf.printf "fatal error: get_depidlst_from_always_comb currently unsupported complex blocking_assignment \n";
				print_v_statement stdout stm;
				exit 1
			end
		end
		| T_non_blocking_assignment(nba) -> begin
			match nba with
			T_non_blocking_assignment_direct(lv,exp) -> begin
				match lv with
				T_lvalue_arrbit(_,expidx) -> (extract_idlst_from_exp expidx)@(extract_idlst_from_exp exp)
				| T_lvalue_arrrange(_,expidx1,expidx2) -> (extract_idlst_from_exp expidx1)@(extract_idlst_from_exp expidx2)@(extract_idlst_from_exp exp)
				| T_lvalue_concat(explst) -> (List.concat (List.map extract_idlst_from_exp explst))@(extract_idlst_from_exp exp)
				| _ -> []
			end
			| _ -> begin
				Printf.printf "fatal error: get_depidlst_from_always_comb currently unsupported complex non_blocking_assignment\n";
				print_v_statement stdout stm;
				exit 1
			end
		end
		| T_if_statement(exp,stat) -> 
			(get_depidlst_from_always_comb stat)@(extract_idlst_from_exp exp)
		| T_if_else_statement(exp,stat1,stat2) -> 
			(get_depidlst_from_always_comb stat1)@(get_depidlst_from_always_comb stat2)@(extract_idlst_from_exp exp)
		| T_case_statement(expcaseold,cilst) -> 
			(List.concat (List.map (get_depidlst_from_always_comb) (List.map caseitem2stm cilst)))@(extract_idlst_from_exp expcaseold)
		| T_casex_statement(expcaseold,cilst) -> 
			List.concat (List.map (get_depidlst_from_always_comb) (List.map caseitem2stm cilst))@(extract_idlst_from_exp expcaseold)
		| T_casez_statement(expcaseold,cilst) -> 
			List.concat (List.map (get_depidlst_from_always_comb) (List.map caseitem2stm cilst))@(extract_idlst_from_exp expcaseold)
		| T_seq_block(str,milst,statlst) -> begin
			if (List.length milst) > 0 then begin
				Printf.printf "fatal error: get_depidlst_from_always_comb unsuopported mi declaration in always";
				exit 1
			end
			;
			List.concat (List.map (get_depidlst_from_always_comb) statlst)
		end
		| T_statement_NOSPEC -> []
		| T_for_statement(ass1,expstep,ass2,stmtfor) -> begin
			get_depidlst_from_always_comb stmtfor
		end
		| _ -> begin
			Printf.printf "fatal error: get_depidlst_from_always_comb improper statement in always elab_always_comblogic";
			exit 1
		end
	end
	in uniquify_idlst res
end
and is_pure_nonblocking_assignment stm = begin
	match stm with 
	T_blocking_assignment(_) -> false
	| T_non_blocking_assignment(_) -> true
	| T_if_statement(exp,stat) -> is_pure_nonblocking_assignment stat
	| T_if_else_statement(exp,stat1,stat2) -> 
		if (is_pure_nonblocking_assignment stat1) && (is_pure_nonblocking_assignment stat2) then true else false
	| T_case_statement(expcaseold,cilst) -> 
		List.for_all is_pure_nonblocking_assignment (List.map caseitem2stm cilst)
	| T_casex_statement(expcaseold,cilst) -> 
		List.for_all is_pure_nonblocking_assignment (List.map caseitem2stm cilst)
	| T_casez_statement(expcaseold,cilst) -> 
		List.for_all is_pure_nonblocking_assignment (List.map caseitem2stm cilst)
	| T_seq_block(str,milst,statlst) -> 
		List.for_all is_pure_nonblocking_assignment statlst
	| T_statement_NOSPEC -> true
	| T_for_statement(ass1,expstep,ass2,stmtfor) -> begin
		is_pure_nonblocking_assignment stmtfor
	end
	| _ -> begin
		Printf.printf "fatal error: is_pure_nonblocking_assignment improper statement in always elab_always_comblogic";
		exit 1
	end
end
and is_pure_blocking_assignment stm = begin
	match stm with 
	T_blocking_assignment(_) -> true
	| T_non_blocking_assignment(_) -> false
	| T_if_statement(exp,stat) -> is_pure_blocking_assignment stat
	| T_if_else_statement(exp,stat1,stat2) -> 
		if (is_pure_blocking_assignment stat1) && (is_pure_blocking_assignment stat2) then true else false
	| T_case_statement(expcaseold,cilst) -> 
		List.for_all is_pure_blocking_assignment (List.map caseitem2stm cilst)
	| T_casex_statement(expcaseold,cilst) -> 
		List.for_all is_pure_blocking_assignment (List.map caseitem2stm cilst)
	| T_casez_statement(expcaseold,cilst) -> 
		List.for_all is_pure_blocking_assignment (List.map caseitem2stm cilst)
	| T_seq_block(str,milst,statlst) -> 
		List.for_all is_pure_blocking_assignment statlst
	| T_statement_NOSPEC -> true
	| T_for_statement(ass1,expstep,ass2,stmtfor) -> begin
		is_pure_blocking_assignment stmtfor
	end
	| _ -> begin
		Printf.printf "fatal error: is_pure_blocking_assignment improper statement in always elab_always_comblogic";
		exit 1
	end
end
and is_write_after_read  stm  = begin
		match stm with 
		T_blocking_assignment(ba) -> false
		| T_non_blocking_assignment(nba) -> false
		| T_if_statement(exp,stat) -> begin
			let rlst = extract_idlst_from_exp exp
			and wlst = get_lvidlst_from_always_comb stat
			in
			if (is_idlst_intersect rlst wlst) then true
			else false
		end
		| T_if_else_statement(exp,stat1,stat2) -> begin
			let rlst = extract_idlst_from_exp exp
			and wlst = (get_lvidlst_from_always_comb stat1)@(get_lvidlst_from_always_comb stat2)
			in
			if (is_idlst_intersect rlst wlst) then true
			else false
		end
		| T_case_statement(expcaseold,cilst) -> begin
			let rlst = extract_idlst_from_exp expcaseold
			and wlst =  List.concat (List.map get_lvidlst_from_always_comb (List.map caseitem2stm cilst))
			in
			if (is_idlst_intersect rlst wlst) then true
			else false
		end
		| T_casex_statement(expcaseold,cilst) -> begin
			let rlst = extract_idlst_from_exp expcaseold
			and wlst =  List.concat (List.map get_lvidlst_from_always_comb (List.map caseitem2stm cilst))
			in
			if (is_idlst_intersect rlst wlst) then true
			else false
		end
		| T_casez_statement(expcaseold,cilst) -> begin
			let rlst = extract_idlst_from_exp expcaseold
			and wlst =  List.concat (List.map get_lvidlst_from_always_comb (List.map caseitem2stm cilst))
			in
			if (is_idlst_intersect rlst wlst) then true
			else false
		end
		| T_seq_block(str,milst,statlst) -> begin
			match statlst with
			[] -> false
			| hdstat::tailstatlst -> begin
				let wlst=get_lvidlst_from_always_comb (T_seq_block("",[],tailstatlst))
				and rlst=get_depidlst_from_always_comb hdstat
				in
				if (is_idlst_intersect rlst wlst) then true
				else is_write_after_read (T_seq_block("",[],tailstatlst))
			end
		end
		| T_statement_NOSPEC -> false
		| T_for_statement(ass1,expstep,ass2,stmtfor) -> begin
			is_write_after_read stmtfor
		end
		| _ -> begin
			Printf.printf "fatal error: is_write_after_read improper statement in always elab_always_comblogic";
			exit 1
		end
end
and idlst_intersect idlst1 idlst2 = begin
	let in2 id = begin
		if List.exists (idequ id) idlst2 then true
		else false
	end
	in
	List.filter in2 idlst1
end
and is_idlst_intersect idlst1 idlst2 = begin
	if (List.length (idlst_intersect idlst1 idlst2)) > 0 then true
	else false
end
and get_str_from_strlst strlst = begin
	String.concat "/" strlst
end
and gen_list_from_interval idxlft idxrgt = begin
	if idxlft = idxrgt then [idxrgt]
	else if idxlft > idxrgt then idxlft::(gen_list_from_interval (idxlft-1) idxrgt)
	else idxlft::(gen_list_from_interval (idxlft+1) idxrgt)
end
and gen_list_from_interval_step idxlft idxrgt step= begin (*interval means from idxlft idxrgt-1 or +1, dont make them equal*)
	if idxlft = idxrgt then []
	else if idxlft > idxrgt then begin
		if (idxlft-step) > idxrgt then idxlft::(gen_list_from_interval_step (idxlft-step) idxrgt step)
		else [idxlft]
	end
	else begin
		if (idxlft+step) < idxrgt then idxlft::(gen_list_from_interval_step (idxlft+step) idxrgt step)
		else [idxlft]
	end
end
(*arithmetic related function*)
and hex2bin c = begin
	match c with
	'0'  -> "0000"
	| '1' -> "0001"
	| '2' -> "0010"
	| '3' -> "0011"
	| '4' -> "0100"
	| '5' -> "0101"
	| '6' -> "0110"
	| '7' -> "0111"
	| '8' -> "1000"
	| '9' -> "1001"
	| 'A' -> "1010"
	| 'B' -> "1011"
	| 'C' -> "1100"
	| 'D' -> "1101"
	| 'E' -> "1110"
	| 'F' -> "1111"
	| 'a' -> "1010"
	| 'b' -> "1011"
	| 'c' -> "1100"
	| 'd' -> "1101"
	| 'e' -> "1110"
	| 'f' -> "1111"
	| 'x' -> begin
		Printf.printf  "fatal error : invalid char to converted to bin %c\n" c;
		"xxxx"
	end
	| 'X' -> begin
		Printf.printf  "fatal error : invalid char to converted to bin %c\n" c;
		"xxxx"
	end
	| _ -> begin
		Printf.printf  "fatal error : invalid char to converted to bin %c\n" c;
		exit 1
	end
end
and hexstring2binstring strg = begin
	Printf.printf  " hexstring2binstring : %s\n" strg ;
	if (String.length strg)==1 then (hex2bin (String.get strg 0))
	else String.concat "" [(hex2bin (String.get strg 0)) ; (hexstring2binstring (String.sub strg 1 ((String.length strg)-1)))]
end
and int2bin i = begin(*notice that the order is reversed*)
	if i=0 then ["0"]
	else if i=1 then ["1"]
	else if (i mod 2)=1 then ("1")::(int2bin (i/2))
	else ("0")::(int2bin (i/2))
end
and int2exp_width i w= begin
	let strg=String.concat "" (List.rev (int2bin i))
	in let lenstrg=String.length strg
	in begin
		if lenstrg > w then T_primary(T_primary_num(T_number_base(w,'b',(String.sub strg (lenstrg-w) w))))
		else if lenstrg < w then T_primary(T_primary_num(T_number_base(w,'b',(String.concat "" ((String.make (w-lenstrg) '0')::[strg])) )))
		else T_primary(T_primary_num(T_number_base(w,'b',strg)))
	end
end
and intconst2exp i = T_primary(T_primary_num(T_number_unsign(i)))
and decstring2binstring strg = begin
	try 
		let dec = int_of_string strg
		in
		String.concat "" (List.rev (int2bin dec))
	with int_of_string -> begin
		Printf.printf "fatal error : invalid int_of_string %s\n" strg;
		exit 1
	end
end
and lvalue2idlst lv = begin
	match lv with 
	T_lvalue_id(id) ->[id]
	| T_lvalue_arrbit(id,_) -> [id]
	| T_lvalue_arrrange(id,_,_) -> [id]
	| T_lvalue_concat(explst) -> List.concat (List.map extract_idlst_from_exp explst)
end
and binstring2int num = begin
	if (String.length num) > 0 then begin
		let left = (binstring2int (String.sub num 0 ((String.length num)-1)))
		in 
		match (String.get num ((String.length num)-1)) with
		'0' -> left*2
		| '1' -> (left*2)+1
		| _ ->  begin
			Printf.printf "fatal error: improper num %s\n" num;
			exit 1
		end
	end
	else 0
end
and get1b0 = T_primary(T_primary_num(T_number_base(1,'b',"0")))
and get1b1 = T_primary(T_primary_num(T_number_base(1,'b',"1")))
and is_true exp = begin
	match exp with 
	T_primary(T_primary_id(["Predicate_true"])) -> true
	| T_primary(T_primary_num(T_number_base(1,'b',"1"))) -> true
	| T_primary(T_primary_minmaxexp(T_mintypmax_expression_1(expmm))) -> is_true expmm
	| _ -> false
end
and is_false exp = begin
	match exp with 
	T_primary(T_primary_id(["Predicate_false"])) -> true
	| T_primary(T_primary_num(T_number_base(1,'b',"0"))) -> true
	| T_primary(T_primary_minmaxexp(T_mintypmax_expression_1(expmm))) -> is_false expmm
	| _ -> false
end
and caseitem2stm ci = begin
	match ci with
	T_case_item_normal(_,stm) -> stm
	| T_case_item_default(stm) -> stm
end
and get_rng_width rng = begin
	match rng with
	T_range_int(lft,rgt) -> if lft > rgt then (lft - rgt + 1) else (rgt - lft + 1)
	| T_range_NOSPEC -> 1
	| T_range(expl,expr) -> 
		get_rng_width (T_range_int((exp2int_simple expl),(exp2int_simple expr)))
end
and is_T_parameter_declaration mi = begin
	match mi with 
	T_parameter_declaration(_) -> true
	| _ -> false
end
and get_int_bits_as_prim ivalue left right = begin
	if left >= right then begin
		let mask=(1 lsl (left-right+1))-1
		and tor=ivalue lsr right
		in
		let ssy=int2exp_width (mask land tor) (left-right+1)
		in
		match ssy with 
		T_primary(prim) -> prim
		| _ -> begin
			Printf.printf "fatal error: improper result from int2exp_width\n";
			exit 1
		end
	end
	else begin
		Printf.printf "fatal error: get_int_bits left < right\n";
		exit 1
	end
end
and duplist lst num = begin
	if num=1 then lst
	else lst @ (duplist lst (num-1))
end
and list_taillst lst num = begin
	if List.length lst > num then list_taillst (List.tl lst) num
	else if List.length lst = num then lst
	else begin
		Printf.printf "fatal error : too small length \n";
		exit 1
	end
end
and list_headlst lst num = begin
	match num with
	0 -> []
	| _ -> (List.hd lst)::(list_headlst (List.tl lst) (num-1))
end
and str2exp str = begin
	T_primary(T_primary_id([str]))
end
and id2exp id = begin
	T_primary(T_primary_id(id))
end
and list_last lst = begin
	match lst with
	[] -> begin
		Printf.printf "fatal error : should not reach empty list \n";
		exit 1
	end
	| [last] -> last
	| _  -> list_last (List.tl lst)
end
and remove_last lst = begin
	match lst with
	[] -> begin
		Printf.printf "fatal error : should not reach empty list \n";
		exit 1
	end
	| [last] -> []
	| hd::tl  -> hd::(remove_last tl)
end
and list_iter_interleave operate inter lst = begin
	match lst with 
	[] -> ()
	| [last] -> operate last 
	| hd::tl -> begin
		operate hd;
		inter hd;
		list_iter_interleave operate inter tl
	end
end
and construct_range_onidx baseidx li ri = begin
	(*actualy li may > ri*)
	if li < ri then T_range_int(baseidx,baseidx+ri-li)
	else T_range_int(baseidx,baseidx+li-ri)
end
and construct_offset baseidx li ri idx2beoff= begin
	(*actualy li may > ri*)
	if li<ri then 	li+idx2beoff-baseidx
	else li+baseidx-idx2beoff
end
and isdff_name_index name_index = begin
	match name_index with (_,(_,-1))-> false | _ -> true
end
and rng2lr rng= begin
	match rng with
	T_range(expl,expr) -> begin
		let idxl= exp2int_simple expl
		and idxr= exp2int_simple expr
		in
		(idxl,idxr)
	end
	| T_range_int(li,ri) -> (li,ri)
	| T_range_NOSPEC -> (-1,-1)
end
and rngsimple rng = begin
	match rng with
	T_range(expl,expr) -> begin
		let idxl= exp2int_simple expl
		and idxr= exp2int_simple expr
		in
		T_range_int(idxl,idxr)
	end
	| _ -> rng
end
and lr2list li ri = begin
	if li > ri then li::(lr2list (li-1) ri)
	else if li< ri then li::(lr2list (li+1) ri)
	else [ri]
end
and rng2list rng = begin
	let (l,r) = rng2lr rng
	in 
	lr2list l r
end
and offset2idx left right baseidx offset = begin
	baseidx + abs(offset - left)
end
and rng_baseidx_2_idxlist rng baseidx = begin
	let (l,r) = rng2lr rng
	in 
	let lst=rng2list (T_range_int((min l r),(max l r)))
	in
	let delta = baseidx-(List.hd lst)
	in
	List.map (fun x -> (x+delta)) lst
end
and is_inrange rng off = begin
	let (left,right)=rng2lr rng
	in
	if ((left >= off && off >= right)||(left <= off && off <= right)) then true
	else false
end
and cat_string str1 str2 = begin
	String.concat ":::" [str1;str2]
end
and setcomment str cls = begin
	match cls with
	(intlst,_) -> (intlst,str)
end
and appendcomment str cls = begin
	match cls with
	(intlst,strold) -> (intlst,(cat_string strold str))
end
and print_blank_endline voutch a = begin
	fprintf voutch "  \n";
	flush stdout;
	a
end
and print_blank voutch a = begin
	fprintf voutch "  ";
	flush stdout;
	a
end
and print_orendline voutch a = begin
	fprintf voutch " or \n";
	flush stdout;
	a
end
and print_id voutch id = begin
	fprintf voutch "%s" (String.concat "/" id);
	flush stdout
end
and print_v_number voutch numb = begin
	begin
	match numb with 
	T_number_unsign(int1) -> fprintf voutch "%u" int1
	| T_number_base(len,b,str)  -> begin
		fprintf voutch "%u" len ;
		fprintf voutch "\'";
		fprintf voutch "%c" b;
		fprintf voutch  "%s" str
	end
	| T_number_float(flt) -> fprintf voutch  "%e" flt
	end
	;
	flush stdout
end
and print_v_primary voutch prim = begin
	begin
	match prim with
	T_primary_num(numb)  -> begin
		print_v_number voutch numb
	end
	| T_primary_id(id) -> print_id voutch id
	| T_primary_arrbit(id,exp) -> begin
		print_id voutch id ;
		fprintf voutch "%c" '[' ;
		print_v_expression voutch exp ;
		fprintf voutch "%c" ']'
	end
	| T_primary_arrrange(id,exp,exp1) -> begin
		print_id  voutch id ;
		fprintf voutch "%c" '[' ;
		print_v_expression voutch exp ;
		fprintf voutch "%c" ':' ;
		print_v_expression voutch exp1 ;
		fprintf voutch "%c" ']'
	end
	| T_primary_concat(explst) -> begin
		fprintf voutch "%c" '{' ;
		print_v_printlst voutch explst print_v_expression print_comma ;
		fprintf voutch "%c" '}' 
	end	
	| T_primary_multiconcat(len,explst)  -> begin
		fprintf voutch "%c" '{' ;
		print_v_expression  voutch len ;
		fprintf voutch "%c" '{' ;
		print_v_printlst  voutch explst print_v_expression print_comma ;
		fprintf voutch "%c" '}' ;
		fprintf voutch "%c" '}' 
	end
	| T_primary_funcall(id,explst)  -> begin
		print_id  voutch id ;
		fprintf voutch "%c" '(';
		print_v_printlst voutch  explst print_v_expression print_comma ;
		fprintf voutch "%c" ')'
	end
	| T_primary_sysfuncall(id,explst)  -> begin
		print_id voutch  id ;
		fprintf voutch "%c" '(';
		print_v_printlst  voutch explst print_v_expression print_comma ;
		fprintf voutch "%c" ')'
	end
	| T_primary_minmaxexp(minmaxexp) -> begin
		print_v_mintypmax_expression  voutch minmaxexp 
	end
(*	| _ -> fprintf voutch "%s"  "unrecongnized primary"*)
	end
	;
	flush stdout
end
and print_v_mintypmax_expression voutch minmaxexp = begin
	begin
	fprintf voutch "%c" '(';
	begin
	match minmaxexp with 
	T_mintypmax_expression_1(exp) -> begin
		print_v_expression  voutch exp
	end
	| T_mintypmax_expression_3(exp1,exp2,exp3) -> begin
		print_v_expression voutch  exp1;
		fprintf voutch "%c" ':';
		print_v_expression voutch  exp2;
		fprintf voutch "%c" ':';
		print_v_expression voutch  exp3
	end
	end
	;
	fprintf voutch "%c" ')'
	end
	;
	flush stdout
end
and print_v_expression voutch exp = begin
	begin
	match exp with 
	T_primary(prim)  ->  begin
		fprintf voutch "%c" '(';
		print_v_primary voutch  prim;
		fprintf voutch "%c" ')'
	end
	| T_add1(prim)	-> begin
		fprintf voutch "%c" '(';
		fprintf voutch "%s"  "+";
		print_v_primary voutch  prim;
		fprintf voutch "%c" ')'
	end
	| T_sub1(prim)	-> begin
		fprintf voutch "%c" '(';
		fprintf voutch "%s"  "-";
		print_v_primary  voutch prim;
		fprintf voutch "%c" ')'
	end
	| T_logicneg(prim)	-> begin
		fprintf voutch "%c" '(';
		fprintf voutch "%s"  "!";
		print_v_primary  voutch prim;
		fprintf voutch "%c" ')'
	end
	| T_bitneg(prim)	-> begin
		fprintf voutch "%c" '(';
		fprintf voutch "%s"  "~";
		print_v_primary  voutch prim;
		fprintf voutch "%c" ')'
	end
	| T_reduce_and(prim)	-> begin
		fprintf voutch "%c" '(';
		fprintf voutch "%s"  "&";
		print_v_primary voutch  prim;
		fprintf voutch "%c" ')'
	end
	| T_reduce_nand(prim)	-> begin
		fprintf voutch "%c" '(';
		fprintf voutch "%s"  "~&";
		print_v_primary  voutch prim;
		fprintf voutch "%c" ')'
	end
	| T_reduce_or(prim)	-> begin
		fprintf voutch "%c" '(';
		fprintf voutch "%s"  "|";
		print_v_primary  voutch prim;
		fprintf voutch "%c" ')'
	end
	| T_reduce_nor(prim)	-> begin
		fprintf voutch "%c" '(';
		fprintf voutch "%s"  "~|";
		print_v_primary  voutch prim;
		fprintf voutch "%c" ')'
	end
	| T_reduce_xor(prim)	-> begin
		fprintf voutch "%c" '(';
		fprintf voutch "%s"  "^";
		print_v_primary  voutch prim;
		fprintf voutch "%c" ')'
	end
 	| T_reduce_xnor(prim)	-> begin
		fprintf voutch "%c" '(';
		fprintf voutch "%s"  "^~";
		print_v_primary  voutch prim;
		fprintf voutch "%c" ')'
	end
	| T_add2(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " + ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_sub2(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " - ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_mul2(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " * ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_div(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " / ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_mod(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " % ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_logic_equ(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " == ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_logic_ine(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " != ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_case_equ(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " === ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_case_ine(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " !== ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_logic_and2(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " && ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_logic_or2(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " || ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_lt(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " < ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_le(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " <= ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_gt(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " > ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_ge(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " >= ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_bit_and2(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " & ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_bit_or2(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " | ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_bit_xor2(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " ^ ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_bit_equ(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " ^~ ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_leftshift(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " << ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_rightshift(exp1,exp2)  -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " >> ";
		print_v_expression  voutch exp2;
		fprintf voutch "%c" ')'
	end
	| T_selection(exp1,exp2,exp3) -> begin
		fprintf voutch "%c" '(';
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " ? ";
		print_v_expression  voutch exp2;
		fprintf voutch "%s"  " : ";
		print_v_expression  voutch exp3;
		fprintf voutch "%c" ')'
	end
	| T_string(str) -> begin
		fprintf voutch "%c" '(';
		fprintf voutch "%s"  str;
		fprintf voutch "%c" ')'
	end
	| T_expression_NOSPEC(w)  -> begin
		fprintf voutch "%d'b%s" w (String.make w 'x');
		
	end
	| T_primary_4arrayassign(arrasslst)  -> begin
		fprintf voutch "%s" "{";
		print_v_printlst  voutch arrasslst print_v_arrayassign print_comma ;
		fprintf voutch "%s" "}"
	end
	end
	;
	flush stdout
end
and print_v_arrayassign voutch arrass = begin
	match arrass with
	T_arrayassign(left,right,exp) -> print_v_expression  voutch exp
end
and print_v_charge_strength voutch chg_strg = begin
	begin
	match chg_strg with
	T_charge_strength_SMALL  -> begin
		fprintf voutch "%c" '(';
		fprintf voutch "%s"  "small";
		fprintf voutch "%c" ')'
	end
	| T_charge_strength_MEDIUM  -> begin
		fprintf voutch "%c" '(';
		fprintf voutch "%s"  "medium";
		fprintf voutch "%c" ')'
	end
	| T_charge_strength_LARGE  -> begin
		fprintf voutch "%c" '(';
		fprintf voutch "%s"  "large";
		fprintf voutch "%c" ')'
	end
	| T_charge_strength_NOSPEC  -> fprintf voutch "%s"  ""
	end
	;
	flush stdout
end
and print_v_param_assignment voutch pa = begin
	begin
	match pa with 
	T_param_assignment(id,exp) -> begin
		print_id voutch id;
		fprintf voutch "%s"  "=" ;
		print_v_expression  voutch exp
	end
	end
	;
	flush stdout
end
and print_v_range voutch rng = begin
	begin
	match rng with
	T_range(exp1,exp2) -> begin
		fprintf voutch "%s"  " [ ";
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  " : ";
		print_v_expression  voutch exp2;
		fprintf voutch "%s"  " ] "
	end
	| T_range_int(lft,rgt) -> begin
		fprintf voutch "%s"  " [ ";
		fprintf voutch "%d" lft;
		fprintf voutch "%s"  " : ";
		fprintf voutch "%d" rgt;
		fprintf voutch "%s"  " ] "
	end
	| T_range_NOSPEC -> ()
	end
	;
	flush stdout
end
and print_v_lvalue voutch lv = begin
	begin
	match lv with 
	T_lvalue_id(id) -> print_id voutch id
	| T_lvalue_arrbit(id,exp) -> begin
		print_id voutch id;
		fprintf voutch "%s"  "[";
		print_v_expression  voutch exp;
		fprintf voutch "%s"  "]"
	end
	| T_lvalue_arrrange(id,exp1,exp2) -> begin
		print_id voutch id;
		fprintf voutch "%s"  "[";
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  ":";
		print_v_expression  voutch exp2;
		fprintf voutch "%s"  "]"
	end
	| T_lvalue_concat(explst) -> begin
		fprintf voutch "%s"  "{";
		print_v_printlst  voutch explst print_v_expression print_comma ;
		fprintf voutch "%s"  "}"
	end
	end
	;
	flush stdout
end
and print_v_assignment voutch ass = begin
	begin
	match ass with 
	T_assignment(lv,exp) -> begin
		print_v_lvalue  voutch lv;
		fprintf voutch "%s"  "=";
		print_v_expression  voutch exp
	end
	end
	;
	flush stdout
end
and print_v_expandrange voutch exprang = begin
	begin
	match exprang with
	T_expandrange_range(rng) -> begin
		print_v_range  voutch rng
	end
	| T_expandrange_scalared(rng) -> begin
		fprintf voutch "%s"  "scalared ";
		print_v_range  voutch rng
	end
	| T_expandrange_vectored(rng) -> begin
		fprintf voutch "%s"  "vectored ";
		print_v_range  voutch rng
	end
	| T_expandrange_NOSPEC -> ()
	end
	;
	flush stdout
end
and print_v_delay voutch dly = begin
	begin
	match dly with
	T_delay_number(numb) -> begin
		fprintf voutch "%s"  " # (" ;
		print_v_number voutch  numb ;
		fprintf voutch "%s"  " )"
	end
	| T_delay_id(id) -> begin
		fprintf voutch "%s"  " # (" ;
		print_id voutch id ;
		fprintf voutch "%s"  " )"
	end
	| T_delay_minmax1(minmaxexp) -> begin
		fprintf voutch "%s"  " # (" ;
		print_v_mintypmax_expression  voutch minmaxexp ;
		fprintf voutch "%s"  " )"
	end
	| T_delay_minmax3(minmaxexp1,minmaxexp2,minmaxexp3) -> begin
		fprintf voutch "%s"  " # (" ;
		print_v_mintypmax_expression voutch  minmaxexp1 ;
		fprintf voutch "%s"  " , " ;
		print_v_mintypmax_expression  voutch minmaxexp2 ;
		fprintf voutch "%s"  " , " ;
		print_v_mintypmax_expression  voutch minmaxexp3 ;
		fprintf voutch "%s"  " )"
	end
	| T_delay_NOSPEC -> ()
	end
	;
	flush stdout
end
and print_v_register_variable voutch regv = begin
	begin
	match regv with
	T_register_variables_ID(str) -> fprintf voutch "%s"  str
	| T_register_variables_IDrange(str,exp1,exp2) -> begin
		fprintf voutch "%s"  str;
		fprintf voutch "%s"  "[";
		print_v_expression  voutch exp1;
		fprintf voutch "%s"  ":";
		print_v_expression  voutch exp2;
		fprintf voutch "%s"  "]"
	end
	end
	;
	flush stdout
end
and print_v_drive_strength voutch drvstr = begin
	begin
	match drvstr with 
	T_drive_strength(strg1,strg2) -> begin
		fprintf voutch "%s"  "(";
		fprintf voutch "%s"  strg1;
		fprintf voutch "%s"  ",";
		fprintf voutch "%s"  strg2;
		fprintf voutch "%s"  ")"
	end
	| T_drive_strength_NOSPEC -> ()
	end
	;
	flush stdout
end
and print_v_gate_instance voutch gi = begin
	begin
	match gi with 
	T_gate_instance(name,termlst) -> begin
		fprintf voutch "%s"  name;
		print_v_printlst  voutch termlst print_v_expression print_comma_endline ;
	end
	end
	;
	flush stdout
end
and print_v_named_port_connection voutch namedconn = begin
	begin
	match namedconn with
	T_named_port_connection(name,exp) -> begin
		fprintf voutch "%s"  ".";
		fprintf voutch "%s"  name;
		fprintf voutch "%s"  "(";
		begin
			match exp with
			T_expression_NOSPEC(_) -> ()
			| _ -> print_v_expression  voutch exp
		end
		;
		fprintf voutch "%s"  ")"
	end
	end
	;
	flush stdout
end
and print_v_list_of_module_connections voutch connectlst = begin
	begin
	match connectlst with 
	T_list_of_module_connections_unnamed(lst) -> begin
		print_v_printlst voutch  lst print_v_expression  print_comma_endline ;
	end
	| T_list_of_module_connections_named(lst) -> begin
		print_v_printlst  voutch lst print_v_named_port_connection  print_comma_endline ;
	end
	end
	;
	flush stdout
end
and print_v_module_instance voutch mi = begin
	begin
	match mi with 
	T_module_instance(instname, connectlst) -> begin
		fprintf voutch "%s"  instname ;
		fprintf voutch "%s"  " ( ";
		print_v_list_of_module_connections  voutch connectlst;
		fprintf voutch "%s"  " ) "
	end
	end
	;
	flush stdout
end
and print_v_delay_control voutch dlyctl = begin
	begin
	match dlyctl with 
	T_delay_control(exp) -> begin
		fprintf voutch "%s"  "# ";
		print_v_expression  voutch  exp ;
	end
	end
	;
	flush stdout
end
and print_v_case_item voutch caseit = begin
	begin
	match caseit with
	T_case_item_normal(explst,stat) -> begin
		print_v_printlst  voutch explst print_v_expression print_comma;
		fprintf voutch "%s"  ":";
		print_v_statement  voutch stat
	end
	| T_case_item_default(stat) -> begin
		fprintf voutch "%s"  "default : ";
		print_v_statement  voutch stat
	end
	end
	;
	flush stdout
end
and print_v_event_expression voutch evnexp = begin
	begin
	match evnexp with
	T_event_expression(exp) -> print_v_expression  voutch exp
	| T_event_expression_posedge(exp) -> begin
		fprintf voutch "%s"  "posedge ";
		print_v_expression  voutch exp
	end
	| T_event_expression_negedge(exp) -> begin
		fprintf voutch "%s"  "negedge ";
		print_v_expression  voutch exp
	end
	end
	;
	flush stdout
end
and print_v_event_control voutch evnctl = begin
	begin
	match evnctl with 
	T_event_control_id(id) -> begin
		fprintf voutch "%s"  "@";
		print_id voutch id
	end
	| T_event_control_evexp(evnexplst) -> begin
		fprintf voutch "%s"  "@";
		fprintf voutch "%s"  "(";
		print_v_printlst voutch  evnexplst print_v_event_expression print_comma;
		fprintf voutch "%s"  ")"
	end
	end
	;
	flush stdout
end
and print_v_statement voutch stat = begin
	begin
	match stat with
		T_blocking_assignment(blkstat) -> begin
			begin
			match blkstat with
			T_blocking_assignment_direct(lv,exp) -> begin
				print_v_lvalue voutch  lv;
				fprintf voutch "%s"  " = ";
				print_v_expression  voutch exp
			end
			| T_blocking_assignment_delay(lv,exp,dlyctl) -> begin
				print_v_lvalue  voutch lv;
				fprintf voutch "%s"  " = ";
				print_v_delay_control voutch  dlyctl;
				print_v_expression  voutch exp
			end
			| T_blocking_assignment_event(lv,exp,evnctl) -> begin
				print_v_lvalue voutch  lv;
				fprintf voutch "%s"  " = ";
				print_v_event_control  voutch evnctl;
				print_v_expression  voutch exp
			end
			end
			;
			fprintf voutch "%s\n" ";"
		end
		| T_non_blocking_assignment(nblkstat) -> begin
			begin
			match nblkstat with
			T_non_blocking_assignment_direct(lv,exp) -> begin
				print_v_lvalue  voutch lv;
				fprintf voutch "%s"  " <= ";
				print_v_expression  voutch exp
			end
			| T_non_blocking_assignment_delay(lv,exp,dlyctl) -> begin
				print_v_lvalue  voutch lv;
				fprintf voutch "%s"  " <= ";
				print_v_delay_control  voutch dlyctl;
				print_v_expression  voutch exp
			end
			| T_non_blocking_assignment_event(lv,exp,evnctl) -> begin
				print_v_lvalue  voutch lv;
				fprintf voutch "%s"  " <= ";
				print_v_event_control  voutch evnctl;
				print_v_expression  voutch exp
			end
			end
			;
			fprintf voutch "%s\n" ";"
		end
		| T_if_statement(exp,stat) -> begin
			fprintf voutch "%s"  "if( ";
			print_v_expression  voutch exp ;
			fprintf voutch "%s"  ") ";
			print_v_statement  voutch stat
		end
		| T_if_else_statement(exp,stat1,stat2) -> begin
			fprintf voutch "%s"  "if( ";
			print_v_expression  voutch exp ;
			fprintf voutch "%s"  ") ";
			print_v_statement  voutch stat1;
			fprintf voutch "%s"  " else ";
			print_v_statement  voutch stat2
		end
		| T_case_statement(exp,caseitlst) -> begin
			fprintf voutch "%s"  "case (";
			print_v_expression voutch  exp ;
			fprintf voutch "%s"  ") ";
			print_v_printlst  voutch caseitlst print_v_case_item print_simplyendline;
			fprintf voutch "%s\n" "endcase"
		end
		| T_casez_statement(exp,caseitlst) -> begin
			fprintf voutch "%s"  "casez (";
			print_v_expression  voutch exp ;
			fprintf voutch "%s"  ") ";
			print_v_printlst  voutch caseitlst print_v_case_item print_simplyendline;
			fprintf voutch "%s\n" "endcase"
		end
		| T_casex_statement(exp,caseitlst) -> begin
			fprintf voutch "%s"  "casex (";
			print_v_expression  voutch exp ;
			fprintf voutch "%s"  ") ";
			print_v_printlst  voutch caseitlst print_v_case_item print_simplyendline;
			fprintf voutch "%s\n" "endcase"
		end
		| T_forever_statement(stat) -> begin
			fprintf voutch "%s"  "forever ";
			print_v_statement  voutch stat;
			fprintf voutch "\n"
		end
		| T_repeat_statement(exp,stat) -> begin
			fprintf voutch "%s"  "repeat( ";
			print_v_expression  voutch exp ;
			fprintf voutch "%s"  ") ";
			fprintf voutch "\n";
			print_v_statement  voutch stat;
			fprintf voutch "\n"
		end
		| T_while_statement(exp,stat) -> begin
			fprintf voutch "%s"  "while( ";
			print_v_expression  voutch exp ;
			fprintf voutch "%s"  ") ";
			fprintf voutch "\n";
			print_v_statement  voutch stat;
			fprintf voutch "\n"
		end
		| T_for_statement(ass1,exp,ass2,stat) -> begin
			fprintf voutch "%s"  "for( ";
			print_v_assignment  voutch ass1;
			fprintf voutch "%s"  ";";
			print_v_expression  voutch exp ;
			fprintf voutch "%s"  ";";
			print_v_assignment  voutch ass2;
			fprintf voutch "%s"  ") ";
			print_v_statement  voutch stat;
			fprintf voutch "\n"
		end
		| T_delay_statement(dlyctl,stat) -> begin
			print_v_delay_control  voutch dlyctl;
			print_v_statement voutch  stat;
			fprintf voutch "\n"
		end
		| T_event_statement(evnctl,stat) -> begin
			print_v_event_control  voutch evnctl;
			print_v_statement  voutch stat;
			fprintf voutch "\n"
		end
		| T_wait_statement(exp,stat) -> begin
			fprintf voutch "%s"  "wait( ";
			print_v_expression  voutch exp ;
			fprintf voutch "%s"  ") ";
			print_v_statement  voutch stat;
			fprintf voutch "\n"
		end
		| T_leadto_event(str) -> begin
			fprintf voutch "%s"  "-> ";
			fprintf voutch "%s"  str;
			fprintf voutch "\n"
		end
		| T_seq_block(lab,milst,statlst) -> begin
			begin
			match lab with
			"" -> 	fprintf voutch "%s"  "begin "
			| _ -> begin
				fprintf voutch "%s"  "begin : ";
				fprintf voutch "%s"   lab 
			end
			end
			;
			fprintf voutch "\n";
			begin
			match milst with
			[] -> 	()
			| _ -> begin
				print_v_printlst  voutch milst print_v_module_item  print_simplyendline ;
			end
			end
			;
			print_v_printlst voutch  statlst print_v_statement  print_simplyendline ;
			fprintf voutch "\n";
			fprintf voutch "%s"  "end";
			fprintf voutch "\n"
		end
		| T_par_block(lab,milst,statlst) -> begin
			begin
			match lab with
			"" -> 	fprintf voutch "%s"  "fork "
			| _ -> begin
				fprintf voutch "%s"  "fork : ";
				fprintf voutch "%s"   lab ;
			end
			end
			;
			fprintf voutch "\n";
			begin
			match milst with
			[] -> 	()
			| _ -> begin
				print_v_printlst voutch  milst print_v_module_item  print_comma_endline ;
			end
			end
			;
			print_v_printlst  voutch statlst print_v_statement  print_comma_endline ;
			fprintf voutch "\n";
			fprintf voutch "%s"  "join";
			fprintf voutch "\n"
		end
		| T_task_enable(name,explst) -> begin
			fprintf voutch "%s"  name;
			begin
			match explst with
			[] -> ()
			| _ -> begin
				fprintf voutch "%s"  "(";
				print_v_printlst  voutch explst print_v_expression  print_comma ;
				fprintf voutch "%s"  ")"
			end
			end
			;
			fprintf voutch "%s\n" ";"
		end
		| T_system_task_enable(name,explst) -> begin
			fprintf voutch "%s"  name;
			begin
			match explst with
			[] -> ()
			| _ -> begin
				fprintf voutch "%s"  "(";
				print_v_printlst  voutch explst print_v_expression  print_comma ;
				fprintf voutch "%s"  ")"
			end
			end
			;
			fprintf voutch "%s\n" ";"
		end
		| T_disable_statement(name) -> begin
			fprintf voutch "%s"  "disable ";
			fprintf voutch "%s"  name;
			fprintf voutch "%s\n" ";"
		end
		| T_force_statement(ass) -> begin
			fprintf voutch "%s"  "force ";
			print_v_assignment voutch  ass;
			fprintf voutch "%s\n" ";"
		end
		| T_release_statement(lv) ->  begin
			fprintf voutch "%s"  "release ";
			print_v_lvalue  voutch lv;
			fprintf voutch "%s\n" ";"
		end
		| T_statement_NOSPEC -> fprintf voutch "%s\n" ";"
	end
	;
	flush stdout
end
and print_v_module_item voutch moditm = begin
	begin
	fprintf voutch "\n";
	match moditm with 
		T_parameter_declaration(param_assignment_list)  -> begin
			fprintf voutch "%s"  "parameter   " ;
			print_v_printlst  voutch param_assignment_list print_v_param_assignment  print_comma_endline ;
			fprintf voutch "%s\n" ";"
		end
		| T_input_declaration(rng, strlst) -> begin
			fprintf voutch "%s"  "input ";
			print_v_range  voutch rng ;
			fprintf voutch "%s" (String.concat ",\n" strlst );
			fprintf voutch "%s\n" ";"
		end
		| T_output_declaration(rng, strlst) -> begin
			fprintf voutch "%s"  "output ";
			print_v_range  voutch rng ;
			fprintf voutch "%s" (String.concat ",\n" strlst );
			fprintf voutch "%s\n" ";"
		end
		| T_inout_declaration(rng, strlst) -> begin
			fprintf voutch "%s"  "inout ";
			print_v_range voutch  rng ;
			fprintf voutch "%s" (String.concat ",\n" strlst );
			fprintf voutch "%s\n" ";"
		end
		| T_net_declaration(nettype,chg_strg,exprang,dly,strlst) -> begin
			fprintf voutch "%s"  nettype ;
			fprintf voutch "%s"  "  ";
			print_v_charge_strength  voutch chg_strg;
			print_v_expandrange  voutch  exprang;
			print_v_delay  voutch  dly;
			fprintf voutch "%s" (String.concat ",\n" strlst );
			fprintf voutch "%s\n" ";"
		end
		| T_reg_declaration(rng,regvlst) -> begin
			fprintf voutch "%s"  "reg ";
			print_v_range  voutch rng ;
			print_v_printlst  voutch regvlst print_v_register_variable print_comma_endline ;
			fprintf voutch "%s\n" ";"
		end
		| T_time_declaration(regvlst) -> begin
			fprintf voutch "%s"  "time ";
			print_v_printlst  voutch regvlst print_v_register_variable print_comma_endline ;
			fprintf voutch "%s\n" ";"
		end
		| T_integer_declaration(regvlst) -> begin
			fprintf voutch "%s"  "integer ";
			print_v_printlst  voutch regvlst print_v_register_variable print_comma_endline ;
			fprintf voutch "%s\n" ";"
		end
		| T_real_declaration(strlst) -> begin
			fprintf voutch "%s"  "real ";
			fprintf voutch "%s" (String.concat ",\n" strlst );
			fprintf voutch "%s\n" ";"
		end
		| T_event_declaration(strlst) -> begin
			fprintf voutch "%s"  "event ";
			fprintf voutch "%s" (String.concat ",\n" strlst );
			fprintf voutch "%s\n" ";"
		end
		| T_gate_declaration(gatetyp,drvstr,dly,gateinslst) -> begin
			fprintf voutch "%s"  gatetyp ;
			fprintf voutch "%s"  " ";
			print_v_drive_strength  voutch drvstr;
			fprintf voutch "%s"  " ";
			print_v_delay  voutch dly;
			fprintf voutch "%s"  " ";
			print_v_printlst  voutch gateinslst print_v_gate_instance print_comma_endline ;
			fprintf voutch "%s\n" ";"
		end
		| T_module_instantiation(name,drvstr,paramasslst,milst) -> begin
			fprintf voutch "%s"  name ;
			fprintf voutch "%s"  " ";
			print_v_drive_strength voutch  drvstr;
			fprintf voutch "%s"  " ";
			begin
				match paramasslst with
				[] -> ()
				| _ -> begin
					fprintf voutch "%s"  " # ( ";
					print_v_printlst  voutch paramasslst print_v_expression  print_comma_endline ;
					fprintf voutch "%s"  " ) ";
				end
			end
			;
			fprintf voutch "%s"  " ";
			print_v_printlst  voutch milst print_v_module_instance print_comma_endline ;
			fprintf voutch "%s\n" ";"
		end
		| T_parameter_override(paramasslst) -> begin
			fprintf voutch "%s"  "defparam ";
			print_v_printlst  voutch paramasslst print_v_param_assignment  print_comma_endline ;
			fprintf voutch "%s\n" ";"
		end
		| T_continuous_assign(contass) -> begin
			match contass with
			T_continuous_assign_assign(drvstrg,dly,asslst) -> begin
				fprintf voutch "%s"  "assign ";
				print_v_drive_strength  voutch drvstrg;
				fprintf voutch "%s"  " ";
				print_v_delay  voutch dly;
				print_v_printlst  voutch asslst print_v_assignment  print_comma_endline ;
				fprintf voutch "%s\n" ";"
			end
			| T_continuous_assign_net(netype,drvstrg,exprang,dly,asslst) -> begin
				fprintf voutch "%s"  netype;
				fprintf voutch "%s"  " ";
				print_v_drive_strength voutch  drvstrg;
				fprintf voutch "%s"  " ";
				print_v_expandrange  voutch exprang;
				fprintf voutch "%s"  " ";
				print_v_delay  voutch dly;
				print_v_printlst  voutch asslst print_v_assignment  print_comma_endline ;
				fprintf voutch "%s\n" ";"
			end
		end
		| T_specify_block(specitlst)	-> begin
			fprintf voutch "%s"  "specify ";
			fprintf voutch "%s"  "//unreconginzed specify block";
			fprintf voutch "%s\n" "endspecify "
		end
		| T_initial_statement(stat) -> begin
			fprintf voutch "%s"  "initial ";
			print_v_statement  voutch stat
		end
		| T_always_statement(stat) -> begin
			fprintf voutch "%s"  "always ";
			print_v_statement  voutch stat
		end
		| T_task(name,milst,stat) -> begin
			fprintf voutch "%s"  "task ";
			fprintf voutch "%s"  name;
			fprintf voutch "%s\n" ";";
			print_v_printlst  voutch milst print_v_module_item  print_comma_endline ;
			begin
			match stat with 
			T_statement_NOSPEC -> ()
			| _ -> print_v_statement  voutch stat
			end
			;
			fprintf voutch "%s"  "endtask ";
		end
		| T_function_avoid_amb(rng_typ,name,milst,stat) -> begin
			begin
			fprintf voutch "%s"  "function";
			match rng_typ with
			T_range_or_type_NOSPEC -> ()
			| T_range_or_type_range(rng) -> print_v_range  voutch rng
			| T_range_or_type_INTEGER -> fprintf voutch "%s"  " integer "
			| T_range_or_type_REAL -> fprintf voutch "%s"  " real "
			end
			;
			fprintf voutch "%s"  name;
			fprintf voutch "%s\n" ";";
			print_v_printlst  voutch milst print_v_module_item  print_comma_endline ;
			begin
			match stat with 
			T_statement_NOSPEC -> ()
			| _ -> print_v_statement  voutch stat
			end
			;
			fprintf voutch "%s"  "endfunction ";
		end
(*		| _ -> () *)
	end
	;
	flush stdout
end
and print_v_module_def voutch inst_module_def = begin
	begin
	match inst_module_def with
	T_module_def(modname,portlst,moditmlst) -> 
	begin
		fprintf voutch "%s"  "module " ;
		fprintf voutch "%s"  modname   ;
		fprintf voutch "%s"  "(";
		fprintf voutch "\n";

		print_v_printlst  voutch portlst print_id print_comma_endline;

		fprintf voutch "%s"  ")";
		fprintf voutch "%s"  ";";
		fprintf voutch "\n";
		
		List.iter (print_v_module_item voutch ) moditmlst;
		
		fprintf voutch "\n";
		fprintf voutch "%s"  "endmodule " ;
		fprintf voutch "\n";
		fprintf voutch "\n";
		fprintf voutch "\n"
	end
	| _ -> begin
		Printf.printf "fatal error : should not reach here 111\n";
		exit 1
	end
	end
	;
	flush stdout
end
and print_v_source_text voutch inst_T_module_def_lst = begin
	List.iter (print_v_module_def voutch ) inst_T_module_def_lst
end
and print_v_expression_exlif voutch exp = begin
	begin
	match exp with 
	T_primary(prim)  ->  begin
		print_v_primary_exlif voutch  prim;
	end
	| T_logicneg(prim)	-> begin
		fprintf voutch "%c" '(';
		print_v_primary_exlif  voutch prim;
		fprintf voutch "%s"  "\'";
		fprintf voutch "%c" ')'
	end
	| T_bitneg(prim)	-> begin
		fprintf voutch "%c" '(';
		print_v_primary_exlif  voutch prim;
		fprintf voutch "%s"  "\'";
		fprintf voutch "%c" ')'
	end
	| T_logic_and2(exp1,exp2)  -> begin
		print_v_expression_exlif  voutch exp1;
		fprintf voutch "%s"  " & ";
		print_v_expression_exlif  voutch exp2;
	end
	| T_logic_or2(exp1,exp2)  -> begin
		print_v_expression_exlif  voutch exp1;
		fprintf voutch "%s"  " + ";
		print_v_expression_exlif  voutch exp2;
	end
	| T_bit_and2(exp1,exp2)  -> begin
		print_v_expression_exlif  voutch exp1;
		fprintf voutch "%s"  " & ";
		print_v_expression_exlif  voutch exp2;
	end
	| T_bit_or2(exp1,exp2)  -> begin
		print_v_expression_exlif  voutch exp1;
		fprintf voutch "%s"  " + ";
		print_v_expression_exlif  voutch exp2;
	end
	| T_bit_xor2(exp1,exp2)  -> begin
		print_v_expression_exlif  voutch exp1;
		fprintf voutch "%s"  " ^ ";
		print_v_expression_exlif  voutch exp2;
	end
	| T_expression_NOSPEC(w)  -> begin
		fprintf voutch "%d'b%s" w (String.make w 'x');
	end
	(*| T_primary_4arrayassign(arrasslst)  -> begin
		fprintf voutch "%s" "{";
		print_v_printlst  voutch arrasslst print_v_arrayassign print_comma ;
		fprintf voutch "%s" "}"
	end*)
	| _ -> begin
		Printf.printf "fatal error : cannot print in print_v_expression_exlif\n";
		print_v_expression stdout exp;
		exit 1
	end
	end
	;
	flush stdout
end
and print_v_primary_exlif voutch prim = begin
	match prim with
	T_primary_num(numb)  -> begin
		match numb with
		T_number_base(1,'b',"0") -> Printf.fprintf voutch "F"
		| T_number_base(1,'b',"1") -> Printf.fprintf voutch "T"
		| _ -> begin
			Printf.printf  "unrecongnized primary 4\n";
			print_v_primary stdout prim;
			exit 1
		end
	end
	| T_primary_id(id) -> print_id voutch id
	| T_primary_arrbit(id,exp) -> begin
		print_id voutch id ;
		fprintf voutch "%c" '[' ;
		print_v_expression_exlif voutch exp ;
		fprintf voutch "%c" ']'
	end
	| T_primary_arrrange(id,exp,exp1) -> begin
		print_id  voutch id ;
		fprintf voutch "%c" '[' ;
		print_v_expression_exlif voutch exp ;
		fprintf voutch "%c" ':' ;
		print_v_expression_exlif voutch exp1 ;
		fprintf voutch "%c" ']'
	end
	| T_primary_concat(explst) -> begin
		if (List.length explst) !=1 then begin
			Printf.printf  "improper length T_primary_concat is not 1\n";
			print_v_primary stdout prim;
			exit 1
		end
		else begin
			print_v_expression_exlif voutch (List.hd explst) ;
		end
	end
	| T_primary_minmaxexp(minmaxexp) -> begin
		match minmaxexp with
		T_mintypmax_expression_1(mmexp) -> print_v_expression_exlif voutch mmexp
		| _ -> begin
			Printf.printf  "unrecongnized primary 3\n";
			print_v_primary stdout prim;
			exit 1
		end
	end
	| _ -> begin
		Printf.printf  "unrecongnized primary\n";
		print_v_primary stdout prim;
		exit 1
	end
	;
	flush stdout
end
(*and print_v_module_instance_exlif voutch mi = begin
	begin
	match mi with 
	T_module_instance(instname, connectlst) -> begin
		fprintf voutch " %s "  instname ;
		print_v_list_of_module_connections_exlif  voutch connectlst;
		fprintf voutch "\n"
	end
	end
	;
	flush stdout
end
and print_v_list_of_module_connections_exlif voutch connectlst rng = begin
	begin
	match connectlst with 
	T_list_of_module_connections_unnamed(lst) -> begin
		Printf.printf  "fatal error : T_list_of_module_connections_unnamed is not supported\n";
		exit 1
	end
	| T_list_of_module_connections_named(lst) -> begin
		print_v_printlst  voutch lst print_v_named_port_connection_exlif  print_blank rng ;
	end
	end
	;
	flush stdout
end*)
and print_v_named_port_connection_exlif voutch namedconn rng= begin
	begin
	match namedconn with
	T_named_port_connection(name,exp) -> begin
		fprintf voutch " %s"  name;
		begin
			match rng with
			T_range_int(lft,rgt) -> fprintf voutch "[%d:%d]"  lft rgt
			| T_range_NOSPEC -> ()
			| _ -> begin
				Printf.printf "fatal error : invalid range\n";
				exit 1
			end
		end
		;
		fprintf voutch " %s "  "=";
		begin
			match exp with
			T_expression_NOSPEC(_) -> ()
			| T_primary(T_primary_id(id)) -> fprintf voutch " %s " (get_str_from_strlst id)
			| T_primary(T_primary_concat([exp1])) -> print_v_expression_exlif  voutch exp1
			| T_primary(T_primary_concat(explst)) -> begin
				let proc_idx ee = begin
					match ee with
					T_primary(T_primary_id([strname])) ->  begin
					   try 
						let poslp=String.index strname '['
						and posrp=String.index strname ']'
						in
						int_of_string (String.sub strname (poslp+1) (posrp-poslp-1))
					   with Not_found -> begin
					   	Printf.printf "fatal error : improper T_primary_concat\n";
						print_v_expression  stdout exp;
						exit 1
					   end
					end
					| _ -> begin
						Printf.printf "fatal error : improper T_primary_concat\n";
						print_v_expression  stdout exp;
						exit 1
					end
				end
				and proc_name ee = begin
					match ee with
					T_primary(T_primary_id([strname])) ->  begin
					   try 
						let poslp=String.index strname '['
						(*and posrp=String.index strname ']'*)
						in
						String.sub strname 0 poslp
					   with Not_found -> begin
					   	Printf.printf "fatal error : improper T_primary_concat\n";
						print_v_expression  stdout exp;
						exit 1
					   end
					end
					| _ -> begin
						Printf.printf "fatal error : improper T_primary_concat\n";
						print_v_expression  stdout exp;
						exit 1
					end
				end
				in
				let idxlst=List.map proc_idx explst
				and idstrlst=List.map proc_name explst
				in 
				begin
					let rec chk_incr_lst slst = begin
						match slst with
						[] -> begin
							Printf.printf "fatal error : should not reach here\n";
							exit 1
						end
						| [last] -> true
						| hd1::hd2::tl -> begin
						   if ((List.hd idxlst) < (list_last idxlst)) then begin
							if((hd1+1)!=hd2) then begin
								Printf.printf "fatal error : improper integer list\n";
								print_v_expression  stdout exp;
								exit 1
							end
							else chk_incr_lst (hd2::tl)
						   end 
						   else begin
							if((hd1-1)!=hd2) then begin
								Printf.printf "fatal error : improper integer list\n";
								print_v_expression  stdout exp;
								exit 1
							end
							else chk_incr_lst (hd2::tl)
						   end
						end
					end
					and chk_equ_lst slst = begin
						match slst with
						[] -> begin
							Printf.printf "fatal error : should not reach here\n";
							exit 1
						end
						| [last] -> true
						| hd1::hd2::tl -> begin
							if(hd1=hd2) then chk_equ_lst (hd2::tl)
							else begin
								Printf.printf "fatal error : improper name list\n";
								Printf.printf "%s\n" hd1;
								Printf.printf "%s\n" hd2;
								print_v_expression  stdout exp;
								exit 1
							end
						end
					end
					in begin
						chk_incr_lst idxlst;
						chk_equ_lst idstrlst;
						fprintf voutch " %s[%d:%d] " (List.hd idstrlst) (List.hd idxlst)  (list_last idxlst)
					end
				end
			end
			| _ -> begin
				Printf.printf "fatal error : not supprot such expre\n";
				print_v_expression  stdout exp;
				exit 1
			end
		end
	end
	end
	;
	flush stdout
end
