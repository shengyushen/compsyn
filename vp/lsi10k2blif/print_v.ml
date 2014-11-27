open Typedef
open Printf

let compose f g = function x -> f(g(x))
;;

let print_dot voutch a = begin
	fprintf voutch ".";
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
let print_comma voutch a = begin
	fprintf voutch " , ";
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
let print_blank_endline voutch a = begin
	fprintf voutch "  \n";
	flush stdout;
	a
end
;;
let print_blank voutch a = begin
	fprintf voutch "  ";
	flush stdout;
	a
end
;;
let print_orendline voutch a = begin
	fprintf voutch " or \n";
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
let print_v_printlst voutch lst dofunc sepfunc = begin
		match lst with
		[]	->	()
		| head::tail -> begin
			dofunc voutch head ;
			List.iter (compose (dofunc voutch) (sepfunc voutch) ) tail
		end
end
;;

let print_id voutch id = begin
	fprintf voutch "%s" (String.concat "/" id);
	flush stdout
end
;;
let print_v_number voutch numb = begin
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
;;
let rec print_v_primary voutch prim = begin
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
		let i1=Expression.exp2int_simple exp1
		and i2=Expression.exp2int_simple exp2 in begin
			fprintf voutch " %d .. %d " i1 i2;
		end
	end
	| T_range_int(lft,rgt) -> begin
		fprintf voutch "%d" lft;
		fprintf voutch "%s"  " : ";
		fprintf voutch "%d" rgt;
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
and find_pin_exp pinname npclst = begin
    try
      let cmp_pin x = begin
        match x with
        T_named_port_connection(str1,_) -> begin
          if(Misc.string_equ pinname str1) then true
          else false
        end
        | _ -> false
      end
      in
      let pin = List.find cmp_pin npclst
      in begin
        match pin with
        T_named_port_connection(str1,pinexp) -> begin
          if ( Misc.string_equ str1 pinname ) then begin
						match pinexp with
						T_primary(T_primary_id([str])) -> str
						|_-> begin
							print_v_expression stdout pinexp;
							printf "port name %s\n" str1;
							flush stdout;
							assert false
						end
					end
          else assert false
        end
        | _ -> assert false
      end
    with Not_found -> assert false
end
and exp2lv exp = begin
	match exp with
	T_primary(prim) -> begin
		match prim with
		T_primary_id(strlst) -> T_lvalue_id(strlst)
		|T_primary_arrbit(strlst,idxexp) -> T_lvalue_arrbit(strlst,idxexp)
		|_-> assert false
	end
	| _-> assert false
end
and print_v_module_item_gates voutch  clkstr moditm = begin
	match moditm with
		T_module_instantiation(name,_,paramasslst,milst) -> begin
			assert ((List.length paramasslst)=0);
			match milst with
			[T_module_instance(_,T_list_of_module_connections_named(npclst))] -> begin
				match name with
				"OR2" -> begin
					let zlv = find_pin_exp "Z" npclst
					and aexp= find_pin_exp "A" npclst 
					and bexp= find_pin_exp "B" npclst in begin
						fprintf voutch ".names %s %s %s \n" aexp bexp zlv;
						fprintf voutch "1- 1 \n";
						fprintf voutch "-1 1 \n";
					end
				end
				|"AN2" -> begin
					let zlv = find_pin_exp "Z" npclst
					and aexp= find_pin_exp "A" npclst 
					and bexp= find_pin_exp "B" npclst in begin
						fprintf voutch ".names %s %s %s \n" aexp bexp zlv;
						fprintf voutch "11 1 \n";
					end
				end
				|"IV" -> begin
					let zlv = find_pin_exp "Z" npclst
					and aexp= find_pin_exp "A" npclst in begin
						fprintf voutch ".names %s %s \n" aexp zlv;
						fprintf voutch "0 1 \n";
					end
				end
				|"FD1" -> begin
					let qlv = find_pin_exp "Q" npclst
					and dexp= find_pin_exp "D" npclst in begin
						(*fprintf voutch ".latch %s %s re %s 0\n" dexp qlv clkstr ;*)
						fprintf voutch ".latch %s %s 0\n" dexp qlv  ;
					end
				end
				|_-> assert false
			end
			|_-> assert false
		end
		|_-> ()
end
and print_v_module_item_outputs voutch moditm = begin
	match moditm with
		| T_output_declaration(rng, strlst) -> begin
			let print_input i =begin
				match rng with
				T_range(_,_) -> assert false
				| T_range_NOSPEC -> begin
					fprintf voutch " %s" i;
				end
				| _-> assert false
			end in 
			List.iter print_input strlst;
		end
		|_-> ()
end
and print_v_module_item_inputs voutch clkstr moditm = begin
	match moditm with
		| T_input_declaration(rng, strlst) -> begin
			let print_input i =begin
				match rng with
				T_range(_,_) -> assert false
				| T_range_NOSPEC -> begin
					if(i<>clkstr) then
						fprintf voutch " %s" i;
				end
				| _-> assert false
			end in 
			List.iter print_input strlst;
		end
		|_-> ()
end
and print_v_module_item voutch moditm = begin
	match moditm with 
		T_parameter_declaration(param_assignment_list)  -> assert false
		| T_input_declaration(rng, strlst) -> begin
			let print_input i =begin
				fprintf voutch "INPUT %s : " i;
				match rng with
				T_range(_,_) -> begin
					fprintf voutch "array ";
					print_v_range voutch rng;
					fprintf voutch " of boolean ; \n"
				end
				| T_range_NOSPEC -> begin
					fprintf voutch " boolean ; \n"
				end
				| _-> assert false
			end in 
			List.iter print_input strlst;
		end
		| T_output_declaration(rng, strlst) -> begin
			let print_input i =begin
				fprintf voutch "OUTPUT %s : " i;
				match rng with
				T_range(_,_) -> begin
					fprintf voutch "array ";
					print_v_range voutch rng;
					fprintf voutch " of boolean ; \n"
				end
				| T_range_NOSPEC -> begin
					fprintf voutch " boolean ; \n"
				end
				| _-> assert false
			end in 
			List.iter print_input strlst;
		end
		| T_inout_declaration(rng, strlst) -> assert false
		| T_net_declaration(nettype,chg_strg,exprang,dly,strlst) -> begin
			let print_wire w = begin
				fprintf voutch "%s :" w;
				match exprang with
				T_expandrange_range(rng) -> begin
					fprintf voutch "array ";
					print_v_range voutch rng;
					fprintf voutch " of boolean ; \n"
				end
				|  T_expandrange_NOSPEC-> begin
					fprintf voutch " boolean ; \n"
				end
				| _-> assert false
			end in
			List.iter print_wire strlst;
		end
		| T_reg_declaration(rng,regvlst) -> assert false
		| T_time_declaration(regvlst) -> assert false
		| T_integer_declaration(regvlst) -> assert false
		| T_real_declaration(strlst) -> assert false
		| T_event_declaration(strlst) -> assert false
		| T_gate_declaration(gatetyp,drvstr,dly,gateinslst) -> assert false
		| T_module_instantiation(name,_,paramasslst,milst) -> begin
			assert ((List.length paramasslst)=0);
			match milst with
			[T_module_instance(_,T_list_of_module_connections_named(npclst))] -> begin
				match name with
				"OR2" -> begin
						fprintf voutch " ;\n";
				end
				|"AN2" -> begin
						fprintf voutch " ;\n";
				end
				|"IV" -> begin
						fprintf voutch " ;\n";
				end
				|"FD1" -> begin
						fprintf voutch " ;\n";
				end
				|_-> assert false
			end
			|_-> assert false
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
and findoutclock portlst moditmlst = begin
	let pred_latch mi = begin
		match mi with
		T_module_instantiation(name,_,paramasslst,milst) -> begin
			assert ((List.length milst)=1);
			match name with
			"FD1" -> true
			|_-> false
		end
		|_-> false
	end in
	let fd1lst=List.filter pred_latch moditmlst in
	let proc_latch2clk mi =begin
		match mi with
		T_module_instantiation("FD1",_,_,[T_module_instance(_,T_list_of_module_connections_named(npclst))]) -> find_pin_exp "CP" npclst
		|_-> assert false
	end in
	let clkstrlst=List.map proc_latch2clk fd1lst in
	let clkstr=begin
		match clkstrlst with
		[] -> ""
		| _ -> List.hd clkstrlst
	end 
	in begin
		assert (List.for_all (fun x -> Misc.string_equ x clkstr) clkstrlst);
		clkstr
	end
end
and print_v_module_def voutch inst_module_def = begin
	begin
	match inst_module_def with
	T_module_def(modname,portlst,moditmlst) -> 
	begin
		let clkstr = findoutclock portlst moditmlst in begin
			fprintf voutch ".model %s\n"  modname   ;

			fprintf voutch ".inputs "     ;
			List.iter (print_v_module_item_inputs voutch clkstr ) moditmlst;
			fprintf voutch "\n"     ;

			fprintf voutch ".outputs "     ;
			List.iter (print_v_module_item_outputs voutch ) moditmlst;
			fprintf voutch "\n"     ;
			
			if(clkstr<>"") then begin
				fprintf voutch ".clock %s\n" clkstr;
			end;

			List.iter (print_v_module_item_gates voutch clkstr ) moditmlst;
		end;
		fprintf voutch ".end\n"
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
and get_str_from_strlst strlst = String.concat "/" strlst
and list_last lst = begin
	match lst with
	[] -> begin
		Printf.printf "fatal error : should not reach empty list \n";
		exit 1
	end
	| [last] -> last
	| _  -> list_last (List.tl lst)
end
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
						and posrp=String.index strname ']'
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
;;
