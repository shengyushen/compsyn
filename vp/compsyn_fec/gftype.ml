open Printf
open Str
open Typedef


type type_net =
	TYPE_NET_ID of string
	| TYPE_NET_CONST of bool
	| TYPE_NET_ARRAYBIT of string*int
	| TYPE_NET_NULL
;;

let rec getTNname tn = begin
	match tn with
	TYPE_NET_ID(str) -> str
	| TYPE_NET_ARRAYBIT(str,idx) -> sprintf "%s[%d]" str idx
	| TYPE_NET_CONST(false) -> "1'b0"
	| TYPE_NET_CONST(true)  -> "1'b1"
	| TYPE_NET_NULL -> ""
end
and  getTNStr tn = begin
	match tn with
	TYPE_NET_ID(str) -> str
	| TYPE_NET_ARRAYBIT(str,_) -> str
	| _ -> ""
end
and getTNLname tnl = begin
	let nl=List.map getTNname tnl
	in
(*
	let rec prt l = begin
		match l with
		[hd] -> hd
		| hd::tl -> begin
			let remain=prt tl
			in
			sprintf "%s,%s" hd remain
		end
		| _ -> assert false
	end
	in
	let res=prt nl
*)
	let res=String.concat "," nl
	in
	sprintf "{ %s }" res
end

type type_ion = 
	TYPE_CONNECTION_NET 
	| TYPE_CONNECTION_IN 
	| TYPE_CONNECTION_OUT
;;



let rec exp2tn exp = begin
	match exp with
	T_primary(T_primary_num(T_number_base(1,'b',"0"))) ->
		TYPE_NET_CONST(false)
	| T_primary(T_primary_num(T_number_base(1,'b',"1"))) ->
		TYPE_NET_CONST(true)
	| T_primary(T_primary_id([str])) ->
		TYPE_NET_ID(str)
	| T_primary(T_primary_arrbit([str],exp)) ->
		TYPE_NET_ARRAYBIT(str,(exp2int_simple exp))
	| _ -> begin
		printf "FATAL : improper expression in exp2tn\n";
		print_v_expression stdout exp;
		flush stdout;
		assert false
	end
end
and exp2tnlst exp = begin
	match exp with
	T_primary(T_primary_concat(explst)) -> begin
		List.map (exp2tn) explst
	end
	| T_primary(T_primary_arrrange([str],exp1,exp2)) -> begin
		let lidx=exp2int_simple exp1
		and ridx=exp2int_simple exp2
		in 
		let idxlst=lr2list lidx ridx
		in
		List.map (fun x -> TYPE_NET_ARRAYBIT(str,x)) idxlst
	end
	| _ -> [exp2tn exp]
end
and lv2tn lv = begin
	match lv with
	T_lvalue_id([str]) -> TYPE_NET_ID(str)
	| T_lvalue_arrbit([str],exp1) -> begin
		let idx=exp2int_simple exp1
		in
		TYPE_NET_ARRAYBIT(str,idx)
	end
	| _ -> assert false
end
and isConstTN tn = begin
	match tn with 
	TYPE_NET_CONST(_) -> true
	| _ -> false
end
and isConstTNL tnl = begin
	List.for_all isConstTN tnl
end
;;


type gftype = 
	GFTYPE_TNLIST of type_net list
	| GFTYPE_ADD of gftype*gftype
	| GFTYPE_MULT of gftype*gftype

