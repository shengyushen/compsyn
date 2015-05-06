open Printf
open Str


type type_net =
	TYPE_NET_ID of string
	| TYPE_NET_CONST of int
	| TYPE_NET_ARRAYBIT of string*int
	| TYPE_NET_NULL
;;

type type_ion = 
	TYPE_CONNECTION_NET 
	| TYPE_CONNECTION_IN 
	| TYPE_CONNECTION_OUT
;;

type type_connection = 
	type_ion*type_net

(*the tuple are operation type and instance name, 
and is Z output, the rest are inputs
empty operation type means NULL*)
type type_flat =
	string*string*(type_connection list)*(type_connection list)*(type_connection list)
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

type type_gfdata = 
	TYPE_GFDATA_GF1024 of type_connection list
	| TYPE_GFDATA_GF3232 of type_connection list
	| TYPE_GFDATA_BOOL of type_connection
	| TYPE_GFDATA_NULL


let rec mapname str idx = begin
	sprintf "%s_inst_%d" str idx
end
and mapnet idx tnet = begin
	match tnet with
	TYPE_NET_ID(str) -> begin
		let newstr=mapname str idx 
		in
		TYPE_NET_ID(newstr)
	end
	| TYPE_NET_CONST(_) -> tnet
	| TYPE_NET_ARRAYBIT(str,id) -> begin
		let newstr=mapname str idx 
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
and map2prevInstanceDnet idx tnet = begin
	match tnet with
	TYPE_NET_ID(str) -> begin
		assert (idx >=1);
		let nonQstr=global_replace (regexp "_Q$") "_D" str 
		in
		TYPE_NET_ID(mapname nonQstr (idx-1))
	end
	| TYPE_NET_ARRAYBIT(str,idx) -> begin
		printf "map2prevInstanceDnet arr bit %s[%d]\n" str idx;
		assert false
	end
	| TYPE_NET_CONST(_) ->  tnet
	| _ -> assert false
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




