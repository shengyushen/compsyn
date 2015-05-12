
open Printf
open Array
open Stack
open Queue
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

(*  *)
val mutable cellStack : (string*string*(type_net list)*(type_net list)*(type_net list)) Stack.t= Stack.create ()
(*using range because some wire dont have range,
so I need T_range_NOSPEC*)
val mutable hashWireName2Range : (string,(type_ion*range))  Hashtbl.t= Hashtbl.create 100

(*unfold data struct*)
(* build from construct_boolonly_netlist *)
(*hold the value in unfolding*)
val mutable hashWireName2RangeUnfold : (string,(type_ion*range))  Hashtbl.t= Hashtbl.create 100
val mutable hashTnetValue : (type_net,type_net) Hashtbl.t = Hashtbl.create 1
val mutable hashTnetSink : (type_net,int list) Hashtbl.t = Hashtbl.create 1
val mutable hashTnetSrc  : (type_net,int     ) Hashtbl.t = Hashtbl.create 1
val mutable cellArrayUnfold = Array.create 1 ("","",[],[],[])
val mutable cellArrayUnfoldValid = Array.create 1 false
val mutable cellArrayUnfoldPointer =0
	(*hold all wires' range and in/out*)


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
			in
			let newmi=(defname,instname,ztnl,atnl,btnl)
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
		let newmi=("BUF","",[tnlv],tnrexplst,[])
		in
		Stack.push  newmi cellStack
	end
	| _ -> 
		assert false
end
	
	
method compsyn stepList  (unfoldNumber:int) = 
begin
	set_current_time;
	(*first construct the data structure with bool only*)
	self#writeFlatNetlist "flat.v" name;

	(*unfold *)
	self#unfold_bool_netlist unfoldNumber ;
	dbg_print "unfold_bool_netlist finish\n";

	let modname=sprintf "%s_unfold_%d" name unfoldNumber
	in
	self#writeUnfoldNetlist "unfold.v" modname;
	dbg_print "writeUnfoldNetlist finish\n";
	
	(*propagate const*)
	self#handleInputStepList stepList;
	dbg_print "handleInputStepList finish\n";

	self#buildSrcSink;
	dbg_print "buildSrcSink finish\n";

 	self#propagateConst stepList; 
	printf "cellArrayUnfold len %d\n" (Array.length cellArrayUnfold);
	dbg_print "propagateConst finish \n";

	let modname=sprintf "%s_unfold_%d_propconst" name unfoldNumber
	in
	self#writeUnfoldPropagatedNetlist "propconst.v" modname;
	dbg_print "writeUnfoldPropagatedNetlist finish\n";
end

method cellArrayUnfold_init sz = begin
	cellArrayUnfold <- Array.create sz ("","",[],[],[]);
	cellArrayUnfoldValid <- Array.create sz false;
	cellArrayUnfoldPointer <- 0;
end

method cellArrayUnfold_add co = begin
	assert (cellArrayUnfoldPointer<(Array.length cellArrayUnfold));
	cellArrayUnfold.(cellArrayUnfoldPointer) <- co;
	cellArrayUnfoldValid.(cellArrayUnfoldPointer) <- true;
	cellArrayUnfoldPointer <- cellArrayUnfoldPointer+1;
end

method unfold_bool_netlist unfoldNumber= begin
	
	(*whether all the wires referred
	by cellStack are in hashWireName2Range*)
	self#checkWireInclusive ;
	dbg_print "checkWireInclusive finished\n";
	
	(*find out the number of wires*)
	let numWire=Hashtbl.fold (self#procSumWireNumber) hashWireName2Range 0
	and numCell = Stack.length cellStack
	in
	let finalWireNum=numWire*unfoldNumber
	and finalCellNum = numCell*unfoldNumber
	in begin
		(*construct unfold data structure*)
		(*hold the value in unfolding*)
		hashTnetValue <- Hashtbl.create finalWireNum;
		(*hold all wires' range and in/out*)
		hashWireName2RangeUnfold <- Hashtbl.create ((Hashtbl.length hashWireName2Range)*unfoldNumber);
		self#cellArrayUnfold_init finalCellNum;
		dbg_print "cellArrayUnfold_init finish\n";

		(*unfold the gates*)
		for i= 0 to (unfoldNumber-1) do
			let procCell co = begin
				match co with
				(defname,instname,ztnl,atnl,btnl) -> begin
					let instname1=mapname i instname
					and ztnl1=List.map (maptnet i) ztnl
					and atnl1=List.map (maptnetQ2D i) atnl
					and btnl1=List.map (maptnetQ2D i) btnl
					in
					let newco=(defname,instname1,ztnl1,atnl1,btnl1)
					in
					self#cellArrayUnfold_add newco
				end
			end
			in
			Stack.iter  procCell cellStack
		done;
		dbg_print "cellArrayUnfold_add finished\n";
		(*unfold the wires*)
		for i= 0 to (unfoldNumber-1) do
			let procWire str tionrange = begin
				match tionrange with
				(TYPE_CONNECTION_IN,range) -> begin
					if((isQstr str) && (i>=1)) then begin
						let newW=(TYPE_CONNECTION_NET,range)
						and newstr=mapname i str
						in
						Hashtbl.replace hashWireName2RangeUnfold newstr newW
					end
					else begin
						assert ((isDstr str)=false);
						let newstr=mapname i str
						in
						Hashtbl.replace hashWireName2RangeUnfold newstr tionrange
					end
				end
				| (TYPE_CONNECTION_OUT,range) -> begin
					if(isDstr str) then begin
						let newW=(TYPE_CONNECTION_NET,range)
						and newstr=mapname i str
						in
						Hashtbl.replace hashWireName2RangeUnfold newstr newW
					end
					else begin
						assert ((isQstr str)=false);
						let newstr=mapname i str
						in
						Hashtbl.replace hashWireName2RangeUnfold newstr tionrange
					end
				end
				| (TYPE_CONNECTION_NET,range) -> begin
					assert ((isQstr str)=false);
					assert ((isDstr str)=false);
					let newstr=mapname i str
					in
					Hashtbl.replace hashWireName2RangeUnfold newstr tionrange
				end
			end
			in
			Hashtbl.iter procWire hashWireName2Range
		done;
		dbg_print "hashWireName2RangeUnfold finished\n";
	end

end

method checkWireInclusive = begin
	let procTNInclusive tn = begin
		match tn with
		TYPE_NET_ID(str) -> 
			assert (Hashtbl.mem hashWireName2Range str)
		| TYPE_NET_ARRAYBIT(str,idx) -> begin
			assert (Hashtbl.mem hashWireName2Range str);
			let (tion,range)=Hashtbl.find hashWireName2Range str
			in
			let (l,r)=rng2lr range
			in  begin
				assert ((l>=idx && idx >=r )||(r>=idx && idx >=l ));
				assert (l>=0);
				assert (r>=0);
			end
		end
		| _ -> () 
	end
	in
	let procCheckInclusive cell = begin
		match cell with
		(_,_,ztnl,atnl,btnl) -> begin
			List.iter procTNInclusive ztnl;
			List.iter procTNInclusive atnl;
			List.iter procTNInclusive btnl;
		end
	end
	in
	Stack.iter procCheckInclusive cellStack
end

method procSumWireNumber str tionrange oldnum = begin
	match tionrange with
	(_,range) -> begin
		match range with
		T_range_NOSPEC -> 1+oldnum
		| T_range_int(l,r) -> begin
			assert (l<>r);
			assert (l>=0);
			assert (r>=0);
			l-r+1+oldnum
		end
		| T_range(_,_) ->
			assert false
	end
end

method writeFlatNetlist filename currentmodnmae = begin
	let flat_c = open_out filename 
	in begin
		fprintf flat_c "module %s (\n" currentmodnmae;
		(*print list of input and outputs*)
		Hashtbl.iter (procPrintOutput flat_c) hashWireName2Range;
	
		Hashtbl.iter (procPrintInput flat_c) hashWireName2Range; 
	
		fprintf flat_c "input xx);\n";
	
		Hashtbl.iter (procPrintWire flat_c) hashWireName2Range;
	
		Stack.iter (procPrintCell flat_c) cellStack;
	
		fprintf flat_c "endmodule\n";

		close_out flat_c;
	end
end

method writeUnfoldNetlist   filename currentmodnmae= begin
	let flat_c = open_out filename
	in begin
		fprintf flat_c "module %s (\n" currentmodnmae;
		(*print list of input and outputs*)
		Hashtbl.iter (procPrintOutput flat_c) hashWireName2RangeUnfold;
	
		Hashtbl.iter (procPrintInput flat_c) hashWireName2RangeUnfold; 
	
		fprintf flat_c "input xx);\n";
	
		Hashtbl.iter (procPrintWire flat_c) hashWireName2RangeUnfold;
	
		let procPrintCellUnfold pos cell = begin
			if(cellArrayUnfoldValid.(pos)) then 
				procPrintCell flat_c cell
		end
		in
		Array.iteri procPrintCellUnfold  cellArrayUnfold;
	
		fprintf flat_c "endmodule\n";

		close_out flat_c;
	end
end

method handleInputStepList stepList = begin
	assert ((Hashtbl.length hashTnetValue)=0);
	let procStringInt x = begin
		match x with
		(str,i) -> begin
			assert (i=0 || i=1);
			let tnet= TYPE_NET_ID(str)
			in 
			Hashtbl.add hashTnetValue tnet (TYPE_NET_CONST(int2bool(i)));
		end
	end
	in
	List.iter procStringInt stepList;

(*
	Hashtbl.add hashTnetValue (TYPE_NET_CONST(false)) (TYPE_NET_CONST(false));
	Hashtbl.add hashTnetValue (TYPE_NET_CONST(true)) (TYPE_NET_CONST(true));
*)
end

method procTnetSrcSink pos cell = begin
	if(cellArrayUnfoldValid.(pos)) then begin
		let procsink tn = begin
			match tn with
			TYPE_NET_CONST(_) -> ()
			| TYPE_NET_NULL -> ()
			| _ -> begin
				let currentList= begin
					try 
						Hashtbl.find hashTnetSink tn
					with Not_found -> []
				end
				in
				let newlist=pos::currentList
				in begin
					Hashtbl.replace hashTnetSink tn newlist;
					let tnname=getTNname tn
					in begin
						printf "Info: sink of %s" tnname;
						List.iter (printf " %d") newlist;
						printf "\n";
					end
				end
			end
		end
		and procsrc tn = begin
			match tn with
			TYPE_NET_CONST(_) -> ()
			| TYPE_NET_NULL -> ()
			| _ -> begin
				try
					let current=Hashtbl.find hashTnetSrc tn
					in begin
						Hashtbl.replace hashTnetSrc tn pos;
						let tnname=getTNname tn
						in
						printf "Info: src of %s %d\n" tnname pos
					end
				with Not_found -> begin
					Hashtbl.add hashTnetSrc tn pos;
					let tnname=getTNname tn
					in
					printf "Info: src of %s %d\n" tnname pos
				end
			end
		end
		in
		match cell with
		(defname,instname,ztnl,atnl,btnl) -> begin
			List.iter procsrc  ztnl;
			List.iter procsink atnl;
			List.iter procsink btnl;
		end
	end
end


method buildSrcSink = begin
	let finalWireNum = Hashtbl.length hashTnetValue
	in begin
		hashTnetSink  <- Hashtbl.create finalWireNum;
		hashTnetSrc   <- Hashtbl.create finalWireNum;
	end
	;
	
	Array.iteri (self#procTnetSrcSink)  cellArrayUnfold
	
end

method getTNetValue tn = begin
	let rec getTNetValue_internal tnet = begin
		if(tnet=TYPE_NET_CONST(true)) then tnet
		else if(tnet=TYPE_NET_CONST(false)) then tnet
		else begin
			try 
			begin
				let tnet1=Hashtbl.find hashTnetValue tnet
				in
				getTNetValue_internal tnet1
			end
			with Not_found -> tnet
		end
	end
	in begin
		if(tn=(TYPE_NET_CONST(true))) then tn
		else if(tn=(TYPE_NET_CONST(false))) then tn
		else if((Hashtbl.mem hashTnetValue tn)=false) then
			tn
		else begin
			let newtn=Hashtbl.find hashTnetValue tn
			in begin
				if((Hashtbl.mem hashTnetValue newtn)=false) then
					newtn
				else begin
					(*we replace the tn -> newtn 
					with its transitive*)
					let newnewtn=getTNetValue_internal newtn
					in begin
						Hashtbl.replace hashTnetValue tn newnewtn;
						newnewtn
					end
				end
			end
		end
	end
end

method setTNetValue tn1 tn2 = begin
	let tn2new=self#getTNetValue tn2
	in 
	Hashtbl.replace hashTnetValue tn1 tn2new;
end

method procCell pos = begin
	let cell=cellArrayUnfold.(pos)
	in begin
		if(cellArrayUnfoldValid.(pos)) then begin
			begin
				match cell with
				(defname,instname,_,_,_) -> begin
					printf "Info: procCell %s %s %d\n" defname instname pos;
				end
			end;
			match cell with
			("AN2",instname,[ztn],[atn],[btn]) -> 
			begin
				printf "haha\n";
				let atn1=self#getTNetValue atn
				and btn1=self#getTNetValue btn
				in 
				if(atn1=TYPE_NET_CONST(false) || 
				   btn1=TYPE_NET_CONST(false)) then
				begin
					(*const false at output*)
					let ztnname=getTNname ztn
					in
					printf "Info : %s <- 0\n" ztnname;
					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn (TYPE_NET_CONST(false));
					[ztn]
				end
				else if(atn1=TYPE_NET_CONST(true)) then 
				begin
					(*propagate the btn1 to ztn*)
					let ztnname=getTNname ztn
					and btnname=getTNname btn1
					in
					printf "Info : %s <- %s\n" ztnname btnname;
					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn btn1;
					(*only update the next state 
					when we have const*)
					match btn1 with
					TYPE_NET_CONST(_) -> [ztn]
					| _ -> []
				end
				else if(btn1=TYPE_NET_CONST(true)) then
				begin
					let ztnname=getTNname ztn
					and atnname=getTNname atn1
					in
					printf "Info : %s <- %s\n" ztnname atnname;
					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn atn1;
					match atn1 with
					TYPE_NET_CONST(_) -> [ztn]
					| _ -> []
				end
				else begin
					printf "Info : nothing to do\n";
					[]
				end
			end
			| ("OR2",instname,[ztn],[atn],[btn]) -> begin
				let atn1=self#getTNetValue atn
				and btn1=self#getTNetValue btn
				in 
				if(atn1=TYPE_NET_CONST(true) || 
				   btn1=TYPE_NET_CONST(true)) then begin
					(*const false at output*)
					let ztnname=getTNname ztn
					in
					printf "Info : %s <- 1\n" ztnname;
					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn (TYPE_NET_CONST(true));
					[ztn]
				end
				else if(atn1=TYPE_NET_CONST(false)) then 
				begin
					(*propagate the btn1 to ztn*)
					let ztnname=getTNname ztn
					and btnname=getTNname btn1
					in
					printf "Info : %s <- %s\n" ztnname btnname;
					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn btn1;
					match btn1 with
					TYPE_NET_CONST(_) -> [ztn]
					| _ -> []
				end
				else if(btn1=TYPE_NET_CONST(false)) then
				begin
					let ztnname=getTNname ztn
					and atnname=getTNname atn1
					in
					printf "Info : %s <- %s\n" ztnname atnname;
					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn atn1;
					match atn1 with
					TYPE_NET_CONST(_) -> [ztn]
					| _ -> []
				end
				else begin
					printf "Info : nothing to do\n";
					[]
				end
			end
			| ("EO",instname,[ztn],[atn],[btn]) -> begin
				let atn1=self#getTNetValue atn
				and btn1=self#getTNetValue btn
				in 
				if((atn1=TYPE_NET_CONST(true) && 
				    btn1=TYPE_NET_CONST(true))
				|| (atn1=TYPE_NET_CONST(false) &&
				    btn1=TYPE_NET_CONST(false))
				) then
				begin
					(*const false at output*)
					let ztnname=getTNname ztn
					in
					printf "Info : %s <- 0\n" ztnname;
					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn (TYPE_NET_CONST(false));
					[ztn]
				end
				else if((atn1=TYPE_NET_CONST(true) && 
				         btn1=TYPE_NET_CONST(false))
				     || (atn1=TYPE_NET_CONST(false) &&
						     btn1=TYPE_NET_CONST(true))
				) then
				begin
					(*const false at output*)
					let ztnname=getTNname ztn
					in
					printf "Info : %s <- 1\n" ztnname;
					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn (TYPE_NET_CONST(true));
					[ztn]
				end
				else if(atn1=TYPE_NET_CONST(false)) then 
				begin
					(*propagate the btn1 to ztn*)
					let ztnname=getTNname ztn
					and btnname=getTNname btn1
					in
					printf "Info : %s <- %s\n" ztnname btnname;
					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn btn1;
					[]
				end
				else if(atn1=TYPE_NET_CONST(true)) then 
				begin
					(*propagate the btn1 to ztn*)
					let ztnname=getTNname ztn
					and btnname=getTNname btn1
					in
					printf "Info : %s <- !%s\n" ztnname btnname;
					cellArrayUnfold.(pos) <- ("IV",instname,[ztn],[btn1],[]);
					[]
				end
				else if(btn1=TYPE_NET_CONST(false)) then
				begin
					let ztnname=getTNname ztn
					and atnname=getTNname atn1
					in
					printf "Info : %s <- %s\n" ztnname atnname;
					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn atn1;
					[]
				end
				else if(btn1=TYPE_NET_CONST(true)) then 
				begin
					(*propagate the btn1 to ztn*)
					let ztnname=getTNname ztn
					and atnname=getTNname atn1
					in
					printf "Info : %s <- !%s\n" ztnname atnname;
					cellArrayUnfold.(pos) <- ("IV",instname,[ztn],[atn1],[]);
					[]
				end
				else begin
					printf "Info : nothing to do\n";
					[]
				end
			end
			| ("IV",instname,[ztn],[atn],[]) -> begin
				let atn1=self#getTNetValue atn
				in 
				if(atn1=TYPE_NET_CONST(true) ) then
				begin
					(*const false at output*)
					let ztnname=getTNname ztn
					in
					printf "Info : %s <- 0\n" ztnname;
					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn (TYPE_NET_CONST(false));
					[ztn]
				end
				else if(atn1=TYPE_NET_CONST(false)) then 
				begin
					(*propagate the btn1 to ztn*)
					let ztnname=getTNname ztn
					in
					printf "Info : %s <- 1\n" ztnname;
					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn (TYPE_NET_CONST(true));
					[ztn]
				end
				else begin
					printf "Info : nothing to do\n";
					[]
				end
			end
			| ("BUF",instname,[ztn],[atn],[]) -> begin
				let atn1=self#getTNetValue atn
				in begin
					if(atn1<>atn) then begin
						self#setTNetValue ztn atn1;
						match atn1 with
						TYPE_NET_CONST(false) -> begin
							let ztnname=getTNname ztn
							in
							printf "Info : %s <- 0\n" ztnname;
							[ztn]
						end
						| TYPE_NET_CONST(true) -> begin
							let ztnname=getTNname ztn
							in
							printf "Info : %s <- 1\n" ztnname;
							[ztn]
						end
						| _ -> []
					end
					else  begin
					printf "Info : nothing to do\n";
						[]
					end
				end
			end
			| ("","",[],[],[]) -> assert false
			| (defname,instname,_,_,_) -> begin
				if(
				defname<>"gfadd_mod" &&
				defname<>"gfdiv_mod" &&
				defname<>"gfmult_flat_mod" &&
				defname<>"gfmult_mod" &&
				defname<>"tower2flat" &&
				defname<>"flat2tower"
				) then begin
					printf "Error : in procCell improper %s %s\n" defname instname ;
					flush stdout;
					assert false
				end
				else []
			end
		end
		else begin
			(*invalid one, run to its transitive closure*)
			match cell with
			(defname,instname,ztnl,_,_) -> begin
(* 				printf "Info: procCell invalid %s %s %d\n" defname instname pos; *)
				let procFindSink tn = 
					try
						Hashtbl.find hashTnetSink tn
					with Not_found -> begin
						let tnname=getTNname tn
						in
						printf "Warning : not found sink for %s\n" tnname;
						flush stdout;
						[]
					end
				in
				let poslstlst=List.map procFindSink ztnl
				in
				let poslst=List.concat poslstlst
				in
				List.concat (List.map (self#procCell) poslst)
			end
		end
	end
end

method propagateConst stepList= begin
	let todoQ   = Queue.create ()
	and todoHashBool = Hashtbl.create (Hashtbl.length hashWireName2RangeUnfold)
	in
	let addTodoQ todoname tn = begin
		if((Hashtbl.mem todoHashBool tn)=false) then
		begin
			let tnname=getTNname tn 
			in begin
				printf "addTodoQ : %s -> %s\n" todoname tnname;
				Queue.push  tn todoQ;
				Hashtbl.add todoHashBool tn true
			end
		end
	end
	and popTodoQ  () = begin
		let todoTn=Queue.pop todoQ
		in begin
			Hashtbl.remove todoHashBool todoTn;
			todoTn
		end
	end
	in begin
		let procStep x = begin
			match x with
			(str,_) ->
				let tn=TYPE_NET_ID(str)
				in
				addTodoQ "inithaha" tn
		end
		in
		List.iter procStep stepList;

		while ((Queue.is_empty todoQ)=false) do
			dbg_print (sprintf "todo len %d\n" (Queue.length todoQ));
			let todoTn=popTodoQ ()
			in 
			let todoname=getTNname todoTn
			in 
			let cellList=	begin
				printf "todoname %s\n" todoname;

				try
					Hashtbl.find hashTnetSink todoTn
				with Not_found -> []
			end
			in
			let lstlst=List.map (self#procCell) cellList
			in
			List.iter (List.iter (addTodoQ todoname)) lstlst
		done;
	end
end

(*the only different to writeUnfoldNetlist is 
use hashTnetValue *)
method writeUnfoldPropagatedNetlist   filename currentmodnmae= begin
	let flat_c = open_out filename
	in begin
		fprintf flat_c "module %s (\n" currentmodnmae;
		(*print list of input and outputs*)
		Hashtbl.iter (procPrintOutput flat_c) hashWireName2RangeUnfold;
	
		Hashtbl.iter (procPrintInput flat_c) hashWireName2RangeUnfold; 
	
		fprintf flat_c "input xx);\n";
	
		Hashtbl.iter (procPrintWire flat_c) hashWireName2RangeUnfold;
	
		Array.iteri (self#procPrintCellPropConst flat_c) cellArrayUnfold;
	
		fprintf flat_c "endmodule\n";

		close_out flat_c;
	end
end

method getTNnamePropConst tn =begin
	let newtn=self#getTNetValue tn
	in
	getTNname newtn
end

method getTNLnamePropconst tnl = begin
	let newtnl=List.map (self#getTNetValue) tnl
	in
	let namelst=List.map getTNname newtnl
	in
	let procprint a b = 
		sprintf "%s,%s" a b
	in
	let x=List.fold_left procprint (List.hd namelst) (List.tl namelst)
	in
	sprintf "{%s}" x
end

method procPrintCellPropConst flat_c pos mi  = begin
	if(cellArrayUnfoldValid.(pos)) then begin
		match mi with
		("AN2",instname,[ztn],[atn],[btn]) -> begin
			(*z should always be original name*)
			let zname=getTNname ztn
			and aname=self#getTNnamePropConst atn
			and bname=self#getTNnamePropConst btn
			in
			fprintf flat_c "  AN2 %s (.Z(%s),.A(%s),.B(%s));//%d\n" instname zname aname bname pos
		end
		| ("OR2",instname,[ztn],[atn],[btn]) -> begin
			let zname=getTNname ztn
			and aname=self#getTNnamePropConst atn
			and bname=self#getTNnamePropConst btn
			in
			fprintf flat_c "  OR2 %s (.Z(%s),.A(%s),.B(%s));//%d\n" instname zname aname bname pos
		end
		| ("EO",instname,[ztn],[atn],[btn]) -> begin
			let zname=getTNname ztn
			and aname=self#getTNnamePropConst atn
			and bname=self#getTNnamePropConst btn
			in
			fprintf flat_c "  EO %s (.Z(%s),.A(%s),.B(%s));//%d\n" instname zname aname bname pos
		end
		| ("IV",instname,[ztn],[atn],[]) -> begin
			let zname=getTNname ztn
			and aname=self#getTNnamePropConst atn
			in
			fprintf flat_c "  IV %s (.Z(%s),.A(%s));//%d\n" instname zname aname pos
		end
		| ("BUF",instname,[ztn],[atn],[]) -> begin
			let zname=getTNname ztn
			and aname=self#getTNnamePropConst atn
			in
			fprintf flat_c "  assign %s = %s;\n"  zname aname 
		end
		| ("gfadd_mod",instname,ztnl,atnl,btnl) -> begin
			let zl=getTNLname ztnl
			and al=self#getTNLnamePropconst atnl
			and bl=self#getTNLnamePropconst btnl
			in 
			fprintf flat_c "  gfadd_mod %s (.Z(%s),.A(%s),.B(%s));\n" instname zl al bl
		end
		| ("gfmult_mod",instname,ztnl,atnl,btnl) -> begin	
			let zl=getTNLname ztnl
			and al=self#getTNLnamePropconst atnl
			and bl=self#getTNLnamePropconst btnl
			in 
			fprintf flat_c "  gfmult_mod %s (.Z(%s),.A(%s),.B(%s));\n" instname zl al bl
		end
		| ("gfmult_flat_mod",instname,ztnl,atnl,btnl) -> begin	
			let zl=getTNLname ztnl
			and al=self#getTNLnamePropconst atnl
			and bl=self#getTNLnamePropconst btnl
			in 
			fprintf flat_c "  gfmult_flat_mod %s (.Z(%s),.A(%s),.B(%s));\n" instname zl al bl
		end
		| ("gfdiv_mod",instname,ztnl,atnl,btnl) -> begin	
			let zl=getTNLname ztnl
			and al=self#getTNLnamePropconst atnl
			and bl=self#getTNLnamePropconst btnl
			in 
			fprintf flat_c "  gfdiv_mod %s (.Z(%s),.A(%s),.B(%s));\n" instname zl al bl
		end
		| ("tower2flat",instname,ztnl,atnl,[]) -> begin	
			let zl=getTNLname ztnl
			and al=self#getTNLnamePropconst atnl
			in 
			fprintf flat_c "  tower2flat %s (.Z(%s),.A(%s));\n" instname zl al
		end
		| ("flat2tower",instname,ztnl,atnl,[]) -> begin	
			let zl=getTNLname ztnl
			and al=self#getTNLnamePropconst atnl
			in 
			fprintf flat_c "  flat2tower %s (.Z(%s),.A(%s));\n" instname zl al
		end
		| ("","",[],[],[]) -> assert false
		| (modname,instname,_,_,_) -> begin
			printf "Error : procPrintCellPropConst improper %s %s\n" modname instname;
			flush stdout;
			assert false
		end
	end
end
end
