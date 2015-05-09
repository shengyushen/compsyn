open Printf
open Str
open Typedef


type type_net =
	TYPE_NET_ID of string
	| TYPE_NET_CONST of int
	| TYPE_NET_ARRAYBIT of string*int
	| TYPE_NET_NULL
;;

let rec getTNname tn = begin
	match tn with
	TYPE_NET_ID(str) -> str
	| TYPE_NET_CONST(i) -> sprintf "1'b%d" i
	| TYPE_NET_ARRAYBIT(str,idx) -> sprintf "%s[%d]" str idx
	| TYPE_NET_NULL -> ""
end
and getTNLname tnl = begin
	let nl=List.map getTNname tnl
	in
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
	in
	sprintf "{ %s }" res
end

type type_ion = 
	TYPE_CONNECTION_NET 
	| TYPE_CONNECTION_IN 
	| TYPE_CONNECTION_OUT
;;




(*the tuple are operation type and instance name, 
and is Z output, the rest are inputs
empty operation type means NULL*)
type type_cell =
	string*string*(type_net list)*(type_net list)*(type_net list)
;;

(*similar to type_flat but with index to an array of type_gfdata*)
type type_2opgf = 
	GFADD
	| GFMULTFLAT
	| GFMULT
	| GFDIV
;;
type type_1opgf = 
	TOWER2FLAT
	| FLAT2TOWER
;;
type type_2opbool =
	EO 
	| AN2
	| OR2
;;
type type_gfmod = 
	TYPE_GFMOD_2OPGF      of type_2opgf*string*int*int*int
 |TYPE_GFMOD_1OPGF      of type_1opgf*string*int*int
 |TYPE_GFMOD_2OPBOOL    of type_2opbool*string*int*int*int
 |TYPE_GFMOD_IV         of string*int*int
 |TYPE_GFMOD_NULL
;;

(*
type type_gfdata = 
	TYPE_GFDATA_GF1024 of type_connection list
	| TYPE_GFDATA_GF3232 of type_connection list
	| TYPE_GFDATA_BOOL of type_connection
	| TYPE_GFDATA_NULL
*)


let rec mapname idx str = begin
	sprintf "%s_inst_%d" str idx
end
and maptnet idx tnet = begin
	match tnet with
	TYPE_NET_ID(str) -> begin
		let newstr=mapname idx str
		in
		TYPE_NET_ID(newstr)
	end
	| TYPE_NET_CONST(_) -> tnet
	| TYPE_NET_ARRAYBIT(str,id) -> begin
		let newstr=mapname idx str 
		in
		TYPE_NET_ARRAYBIT(newstr,id)
	end
	| TYPE_NET_NULL -> tnet
end
and isQstr str = begin
	string_match (regexp "^.*_Q$") str 0
end
and print_type_ion tion = begin
	match tion with
	TYPE_CONNECTION_NET -> 
		Printf.printf " TYPE_CONNECTION_NET "
	| TYPE_CONNECTION_IN -> 
		Printf.printf " TYPE_CONNECTION_IN "
	| TYPE_CONNECTION_OUT -> 
		Printf.printf " TYPE_CONNECTION_OUT "
end
and print_type_net tnet = begin
	match tnet with
	TYPE_NET_ID(str) ->  begin
		assert (str<>"");
		printf " %s " str
	end
	| TYPE_NET_CONST(i) -> 
		printf " %d "  i
	| TYPE_NET_ARRAYBIT(str,idx) -> 
		printf " %s[%d] " str idx
	| TYPE_NET_NULL -> ()
end
and print_type_connection tc = begin
	match tc with
	(tion,tnet) -> begin
(*		print_type_ion tion; *)
		print_type_net tnet;
	end
end
and print_type_connection_list tclst = begin
	List.iter (print_type_connection) tclst
end
(*
and print_gfdata gfdata = begin
	match gfdata with
	TYPE_GFDATA_GF1024(tclst) -> begin
		Printf.printf "TYPE_GFDATA_GF1024 ";
		print_type_connection_list tclst;
		printf "\n";
	end
	| TYPE_GFDATA_GF3232(tclst) -> begin
		Printf.printf "TYPE_GFDATA_GF3232 ";
		print_type_connection_list tclst;
		printf "\n";
	end
	| TYPE_GFDATA_BOOL(tc) -> begin
		Printf.printf "TYPE_GFDATA_BOOL ";
		print_type_connection tc;
		printf "\n";
	end
	| TYPE_GFDATA_NULL -> assert false
end
*)
and is2OpGF modname = begin
	match modname with
	"gfadd_mod" -> true
	| "gfmult_flat_mod" -> true
	| "gfmult_mod" -> true
	| "gfdiv_mod" -> true
	| _ -> false
end
and is1OpGF modname = begin
	match modname with
	"tower2flat" -> true
	| "flat2tower" -> true
	| _ -> false
end
and isQ tnet = begin
	match tnet with
	TYPE_NET_ID(str) -> isQstr str
	| _ -> false
end
and isDstr str = begin
	string_match (regexp "^.*_D$") str 0
end
and isD tnet = begin
	match tnet with
	TYPE_NET_ID(str) -> isDstr str
	| _ -> false
end
and maptnetQ2D idx tnet = begin
	match tnet with
	TYPE_NET_ID(str) -> begin
		if ((idx >=1) && (isQstr str)) then begin
			let dnet=global_replace (regexp "_Q$") "_D" str 
			in
			let newdnet=mapname (idx-1) dnet
			in
			TYPE_NET_ID(newdnet)
		end
		else begin
			let newstr=mapname idx str
			in
			TYPE_NET_ID(newstr)
		end
	end
	| TYPE_NET_ARRAYBIT(str,idxarr) -> begin
			let newstr=mapname idx str
			in
			TYPE_NET_ARRAYBIT(newstr,idxarr)
	end
	| _ -> tnet
end
and getTypeName2opgf typ = begin
	match typ with
	GFADD -> "gfadd_mod"
	| GFMULTFLAT -> "gfmult_flat_mod"
	| GFMULT -> "gfmult_mod"
	| GFDIV -> "gfdiv_mod"
end
and getTypeName1opgf typ = begin
	match typ with
	TOWER2FLAT -> "tower2flat"
	| FLAT2TOWER -> "flat2tower"
end
and getTypeName2opbool typ =begin
	match typ with
	EO -> "EO"
	| AN2 -> "AN2"
	| OR2 -> "OR2"
end
and is2OpBool modname = begin
	match modname with
	"EO"|"AN2"|"OR2" -> true
	| _ -> false
end
and is1OpBool modname = begin
	match modname with
	"IV" -> true
	| _ -> false
end
and is0Op modname = begin
	match modname with
	"" -> true
	| _ -> false
end
(*
and mapinstance idx tc = begin
	match tc with
	(tion,tnet) -> begin
		match tion with
		TYPE_CONNECTION_NET -> begin
			let newtnet=mapnet idx tnet
			in
			(tion,newtnet)
		end
		| TYPE_CONNECTION_IN -> begin
			if(isQ tnet) then begin
				(*all Q will be used as internal nets that
				connected to previous instance's D net*)
				if(idx=0) then begin
					(*for 0 instance some times I need to set init value*)
					let newtnet=mapnet idx tnet
					in
					(TYPE_CONNECTION_IN,newtnet)
				end
				else begin
					let newtnet=map2prevInstanceDnet idx tnet
					in
					(TYPE_CONNECTION_NET,newtnet)
				end
			end
			else begin
				let newtnet=mapnet idx tnet
				in
				(TYPE_CONNECTION_IN,newtnet)
			end
		end
		| TYPE_CONNECTION_OUT -> begin
			if(isD tnet) then begin
				let newtnet=mapnet idx tnet
				in
				(TYPE_CONNECTION_NET,newtnet)
			end
			else begin
				let newtnet=mapnet idx tnet
				in
				(tion,newtnet)
			end
		end
	end
end
and mapinstanceList idx tclst  = begin
	List.map (mapinstance idx) tclst
end
*)
and exp2tn exp = begin
	match exp with
	T_primary(T_primary_num(T_number_base(1,'b',"0"))) ->
		TYPE_NET_CONST(0)
	| T_primary(T_primary_num(T_number_base(1,'b',"1"))) ->
		TYPE_NET_CONST(1)
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
and procPrintCell flat_c mi  = begin
			match mi with
			("AN2",instname,[ztn],[atn],[btn]) -> begin
				let zname=getTNname ztn
				and aname=getTNname atn
				and bname=getTNname btn
				in
				fprintf flat_c "  AN2 %s (.Z(%s),.A(%s),.B(%s));\n" instname zname aname bname
			end
			| ("OR2",instname,[ztn],[atn],[btn]) -> begin
				let zname=getTNname ztn
				and aname=getTNname atn
				and bname=getTNname btn
				in
				fprintf flat_c "  OR2 %s (.Z(%s),.A(%s),.B(%s));\n" instname zname aname bname
			end
			| ("IV",instname,[ztn],[atn],[]) -> begin
				let zname=getTNname ztn
				and aname=getTNname atn
				in
				fprintf flat_c "  IV %s (.Z(%s),.A(%s));\n" instname zname aname 
			end
			| ("BUF",instname,[ztn],[atn],[]) -> begin
				let zname=getTNname ztn
				and aname=getTNname atn
				in
				fprintf flat_c "  assign %s = %s;\n"  zname aname 
			end
			| ("gfadd_mod",instname,ztnl,atnl,btnl) -> begin
				let zl=getTNLname ztnl
				and al=getTNLname atnl
				and bl=getTNLname btnl
				in 
				fprintf flat_c "  gfadd_mod %s (.Z(%s),.A(%s),.B(%s));\n" instname zl al bl
			end
			| ("gfmult_mod",instname,ztnl,atnl,btnl) -> begin	
				let zl=getTNLname ztnl
				and al=getTNLname atnl
				and bl=getTNLname btnl
				in 
				fprintf flat_c "  gfmult_mod %s (.Z(%s),.A(%s),.B(%s));\n" instname zl al bl
			end
			| ("gfmult_flat_mod",instname,ztnl,atnl,btnl) -> begin	
				let zl=getTNLname ztnl
				and al=getTNLname atnl
				and bl=getTNLname btnl
				in 
				fprintf flat_c "  gfmult_flat_mod %s (.Z(%s),.A(%s),.B(%s));\n" instname zl al bl
			end
			| ("gfdiv_mod",instname,ztnl,atnl,btnl) -> begin	
				let zl=getTNLname ztnl
				and al=getTNLname atnl
				and bl=getTNLname btnl
				in 
				fprintf flat_c "  gfdiv_mod %s (.Z(%s),.A(%s),.B(%s));\n" instname zl al bl
			end
			| ("tower2flat",instname,ztnl,atnl,[]) -> begin	
				let zl=getTNLname ztnl
				and al=getTNLname atnl
				in 
				fprintf flat_c "  tower2flat %s (.Z(%s),.A(%s));\n" instname zl al
			end
			| ("flat2tower",instname,ztnl,atnl,[]) -> begin	
				let zl=getTNLname ztnl
				and al=getTNLname atnl
				in 
				fprintf flat_c "  flat2tower %s (.Z(%s),.A(%s));\n" instname zl al
			end
			| ("","",[],[],[]) ->()
			| (modname,instname,_,_,_) -> begin
				printf "Error : improper %s %s\n" modname instname;
				flush stdout;
				assert false
			end
end
and procPrintWire flat_c str ionrange = begin
			match ionrange with
			(TYPE_CONNECTION_NET,T_range_NOSPEC) -> 
				fprintf flat_c "  wire %s;\n" str
			| (TYPE_CONNECTION_NET,T_range_int(lv,rv)) -> 
				fprintf flat_c "  wire [%d:%d] %s;\n"  lv rv str
			| (TYPE_CONNECTION_NET,_) -> 
				assert false
			| _ -> ()
end
and procPrintOutput flat_c str ionrange  = begin
			match ionrange with
			(TYPE_CONNECTION_OUT,T_range_NOSPEC) ->
				fprintf flat_c "  output %s,\n" str
			| (TYPE_CONNECTION_OUT,T_range_int(lv,rv)) ->
				fprintf flat_c "  output [%d:%d] %s,\n" lv rv str
			| (TYPE_CONNECTION_OUT,_) -> 
				assert false
			| _ -> ()
end
let procPrintInput flat_c str ionrange = begin
			match ionrange with
			(TYPE_CONNECTION_IN,T_range_NOSPEC) -> 
				fprintf flat_c "  input %s,\n" str
			| (TYPE_CONNECTION_IN,T_range_int(lv,rv)) -> 
				fprintf flat_c "  input [%d:%d] %s,\n"  lv rv str
			| (TYPE_CONNECTION_IN,_) -> 
				assert false
			| _ -> ()
end

