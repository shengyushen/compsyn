open Misc
open Typedef


let rec dep_statement stat = begin
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
	uniqlst lst
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
	uniqlst lst
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
	uniqlst lst
end
and dep_ci ci = begin
	match ci with
	T_case_item_normal(explst,stat) -> (List.concat (List.map dep_expression explst))@(dep_statement stat)
	| T_case_item_default(stat) -> dep_statement stat
end
