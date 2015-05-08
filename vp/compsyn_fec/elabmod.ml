
open Printf
open Array
open List
open Str

open Typedef
open Misc
open Interp
open Dumpsat
open Gftype
open Printf

class elabmod = 
object (self)

	(*these will be generated in init method*)
val mutable name = ""
val mutable portlist = []
val mutable tempdirname = ""

val mutable miArray : (string*string*(type_net list)*(type_net list)*(type_net list)) array =  Array.make 1 ("","",[],[],[])
val mutable miArrayPointer : int =0
(*using range because some wire dont have range,
so I need T_range_NOSPEC*)
val mutable hashWireName2Range : (string,(type_ion*range))  Hashtbl.t= Hashtbl.create 100


(* build from construct_boolonly_netlist *)


method init module2beElaborated tempdirname1 = 
begin
	match module2beElaborated with
	T_module_def(modName,portlist1,milist) -> 
	begin
		name <- modName;
		portlist <- portlist1;
		tempdirname <- tempdirname1;
		(*processing mi list*)
		let len=length milist
		in
		self#miArrayInit len;
		List.iter (self#proc_MI) milist 
	end
	| _ -> 
		assert false 
end

method proc_MI mi = 
begin
	match mi with
	T_input_declaration(range,namelst) -> 
		self#proc_T_input_declaration range namelst
	| T_output_declaration(range,namelst) -> 
		self#proc_T_output_declaration range namelst
	| T_net_declaration(netn,_,exprng,_,namelst) -> 
		self#proc_T_net_declaration netn exprng namelst
	| T_module_instantiation(defname,_,_,milst) -> 
		self#proc_T_module_instantiation defname milst
	| T_continuous_assign(cont_ass) ->  
		self#proc_T_continuous_assign cont_ass
	| _ -> assert false
end

method proc_T_input_declaration range namelst = begin
	let newrng=rngsimple range
	in
	let proc_one_input name1 = 
	begin
		assert(self#nameInportlist name1);
		assert ((Hashtbl.mem hashWireName2Range name1)=false);

		Hashtbl.replace hashWireName2Range name1 (TYPE_CONNECTION_IN,newrng)
	end
	in 
	List.iter proc_one_input namelst
end

method proc_T_output_declaration range namelst = begin
	let newrng=rngsimple range
	in
	let proc_one_output name1 = begin
		assert(self#nameInportlist name1) ;
		assert ((Hashtbl.mem hashWireName2Range name1)=false);
		
		Hashtbl.replace hashWireName2Range name1 (TYPE_CONNECTION_OUT,newrng)
	end
	in 
	List.iter proc_one_output namelst
end

method proc_T_net_declaration nettypename exprng namelst = begin
	if (nettypename="wire") = false then begin
		Printf.printf "fatal error : only supported wire\n";
		Printf.printf "%s\n" nettypename;
		exit 1
	end
	;
	let range = match exprng with
	T_expandrange_range(rng1) -> rng1
	| T_expandrange_NOSPEC -> T_range_NOSPEC
	|_ -> begin
		Printf.printf "fatal error : only supported T_expandrange_range\n";
		exit 1
	end
	in 
	let newrng=rngsimple range
	in
	let proc_one_net name1 = begin
		(*add it to circuit object list*)
		assert ((Hashtbl.mem hashWireName2Range name1)=false);

		Hashtbl.replace hashWireName2Range name1 (TYPE_CONNECTION_NET,newrng)
	end
	in 
	List.iter proc_one_net namelst
end

method getX pname npclst = begin
	try
		let isX npc = begin
			match npc with
			T_named_port_connection(str,_) -> str=pname
		end
		in
		let x=List.find isX npclst
		in begin
			match x with
			T_named_port_connection(_,exp) -> 
				exp2tnlst exp
		end
	with Not_found -> []
end

method proc_T_module_instantiation defname milst = begin
	match milst with
	[T_module_instance(instname,mclst)] -> begin
		match mclst with
		T_list_of_module_connections_named(npclst) -> begin
			let ztnl=self#getX "Z" npclst
			and atnl=self#getX "A" npclst
			and btnl=self#getX "B" npclst
			in
			let newmi=(defname,instname,ztnl,atnl,btnl)
			in
			self#miArrayAdd newmi
		end
		| _ -> assert false
	end
	| _ -> assert false
end

method miArrayInit sz = begin
	miArray <- Array.make sz ("","",[],[],[]);
	miArrayPointer <- 0;
end

method miArrayAdd co = begin
	assert (miArrayPointer<(Array.length miArray));
	assert ((miArray.(miArrayPointer))=("","",[],[],[]));
	Array.set miArray miArrayPointer co;
	miArrayPointer <- miArrayPointer +1;
end

method nameInportlist name1 = begin
	let check_portname pt = begin
		match pt with 
		[ptn] ->  ptn=name1
		|_ -> begin
			Printf.printf "fatal error : port name should not be a list\n";
			exit 1
		end
	end
	in 
	List.exists check_portname  portlist
end
	
method proc_T_continuous_assign cont_ass = begin
	match cont_ass with
	T_continuous_assign_assign(_,_,[T_assignment(lv,exp)]) -> begin
		let tnlv= lv2tn lv
		in
		let tnrexplst=exp2tnlst exp
		in
		let newmi=("BUF","",[tnlv],tnrexplst,[])
		in
		self#miArrayAdd newmi
	end
	| _ -> 
		assert false
end
	
	
method compsyn (stepList :(string*int*int) list list) (unfoldNumber:int) = 
begin
	set_current_time;
	(*first construct the data structure with bool only*)
	self#writeFlatNetlist ;
	self#unfold_bool_netlist unfoldNumber ;
end
	
method unfold_bool_netlist unfoldNumber= begin
	printf "construct_boolonly_netlist start\n";
	flush stdout;



end

method writeFlatNetlist = begin
	let flat_c = open_out "flat.v" 
	in begin
		fprintf flat_c "module %s (\n" name;
		(*print list of input and outputs*)
		let procPrintOutput str ionrange  = begin
			match ionrange with
			(TYPE_CONNECTION_OUT,T_range_NOSPEC) ->
				fprintf flat_c "  output %s,\n" str
			| (TYPE_CONNECTION_OUT,T_range_int(lv,rv)) ->
				fprintf flat_c "  output [%d:%d] %s,\n" lv rv str
			| (TYPE_CONNECTION_OUT,_) -> 
				assert false
			| _ -> ()
		end
		in
		Hashtbl.iter procPrintOutput hashWireName2Range;
	
		let procPrintInput str ionrange = begin
			match ionrange with
			(TYPE_CONNECTION_IN,T_range_NOSPEC) -> 
				fprintf flat_c "  input %s,\n" str
			| (TYPE_CONNECTION_IN,T_range_int(lv,rv)) -> 
				fprintf flat_c "  input [%d:%d] %s,\n"  lv rv str
			| (TYPE_CONNECTION_IN,_) -> 
				assert false
			| _ -> ()
		end
		in
		Hashtbl.iter procPrintInput hashWireName2Range; 
	
		fprintf flat_c "input xx);\n";
	
		let procPrintWire str ionrange = begin
			match ionrange with
			(TYPE_CONNECTION_NET,T_range_NOSPEC) -> 
				fprintf flat_c "  wire %s;\n" str
			| (TYPE_CONNECTION_NET,T_range_int(lv,rv)) -> 
				fprintf flat_c "  wire [%d:%d] %s;\n"  lv rv str
			| (TYPE_CONNECTION_NET,_) -> 
				assert false
			| _ -> ()
		end
		in
		Hashtbl.iter procPrintWire hashWireName2Range;
	
		let procPrintCell mi = begin
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
			| ("BUF","",[ztn],[atn],[]) -> begin
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
		in
		Array.iter procPrintCell miArray;
	
		fprintf flat_c "endmodule\n";

		close_out flat_c;
	end
end

(*
	method handleInputStepList stepList = begin
		assert ((Hashtbl.length hashTnetValue)=0);
		let procStringInt idx x = begin
			match x with
			(str,arridx,i) -> begin
				assert (i=0 || i=1);
				let newstr=mapname str idx 
				in
				let tnet=begin
					if(arridx<0) then begin
						printf "adding %s = %d\n" newstr i;
						TYPE_NET_ID(newstr)
					end
					else begin
						printf "adding %s[%d] = %d\n" newstr arridx i;
						TYPE_NET_ARRAYBIT(newstr,arridx)
					end
				end
				in begin
					Hashtbl.add hashTnetValue tnet (TYPE_NET_CONST(i));
					(tnet,(TYPE_NET_CONST(i)))
				end
			end
		end
		in
		let procStep i stp = begin
			List.map (procStringInt i) stp;
		end
		in
		let rec procStepList i stpl= begin
			match stpl with
			[] ->[]
			| hd::tl -> begin
				let currentList=procStep i hd
				and remainList=procStepList (i+1) tl 
				in
				currentList @ remainList
			end
		end
		in 
		procStepList 0 stepList
	end
*)



	method genDecoderFunction iv shift ov instCNF = begin
		let maxidxR=get_largest_varindex_inclslst instCNF in 
		let shiftedIV=List.map (fun x -> x+shift) iv in 
		let clslst_shift = begin
			List.iter (fun x -> assert(x<=maxidxR)) shiftedIV;
			List.iter (fun x -> assert(x<=maxidxR)) ov;
			shiftclslst instCNF ov maxidxR
		end 
		in 
		characterization_interp_AB_mass iv shift instCNF clslst_shift maxidxR ov
	end

	

end
