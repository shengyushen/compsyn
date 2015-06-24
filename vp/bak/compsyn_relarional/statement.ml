open Typedef
open Misc

let rec statement2regnamelist stat = begin
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
	in uniqlst lst
end
and blocking_assignment2regnamelist blkass = begin
	let lst= begin
	match blkass with
	T_blocking_assignment_direct(lv,_) -> lv2regnamelist lv
	| T_blocking_assignment_delay(lv,_,_) -> lv2regnamelist lv
	| T_blocking_assignment_event(lv,_,_) -> lv2regnamelist lv
	end
	in uniqlst lst
end
and lv2regnamelist lv = begin
	let lst= begin
	match lv with
	T_lvalue_id(id) -> [id2string id]
	| T_lvalue_arrbit(id,_) -> [id2string id]
	| T_lvalue_arrrange(id,_,_) -> [id2string id]
	| T_lvalue_concat(explst) -> List.concat (List.map exp2reglist explst)
	end
	in uniqlst lst
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
	in uniqlst lst
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
	in uniqlst lst
end
and non_blocking_assignment2regnamelist nba = begin
	let lst= begin
	match nba with
	T_non_blocking_assignment_direct(lv,_) -> lv2regnamelist lv
	| T_non_blocking_assignment_delay(lv,_,_) -> lv2regnamelist lv
	| T_non_blocking_assignment_event(lv,_,_) -> lv2regnamelist lv
	end
	in uniqlst lst
end
and ci2reglist ci = begin
	let lst= begin
	match ci with
	T_case_item_normal(_,stat) -> statement2regnamelist stat
	| T_case_item_default(stat) -> statement2regnamelist stat
	end
	in uniqlst lst
end
and id2string strlst = begin
	String.concat "/" strlst
end
