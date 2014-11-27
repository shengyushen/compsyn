open Typedef
open Expression

(*variable related function*)
let rec extract_idlst_from_prim prim = begin
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
				Print_v.print_v_statement stdout stm;
				exit 1
			end
		end
		| T_non_blocking_assignment(nba) -> begin
			Printf.printf "warning:currently unsupported non blocking assignment in comb logic declaration\n";
			Print_v.print_v_statement stdout stm;
			match nba with
			T_non_blocking_assignment_direct(lv,exp) -> lvalue2idlst lv
			| _ -> begin
				Printf.printf "fatal error: get_lvidlst_from_always_comb currently unsupported complex non_blocking_assignment\n";
				Print_v.print_v_statement stdout stm;
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
				Print_v.print_v_statement stdout stm;
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
				Print_v.print_v_statement stdout stm;
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
		let idxl= Expression.exp2int_simple expl
		and idxr= Expression.exp2int_simple expr
		in
		(idxl,idxr)
	end
	| T_range_int(li,ri) -> (li,ri)
	| T_range_NOSPEC -> (-1,-1)
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
