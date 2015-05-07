(*correctly found the parameter, but
1 can not characterize
2 too slow
*)

open Printf
open Typedef
open Typedefcommon
open Circuit_obj
open Print_v
open Misc2
open Misc
open Statement
open Misc2
open Dependent
open Str
open Clauseman
open Interp
open Bddssy
open Aig
open Dumpsat
open Gftype
open Printf

exception UNSAT

		

class elabmod = 
object (self)

	(*these will be generated in init method*)
val mutable name = ""
val mutable portlist = []
val mutable tempdirname = ""

(*these will be generated in elaborate method*)
val mutable miArray : module_item array =  Array.make 1 ("","",[],[],[])
val mutable miArrayPointer : int =0
val mutable hashInputName2Range : (str,range)  Hashtbl.t= Hashtbl.create 100
val mutable hashOutputName2Range : (str,range)  Hashtbl.t= Hashtbl.create 100
val mutable hashWireName2Range : (str,range)  Hashtbl.t= Hashtbl.create 100





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
		miArrayInit len;
		List.iter (self#proc_MI) milist 
	end
	| _ -> 
		assert fale 
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

method proc_T_input_declaration range namelst = 
begin
	let proc_one_input name1 = 
	begin
		assert(self#nameInportlist name1);
		assert ((Hashtbl.mem hashInputName2Range name1)=false);
		assert ((Hashtbl.mem hashOutputName2Range name1)=false);
		assert ((Hashtbl.mem hashWireName2Range name1)=false);

		Hashtbl.replace hashInputName2Range name1 range
	end
	in 
	List.iter proc_one_input namelst
end

method proc_T_output_declaration range namelst = begin
	let proc_one_output name1 = begin
		assert(self#nameInportlist name1) ;
		assert ((Hashtbl.mem hashInputName2Range name1)=false);
		assert ((Hashtbl.mem hashOutputName2Range name1)=false);
		assert ((Hashtbl.mem hashWireName2Range name1)=false);
		
		Hashtbl.replace hashOutputName2Range name1 range
	end
	in 
	List.iter proc_one_output namelst
end

method proc_T_net_declaration nettypename exprng namelst = begin
	if (string_equ nettypename "wire") = false then begin
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
	let proc_one_net name1 = begin
		(*add it to circuit object list*)
		assert ((Hashtbl.mem hashInputName2Range name1)=false);
		assert ((Hashtbl.mem hashOutputName2Range name1)=false);
		assert ((Hashtbl.mem hashWireName2Range name1)=false);

		Hashtbl.replace hashWireName2Range name1 range
	end
	in 
	List.iter proc_one_net namelst
end

method getX pname npclst = begin
	let isX npc = begin
		match npc with
		(str,exp) -> str=pname
	end
	in begin
		try
			List.find isX npclst
		with Not_found -> []
	end
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
	end
	| _ -> assert false
end

method miArrayInit sz = begin
	miArray <- Array.make sz ("","",[],[],[]);
	miArrayPointer <- 0;
end

method miArrayAdd co = begin
	assert (miArrayPointer<(length miArray));
	assert ((miArray.(miArrayPointer))=T_null_declaration);
	Array.set miArray miArrayPointer co;
	miArrayPointer <- miArrayPointer +1;
end

method nameInportlist name1 = begin
	let check_portname pt = begin
		match pt with 
		[ptn] -> string_equ ptn name1
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
		let tnlv= begin
			match lv with
			T_lvalue_id([str]) -> TYPE_NET_ID(str)
			| T_lvalue_arrbit([str],exp1) -> begin
				let idx=exp2int_simple exp1
				in
				TYPE_NET_ARRAYBIT(str,idx)
			end
		end
		in
		let tnrexp=begin
			match exp with
			T_primary(T_primary_id([str]))  -> TYPE_NET_ID(str)
			| T_primary(T_primary_num(T_number_base("1","b",0))) -> 
				TYPE_NET_CONST(0)
			| T_primary(T_primary_num(T_number_base("1","b",1))) -> 
				TYPE_NET_CONST(1)
			| T_primary(T_primary_arrbit([str],exp1)) -> begin
				let idx=exp2int_simple exp1
				in
				TYPE_NET_ARRAYBIT(str,idx)
			end
			| _ -> assert false
		end
		let newmi=("BUF","",[tnlv],[tnrexp])
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
	self#construct_boolonly_netlist ;
end
	
method construct_boolonly_netlist = begin
	printf "construct_boolonly_netlist start\n";
	flush stdout;

	self#writeFlatNetlist ;
end

method writeFlatNetlist = begin
	printf "module %s (\n" name;
	(*print list of input and outputs*)
	let procPrintOutput str range  = begin
		match range with
		T_range_NOSPEC ->
			printf "  output %s,\n" str
		| T_range_int(lv,rv) ->
			printf "  output [%d:%d] %s,\n" name lv rv
		| _ -> assert false
	end
	in
	iter procPrintOutput hashOutputName2Range;

	let procPrintInput str range = begin
		match range with
		T_range_NOSPEC -> 
			printf "  input %s,\n" str
		| T_range_int(lv,rv) -> 
			printf "  input [%d:%d] %s,\n"  lv rv str
		| _ -> assert false
	end
	in
	iter procPrintInput hashInputName2Range; 

	printf "input xx);\n";

	let procPrintWire str range = begin
		match range with
		T_range_NOSPEC -> 
			printf "  wire %s,\n" str
		| T_range_int(lv,rv) -> 
			printf "  wire [%d:%d] %s,\n"  lv rv str
		| _ -> assert false
	end
	in
	iter procPrintWire hashWireName2Range;

	let procPrintCell mi = begin
		match mi with
		("AN2",instname,[ztn],[atn],[btn]) -> 
		begin
			let zname=getTNname ztn
			and aname=getTNname atn
			and bname=getTNname btn
			in
			printf "  AN2 %s (.Z(%s),.A(%s),.B(%s));" instname zname aname bname
		end
		| ("OR2",instname,[ztn],[atn],[btn]) -> 
		begin
			let zname=getTNname ztn
			and aname=getTNname atn
			and bname=getTNname btn
			in
			printf "  OR2 %s (.Z(%s),.A(%s),.B(%s));" instname zname aname bname
		end
		| ("IV",instname,[ztn],[atn],[btn]) -> 
		begin
			let zname=getTNname ztn
			and aname=getTNname atn
			and bname=getTNname btn
			in
			printf "  OR2 %s (.Z(%s),.A(%s),.B(%s));" instname zname aname bname
		end
	end
	in
	iter procPrintCell miArray;

	printf "endmodule\n"
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
