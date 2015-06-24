
open Printf
open Array
open Stack
open Queue
open List
open Str

open Typedef
open Misc
open Intlist
open Interp
open Dumpsat
open Gftype
open Printf

class elabmod = fun debugFlag ->
object (self)

	(*these will be generated in init method*)
val mutable name = ""
val mutable portlist = []
val mutable tempdirname = ""

(* the original module  *)
val mutable cellStack : (string*string*(type_net list)*(type_net list)*(type_net list)*(type_net list)) Stack.t = Stack.create ()
(*using range because some wire dont have range,
so I need T_range_NOSPEC*)
val mutable hashWireName2Range : (string,(type_ion*range))  Hashtbl.t= Hashtbl.create 100

val mutable cellArray  = Array.make 1 ("","",[],[],[],[]) 
val mutable cellArrayPointer = 0
val mutable hashTNL2gftype : ((type_net list),gftype) Hashtbl.t = Hashtbl.create 10000


method init module2beElaborated tempdirname1 = 
begin
	match module2beElaborated with
	T_module_def(modName,portlist1,milist) -> 
	begin
		name <- modName;
		portlist <- portlist1;
		tempdirname <- tempdirname1;
		(*processing mi list*)
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
		if (Hashtbl.mem hashWireName2Range name1) then 
			printf "Error : duplicated wire definition %s\n" name1
		else 
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
			and stnl=self#getX "S" npclst
			in
			let newmi=(defname,instname,ztnl,atnl,btnl,stnl)
			in
			Stack.push  newmi cellStack
		end
		| _ -> assert false
	end
	| _ -> assert false
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
		let newmi=("BUF","",[tnlv],tnrexplst,[],[])
		in
		Stack.push  newmi cellStack
	end
	| _ -> 
		assert false
end

method getInputData = begin
	let inputList = Hashtbl.fold (fun k d t -> match d with (TYPE_CONNECTION_IN,range) -> (k,range)::t | _ -> t) hashWireName2Range []
	in begin
		assert (isSingularList inputList);
		List.hd inputList
	end
end


method getParity = begin
	let outputList = Hashtbl.fold (fun k d t -> match d with (TYPE_CONNECTION_OUT,range) -> (k,range)::t | _ -> t) hashWireName2Range []
	in begin
		assert (isSingularList outputList);
		List.hd outputList
	end
end

method compsyn (fieldSize:int) (zero: int list) (one : int list) = begin
	set_current_time;
	
	let (inputName,inputRange) = self#getInputData
	and (parityName,parityRange) = self#getParity
	in
	let (inputLeft,inputRight) = rng2lr inputRange
	and (parityLeft,parityRight) = rng2lr parityRange
	in
	let (baseInputMax,baseParityMax) = begin
		assert ( isDiv ( inputLeft - inputRight + 1 ) fieldSize);
		assert ( isDiv ( parityLeft - parityRight + 1 ) fieldSize);
		assert ( inputLeft > inputRight ) ; 
		assert ( parityLeft > parityRight ) ;

		let baseInputMax = (( inputLeft - inputRight + 1 ) / fieldSize ) - 1
		and baseParityMax = (( parityLeft - parityRight + 1 ) / fieldSize ) - 1
		in
		(baseInputMax,baseParityMax)
	end
	in begin
		printf "inputName : %s [%d:%d]\n" inputName inputLeft inputRight;
		printf "parityName : %s [%d:%d]\n" parityName parityLeft parityRight;

		cellArray <- Array.make (Stack.length cellStack)  ("","",[],[],[],[]);
		cellArrayPointer <- 0;
		let procStackCell cell = begin
			cellArray.(cellArrayPointer) <- cell;
			cellArrayPointer <- cellArrayPointer + 1;
		end
		in
		Stack.iter procStackCell cellStack;
		assert (cellArrayPointer = (Array.length cellArray));

		(*first adding the input gftype*)
		for i = 0 to baseInputMax do
			let l = i*fieldSize + fieldSize -1
			and r = i*fieldSize
			in
			let lst = lr2list l r
			in 
			let tnl = List.map (fun x -> TYPE_NET_ARRAYBIT(inputName,x)) lst
			in 
			Hashtbl.add hashTNL2gftype tnl (GFTYPE_WIRE(sprintf "%s_%d" inputName i))
		done
		;

		for i = 0 to baseParityMax do
			let l = i*fieldSize + fieldSize -1
			and r = i*fieldSize
			in
			let lst = lr2list l r
			in
			let tnl = List.map (fun x -> TYPE_NET_ARRAYBIT(parityName,x)) lst
			in
			Hashtbl.add hashTNL2gftype tnl (GFTYPE_WIRE(sprintf "%s_%d" parityName i))
		done
		;

		let tmpCounter = ref 1
		in
		let isProperLength tnl = begin
			(List.length tnl) = fieldSize
		end
		and allocatingTNLName tnl = begin
			if(isConstTNL tnl)=false then begin
				if(Hashtbl.mem hashTNL2gftype tnl)=false then begin
					Hashtbl.add hashTNL2gftype tnl (GFTYPE_WIRE(sprintf "tmp_%d" (!tmpCounter)));
					tmpCounter := (!tmpCounter) +1
				end
			end
		end
		in
		let procCell cell = begin
			match cell with
			("gfadd_mod",instname,ztnl,atnl,btnl,[]) -> begin
				assert (isProperLength ztnl);
				assert (isProperLength atnl);
				assert (isProperLength btnl);

				allocatingTNLName ztnl;
				allocatingTNLName atnl;
				allocatingTNLName btnl;
			end
			| ("gfmult_flat_mod",instname,ztnl,atnl,btnl,[]) -> begin
				assert (isProperLength ztnl);
				assert (isProperLength atnl);
				assert (isProperLength btnl);

				allocatingTNLName ztnl;
				allocatingTNLName atnl;
				allocatingTNLName btnl;
			end
			| _ -> assert false
		end
		in
		Array.iter procCell cellArray;

		let fc = open_out "poly"
		in
		let getTNLHashName tnl = begin
			if(isConstTNL tnl) then getConstTNLname tnl
			else 
				match Hashtbl.find hashTNL2gftype tnl with
				GFTYPE_WIRE(str) -> str
				| _ -> assert false
		end
		in
		let procCell cell = begin
			match cell with
			("gfadd_mod",instname,ztnl,atnl,btnl,[]) -> begin
				assert (isProperLength ztnl);
				assert (isProperLength atnl);
				assert (isProperLength btnl);

				let aname = getTNLHashName atnl
				and bname = getTNLHashName btnl
				and zname = getTNLHashName ztnl
				in
				fprintf fc "%s = %s + %s \n" zname aname bname 
			end
			| ("gfmult_flat_mod",instname,ztnl,atnl,btnl,[]) -> begin
				assert (isProperLength ztnl);
				assert (isProperLength atnl);
				assert (isProperLength btnl);

				let aname = getTNLHashName atnl
				and bname = getTNLHashName btnl
				and zname = getTNLHashName ztnl
				in
				fprintf fc "%s = %s * %s \n" zname aname bname 
			end
			| _ -> assert false
		end
		in begin
			Array.iter procCell cellArray;
			close_out fc;
		end

	end
end


end
