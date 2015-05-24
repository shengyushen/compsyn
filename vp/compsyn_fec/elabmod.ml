
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

(*  *)
val mutable cellStack : (string*string*(type_net list)*(type_net list)*(type_net list)*(type_net list)) Stack.t= Stack.create ()
(*using range because some wire dont have range,
so I need T_range_NOSPEC*)
val mutable hashWireName2Range : (string,(type_ion*range))  Hashtbl.t= Hashtbl.create 100

(*unfold data struct*)
(* build from construct_boolonly_netlist *)
(*hold the value in unfolding*)
val mutable hashWireName2RangeUnfold : (string,(type_ion*range))  Hashtbl.t= Hashtbl.create 100
val mutable hashTnetValue : (type_net,type_net) Hashtbl.t = Hashtbl.create 1
val mutable hashTnetSink : (type_net,int ) Hashtbl.t = Hashtbl.create 1
val mutable hashTnetSrc  : (type_net,int ) Hashtbl.t = Hashtbl.create 1
val mutable cellArrayUnfold = Array.create 1 ("","",[],[],[],[])
val mutable cellArrayUnfoldValid = Array.create 1 false
val mutable cellArrayUnfoldPointer =0
val mutable hashNotUsedOutput : (string,bool ) Hashtbl.t= Hashtbl.create 1
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

	
method compsyn stepList unfoldNumber notUsedOutputList = 
begin


	set_current_time;
	(*first construct the data structure with bool only*)
	self#writeFlatNetlist "flat.v" name;

	(*unfold *)
	self#unfold_bool_netlist unfoldNumber ;

	hashNotUsedOutput <- Hashtbl.create (List.length notUsedOutputList);
	let procAddNotUsed str = begin
		printf "procAddNotUsed %s\n" str;
		assert (Hashtbl.mem hashWireName2RangeUnfold str);
		let (tion,_)=Hashtbl.find hashWireName2RangeUnfold str
		in
		match tion with
		TYPE_CONNECTION_OUT -> 
			Hashtbl.add hashNotUsedOutput str true
		| _ -> assert false
	end
	in
	List.iter procAddNotUsed notUsedOutputList;

	let unfoldname=sprintf "%s_unfold" name
	in
	self#writeUnfoldNetlist "unfold.v" unfoldname ;
	
	(*propagate const*)
	self#handleInputStepList stepList;

	self#buildSrcSink;

 	self#propagateConst stepList; 

	(* propagate the value to all tn*)
	self#fillInRealValueOfTN;

	let propconstname=sprintf "%s_propconst" name
	in
	self#writeUnfoldNetlist "propconst.v" propconstname ;

	self#buildSrcSink;

	self#removeNotdrivingCells notUsedOutputList ;

	let noundrivenname=sprintf "%s_noundriven" name
	in
	self#writeUnfoldNetlist "noundriven.v" noundrivenname ;
end

method fillInRealValueOfTN = begin
	let procFillInRealValueOfTN pos valid = begin
		if(valid) then 
		let cell=cellArrayUnfold.(pos)
		in
		match cell with
		(defname,instname,ztnl,atnl,btnl,stnl) -> begin
			let atnl1 = List.map (self#getTNetValue) atnl
			and btnl1 = List.map (self#getTNetValue) btnl
			and stnl1 = List.map (self#getTNetValue) stnl
			in
			let newCell = (defname,instname,ztnl,atnl1,btnl1,stnl1)
			in
			cellArrayUnfold.(pos) <- newCell
		end
	end
	in
	Array.iteri procFillInRealValueOfTN cellArrayUnfoldValid;
	dbg_print "fillInRealValueOfTN finish\n";
end

method isOutputStr str = begin
	if(Hashtbl.mem hashWireName2RangeUnfold str) then
		let (tion,_)=Hashtbl.find hashWireName2RangeUnfold str
		in 
		match tion with
		TYPE_CONNECTION_OUT -> true
		| _ -> false
	else false
end

method isInputStr str = begin
	if(Hashtbl.mem hashWireName2RangeUnfold str) then
		let (tion,_)=Hashtbl.find hashWireName2RangeUnfold str
		in 
		match tion with
		TYPE_CONNECTION_IN -> true
		| _ -> false
	else false
end

method isInvalid pos = begin
	if(debugFlag) then begin
		printf "isInvalid %d\n" pos;
	end;

	if(cellArrayUnfoldValid.(pos)) then begin
		if(debugFlag) then begin
			printf "false\n";
		end;
		false
	end
	else begin
		if(debugFlag) then begin
			printf "true\n";
		end;
		true
	end
end


method isBackTracable tn = begin
	match tn with
	TYPE_NET_ID(_) -> true
	| TYPE_NET_ARRAYBIT(_,_) -> true
	| _ -> false
end

method removeNotdrivingCells notUsedOutputList = begin
	(*add not used output list into hash*)
	let isNotUsed tn = begin
		if(debugFlag) then begin
			printf "isNotUsed : %s\n" (getTNname tn);
		end;
		match tn with
		TYPE_NET_ID(str) -> begin
			if(self#isOutputStr str) then begin
				if(Hashtbl.mem hashNotUsedOutput str) then begin
					if(debugFlag) then begin
						printf "not used\n";
					end;
					true
				end
				else false
			end
			else begin
				if(debugFlag) then begin
					printf "trying all\n";
				end;
				let sinklst = self#findTnetSink tn
				in
				List.for_all (self#isInvalid) sinklst
			end
		end
		| TYPE_NET_ARRAYBIT(str,_) -> begin
			if(self#isOutputStr str) then begin
				if(Hashtbl.mem hashNotUsedOutput str) then begin
					if(debugFlag) then begin
						printf "not used\n";
					end;
					true
				end
				else false
			end
			else begin
				if(debugFlag) then begin
					printf "trying all\n";
				end;

				let sinklst = self#findTnetSink tn
				in
				List.for_all (self#isInvalid) sinklst
			end
		end
		| _ -> true
	end
	in
	let isNotUsedCell cell = begin
		match cell with
		(defname,instname,ztnl,atnl,btnl,stnl) -> begin
			printf "isNotUsedCell : %s %s\n" defname instname;
			if(defname="output") then 
				if(List.for_all isNotUsed ztnl) then 
					true
				else false
			else if((List.for_all isNotUsed ztnl) || (isEmptyList ztnl)) then 
					true
			else begin
				printf "non output used\n";
				false
			end
		end
	end
	in
	let markUnusedOutputCell pos valid = begin
		if(debugFlag) then begin
			match (cellArrayUnfold.(pos)) with
			("output",_,_,atnl,_,_)  -> begin
				printf "working on %s pos %d\n" (getTNLname atnl) pos;
			end
			| _ -> ()
		end;

		if(valid=false)  then begin
			printf "invalid\n";
		end
		else
		let cell=cellArrayUnfold.(pos)
		in
		match cell with
		("output",_,_,atnl,_,_) -> begin
			match atnl with
			[TYPE_NET_ID(str)] -> begin
				if(Hashtbl.mem hashNotUsedOutput str) then begin
					if(debugFlag) then begin
						printf "markUnusedOutputCell false %s pos %d\n" str pos;
					end;
					cellArrayUnfoldValid.(pos) <- false;
				end
				else begin
					printf "not in\n";
				end
			end
			| [TYPE_NET_ARRAYBIT(str,idx)] -> begin
				if(Hashtbl.mem hashNotUsedOutput str) then begin
					if(debugFlag) then begin
						printf "markUnusedOutputCell false %s %d pos %d\n" str idx pos;
					end;
					cellArrayUnfoldValid.(pos) <- false;
				end
				else begin
					printf "not in\n";
				end
			end 
			| [TYPE_NET_NULL] -> assert false
			| [TYPE_NET_CONST(_)] -> begin
				printf "empty\n";
			end
			| _ -> assert false
		end
		| _ -> begin
			printf "other\n"
		end
	end
	in begin
		Array.iteri markUnusedOutputCell cellArrayUnfoldValid;
	
		let todoQ = Queue.create ()
		in
		let procAddtodoQ pos valid  =begin
			if(valid) then begin	
				let cell = cellArrayUnfold.(pos)
				in 
				if(isNotUsedCell cell) then begin
					(*not used*)
					Queue.push  pos todoQ;
				end
			end
		end
		in begin
			(*first find all cells position that are not driving*)
			Array.iteri procAddtodoQ cellArrayUnfoldValid;
	
			while ((Queue.is_empty todoQ)=false) do 
				let pos=Queue.pop todoQ
				in
				let cell=cellArrayUnfold.(pos)
				in 
				match cell with
				(defname,instname,ztnl,atnl,btnl,stnl) -> begin
					printf "Info : doing %s %s %d " defname instname pos;
					if(cellArrayUnfoldValid.(pos) && (isNotUsedCell cell))
					then begin
						printf "removed\n";
						cellArrayUnfoldValid.(pos) <- false;
						let abttnl = List.filter (self#isBackTracable) atnl
						and bbttnl = List.filter (self#isBackTracable) btnl
						and sbttnl = List.filter (self#isBackTracable) stnl
						in
						let procaddtn tn = begin
							let tnname=getTNname tn
							in
							printf "procaddtn %s\n" tnname;

							try 
								let postn=Hashtbl.find hashTnetSrc tn
								in
								if(cellArrayUnfoldValid.(postn)) then 
									Queue.push  postn todoQ
								else begin
									printf "Warning : cell at %d alreay become invalid. if it drive a not used output, then OK " postn;
									match cellArrayUnfold.(postn) with
									(defnn,instnn,ztnl,_,_,_) -> begin
										let ztnlname = getTNLname ztnl
										in
										printf "%s %s %s\n" defnn instnn ztnlname;
									end
								end
							with Not_found -> ()
						end
						in begin
							List.iter procaddtn abttnl;
							List.iter procaddtn bbttnl;
							List.iter procaddtn sbttnl;
						end
					end
					else 
						printf "\n";
				end
			done;
	
			(*check that all cells are used*)
			let procck pos valid = begin
				if(valid) then 
				let cell=cellArrayUnfold.(pos)
				in
				match cell with
				(defname,instname,ztnl,_,_,_) -> begin
					if(isNotUsedCell cell) then 
						printf "Error : %s %s %d is not used\n" defname instname pos;
				end
			end
			in
			Array.iteri procck cellArrayUnfoldValid;
			
			dbg_print "removeNotdrivingCells finish\n";
		end
	end
end

method cellArrayUnfold_init sz = begin
	cellArrayUnfold <- Array.create sz ("","",[],[],[],[]);
	cellArrayUnfoldValid <- Array.create sz false;
	cellArrayUnfoldPointer <- 0;
end

method cellArrayUnfold_add co = begin
	assert (cellArrayUnfoldPointer<(Array.length cellArrayUnfold));
	cellArrayUnfold.(cellArrayUnfoldPointer) <- co;
	cellArrayUnfoldValid.(cellArrayUnfoldPointer) <- true;
	cellArrayUnfoldPointer <- cellArrayUnfoldPointer+1;
	if(debugFlag) then
	match co with
	(defname,instname,ztnl,atnl,btnl,stnl) -> 
		let ztnlname = getTNLname ztnl
		and atnlname = getTNLname atnl
		and btnlname = getTNLname btnl
		and stnlname = getTNLname stnl
		in
		printf "Info : cellArrayUnfold_add %s %s %s %s %s %s\n" defname instname ztnlname atnlname btnlname stnlname
end

method unfold_bool_netlist unfoldNumber= begin
	
	(*whether all the wires referred
	by cellStack are in hashWireName2Range*)
	self#checkWireInclusive ;
	dbg_print "checkWireInclusive finished\n";
	
	(*find out the number of wires*)
	let numWire = Hashtbl.fold (self#procSumWireNumber) hashWireName2Range 0
	and numOutput = Hashtbl.fold (self#procSumOutNumber) hashWireName2Range 0
	and numCell = Stack.length cellStack
	in
	let finalWireNum=numWire*unfoldNumber
	and finalCellNum = (numCell+numOutput)*unfoldNumber
	in begin
		(*construct unfold data structure*)
		(*hold the value in unfolding*)
		hashTnetValue <- Hashtbl.create finalWireNum;
		(*hold all wires' range and in/out*)
		hashWireName2RangeUnfold <- Hashtbl.create ((Hashtbl.length hashWireName2Range)*unfoldNumber);
		self#cellArrayUnfold_init finalCellNum;

		(*unfold the gates*)
		for i= 0 to (unfoldNumber-1) do
			let procCell co = begin
				match co with
				(defname,instname,ztnl,atnl,btnl,stnl) -> begin
					let instname1 = mapname i instname
					and ztnl1 = List.map (maptnet i) ztnl
					and atnl1 = List.map (maptnetQ2D i) atnl
					and btnl1 = List.map (maptnetQ2D i) btnl
					and stnl1 = List.map (maptnetQ2D i) stnl
					in
					let newco=(defname,instname1,ztnl1,atnl1,btnl1,stnl1)
					in
					self#cellArrayUnfold_add newco
				end
			end
			in
			Stack.iter  procCell cellStack
		done;
		dbg_print "unfold cell finished\n";

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
						in begin
							Hashtbl.replace hashWireName2RangeUnfold newstr tionrange;
							(*not only add as wire
							also add as a term cell*)
							let tnlist= begin
								match range with
								T_range_NOSPEC -> [TYPE_NET_ID(mapname i str)]
								| T_range_int(l,r) -> 
									List.map (fun x -> TYPE_NET_ARRAYBIT((mapname i str),x)) (lr2list l r)
								| _ -> assert false
							end
							in
							let celllst=List.map (fun x -> ("output","",[x],[x],[],[])) tnlist
							in
							List.iter (self#cellArrayUnfold_add ) celllst
						end
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
		dbg_print "unfold wire finished\n";
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
		(_,_,ztnl,atnl,btnl,stnl) -> begin
			List.iter procTNInclusive ztnl;
			List.iter procTNInclusive atnl;
			List.iter procTNInclusive btnl;
			List.iter procTNInclusive stnl;
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

method procSumOutNumber str tionrange oldnum = begin
	match tionrange with
	(TYPE_CONNECTION_OUT,range) -> begin
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
	| _ -> oldnum
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

method printWires flat_c = begin
		let hashDrivenWires=Hashtbl.create (Hashtbl.length hashWireName2RangeUnfold)
		and wiresNameUsed=Hashtbl.create (Hashtbl.length hashWireName2RangeUnfold)
		in
		let procDrivenWires pos valid = begin
			if(valid) then
			let cell=cellArrayUnfold.(pos) 
			in
			match cell with
			(_,_,ztnl,_,_,_) -> begin
				let procZTN tn =begin
					match tn with
					TYPE_NET_ID(str) -> begin
						Hashtbl.replace wiresNameUsed str true;
						if(self#isOutputStr str) then ()
						else if(self#isInputStr str) then begin
							printf "Error : driving inputs %s\n" str;
							flush stdout;
							assert false
						end
						else if(Hashtbl.mem hashDrivenWires tn) then begin
							printf "Error : multi-driven wires %s\n" str;
							flush stdout;
							assert false
						end
						else 
							Hashtbl.add hashDrivenWires tn true;
					end
					| TYPE_NET_ARRAYBIT(str,idx) -> begin
						Hashtbl.replace wiresNameUsed str true;
						if(self#isOutputStr str) then ()
						else if(self#isInputStr str) then begin
							printf "Error : driving inputs %s %d\n" str idx;
							flush stdout;
							assert false
						end
						else if(Hashtbl.mem hashDrivenWires tn) then begin
							printf "Error : multi-driven wires %s %d\n" str idx;
							flush stdout;
							assert false
						end
						else 
							Hashtbl.add hashDrivenWires tn true
					end
					| _ ->()
				end
				in
				List.iter procZTN ztnl;
			end
		end
		and procABwires pos valid = begin
			if(valid) then 
			let cell=cellArrayUnfold.(pos) 
			in
			match cell with
			(_,_,_,atnl,btnl,stnl) -> begin
				let procABTN tn = begin
					match tn with
					TYPE_NET_ID(str) -> begin
						if(self#isOutputStr str) then ()
						else if(self#isInputStr str) then ()
						else if(Hashtbl.mem hashDrivenWires tn) then ()
						else begin
							printf "Error : not driven net %s\n" str;
							flush stdout;
							assert false
						end
					end
					| TYPE_NET_ARRAYBIT(str,idx) -> begin
						if(self#isOutputStr str) then ()
						else if(self#isInputStr str) then ()
						else if(Hashtbl.mem hashDrivenWires tn) then ()
						else begin
							printf "Error : not driven wire %s %d\n" str idx;
							flush stdout;
							assert false
						end
					end
					| TYPE_NET_NULL -> begin
						printf "Error : not driven AB nets\n";
						flush stdout;
						assert false
					end
					| _ ->()
				end
				in begin
					List.iter procABTN atnl;
					List.iter procABTN btnl;
					List.iter procABTN stnl;
				end
			end
		end
		in
		let procPrintWire_check flat_c str ionrange = begin
			if(Hashtbl.mem wiresNameUsed str) then
				procPrintWire flat_c str ionrange
		end
		in begin
			Array.iteri procDrivenWires cellArrayUnfoldValid;
			Array.iteri procABwires cellArrayUnfoldValid;
			
	 		Hashtbl.iter (procPrintWire_check flat_c) hashWireName2RangeUnfold; 
		end;
end

method procPrintOutputAssignment flat_c str tionrange = begin
	match tionrange with
	(TYPE_CONNECTION_OUT,range) -> begin
		let tnlst = begin
			match range with
			T_range_int(l,r) -> begin
				let lst= lr2list l r 
				in
				List.map (fun x -> TYPE_NET_ARRAYBIT(str,x)) lst
			end
			| T_range_NOSPEC -> 
				[TYPE_NET_ID(str) ]
			| _ -> assert false
		end
		in
		let procprt tn = begin
			let tnstr=getTNStr tn
			in
			if((Hashtbl.mem hashTnetValue tn) && (Hashtbl.mem hashNotUsedOutput tnstr)=false) then begin
				assert (tnstr<>"");
				(*mapping in hashTnetValue means original 
				cell is removed*)
				let newtn=self#getTNetValue tn
				in
				if(newtn<>tn) then
					let tnname=getTNname tn
					and newtname=getTNname newtn 
					in begin
						fprintf flat_c "  assign %s = %s ;//direct output\n" tnname newtname;
						printf "Warning : additional output assignments %s %s\n" tnname newtname;
					end
			end
		end
		in
		List.iter procprt tnlst
	end
	|_ ->()
end


method writeUnfoldNetlist   filename currentmodnmae  = begin
	let flat_c = open_out filename
	in begin
		fprintf flat_c "module %s (\n" currentmodnmae;
		(*print list of input and outputs*)
		Hashtbl.iter (procPrintOutput flat_c) hashWireName2RangeUnfold;
	
		Hashtbl.iter (procPrintInput flat_c) hashWireName2RangeUnfold; 
	
		fprintf flat_c "input xx);\n";

		(*checking whether each AB wire used is 
		actually driven by Z pin*)
		self#printWires flat_c;
	
		let procPrintCellUnfold pos valid = begin
			if(valid) then 
				procPrintCell flat_c (cellArrayUnfold.(pos))
		end
		in
		Array.iteri procPrintCellUnfold  cellArrayUnfoldValid;

		(*some outputs still have values in hashTnetValue*)
 		Hashtbl.iter (self#procPrintOutputAssignment flat_c ) hashWireName2RangeUnfold; 
	
		fprintf flat_c "endmodule\n";

		close_out flat_c;
		dbg_print "writeUnfoldNetlist finish\n";
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
	dbg_print "handleInputStepList finish\n";

(*
	Hashtbl.add hashTnetValue (TYPE_NET_CONST(false)) (TYPE_NET_CONST(false));
	Hashtbl.add hashTnetValue (TYPE_NET_CONST(true)) (TYPE_NET_CONST(true));
*)
end

method findTnetSink tn = begin
	try
		Hashtbl.find_all hashTnetSink tn
	with Not_found -> []
end

method procTnetSrcSink pos valid = begin
	if(valid) then begin
		let cell=cellArrayUnfold.(pos)
		in
		let procsink tn = begin
			match tn with
			TYPE_NET_CONST(_) -> ()
			| TYPE_NET_NULL -> ()
			| _ -> begin
				Hashtbl.add hashTnetSink tn pos;

				if(debugFlag) then begin
					let tnname=getTNname tn
					in 
					printf "Info: sink %s %d\n" tnname pos ;
				end
			end
		end
		and procsrc tn = begin
			match tn with
			TYPE_NET_CONST(_) -> ()
			| TYPE_NET_NULL -> ()
			| _ -> begin
				Hashtbl.add hashTnetSrc tn pos;
				if(debugFlag) then begin
					let tnname=getTNname tn
					in
					printf "Info: src %s %d\n" tnname pos
				end
			end
		end
		in
		match cell with
		("output",_,_,atnl,_,_) -> begin
			List.iter procsink atnl;
		end
		| (_,_,ztnl,atnl,btnl,stnl) -> begin
			List.iter procsrc  ztnl;
			List.iter procsink atnl;
			List.iter procsink btnl;
			List.iter procsink stnl;
		end
	end
end


method buildSrcSink = begin
	let finalWireNum = Hashtbl.length hashTnetValue
	in begin
		Hashtbl.clear hashTnetSink;
		Hashtbl.clear hashTnetSrc;
		hashTnetSink  <- Hashtbl.create finalWireNum;
		hashTnetSrc   <- Hashtbl.create finalWireNum;
	end
	;
	
	Array.iteri (self#procTnetSrcSink)  cellArrayUnfoldValid;

	dbg_print "buildSrcSink finish\n";
	
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
	if(pos>=cellArrayUnfoldPointer) then []
	else
	let cell=cellArrayUnfold.(pos)
	in begin
		if(cellArrayUnfoldValid.(pos)) then begin
			begin
				if(debugFlag) then begin
					match cell with
					(defname,instname,_,_,_,_) -> 
						printf "Info: procCell %s %s %d\n" defname instname pos;
				end
			end;
			match cell with
			("AN2",instname,[ztn],[atn],[btn],_) -> 
			begin
				let atn1=self#getTNetValue atn
				and btn1=self#getTNetValue btn
				in 
				if(atn1=TYPE_NET_CONST(false) || 
				   btn1=TYPE_NET_CONST(false)) then
				begin
					(*const false at output*)
					let newztn=TYPE_NET_CONST(false)
					in begin
						if(debugFlag) then begin
							let ztnname=getTNname ztn
							in
							printf "Info : %s <- 0\n" ztnname;
						end;

						cellArrayUnfoldValid.(pos) <- false;
						(*record this make sure that we 
						dont need to explore this any more*)
						cellArrayUnfold.(pos) <- ("AN2",instname,[newztn],[atn],[btn],[]);
						self#setTNetValue ztn newztn;
						[ztn]
					end
				end
				else if(atn1=TYPE_NET_CONST(true)) then 
				begin
					(*propagate the btn1 to ztn*)
					if(debugFlag) then begin
						let ztnname=getTNname ztn
						and btnname=getTNname btn1
						in
						printf "Info : %s <- %s\n" ztnname btnname;
					end;

					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn btn1;
					(*only update the next state 
					when we have const*)
					match btn1 with
					TYPE_NET_CONST(_) -> begin
						let newztn=TYPE_NET_CONST(true)
						in
						cellArrayUnfold.(pos) <- ("AN2",instname,[newztn],[atn],[btn],[]);
						[ztn]
					end
					| _ -> []
				end
				else if(btn1=TYPE_NET_CONST(true)) then
				begin
					if(debugFlag) then begin
						let ztnname=getTNname ztn
						and atnname=getTNname atn1
						in
						printf "Info : %s <- %s\n" ztnname atnname;
					end;

					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn atn1;
					match atn1 with
					TYPE_NET_CONST(_) -> assert false
					| _ -> []
				end
				else begin
					printf "Info : nothing to do\n";
					[]
(*
					flush stdout;
					assert false
*)
				end
			end
			| ("OR2",instname,[ztn],[atn],[btn],_) -> begin
				let atn1=self#getTNetValue atn
				and btn1=self#getTNetValue btn
				in 
				if(atn1=TYPE_NET_CONST(true) || 
				   btn1=TYPE_NET_CONST(true)) then begin
					(*const false at output*)
					let newztn=TYPE_NET_CONST(true)
					in begin
						if(debugFlag) then begin
							let ztnname=getTNname ztn
							in
							printf "Info : %s <- 1\n" ztnname;
						end;

						cellArrayUnfoldValid.(pos) <- false;
						cellArrayUnfold.(pos) <- ("OR2",instname,[newztn],[atn],[btn],[]);
						self#setTNetValue ztn newztn;
					[ztn]
					end
				end
				else if(atn1=TYPE_NET_CONST(false)) then 
				begin
					(*propagate the btn1 to ztn*)
					if(debugFlag) then begin
						let ztnname=getTNname ztn
						and btnname=getTNname btn1
						in
						printf "Info : %s <- %s\n" ztnname btnname;
					end;

					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn btn1;
					match btn1 with
					TYPE_NET_CONST(_) -> begin
						let newztn=TYPE_NET_CONST(false)
						in
						cellArrayUnfold.(pos) <- ("OR2",instname,[newztn],[atn],[btn],[]);
						[ztn]
					end
					| _ -> []
				end
				else if(btn1=TYPE_NET_CONST(false)) then
				begin
					if(debugFlag) then begin
						let ztnname=getTNname ztn
						and atnname=getTNname atn1
						in
						printf "Info : %s <- %s\n" ztnname atnname;
					end;

					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn atn1;
					match atn1 with
					TYPE_NET_CONST(_) -> assert false
					| _ -> []
				end
				else begin
					printf "Info : nothing to do\n";
					[]
(*
					flush stdout;
					assert false
*)
				end
			end
			| ("EO",instname,[ztn],[atn],[btn],_) -> begin
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
					let newztn=TYPE_NET_CONST(false)
					in begin
						if(debugFlag) then begin
							let ztnname=getTNname ztn
							in
							printf "Info : %s <- 0\n" ztnname;
						end;

						cellArrayUnfoldValid.(pos) <- false;
						cellArrayUnfold.(pos) <- ("EO",instname,[newztn],[atn],[btn],[]);
						self#setTNetValue ztn newztn;
						[ztn]
					end
				end
				else if((atn1=TYPE_NET_CONST(true) && 
				         btn1=TYPE_NET_CONST(false))
				     || (atn1=TYPE_NET_CONST(false) &&
						     btn1=TYPE_NET_CONST(true))
				) then
				begin
					(*const false at output*)
					let newztn=TYPE_NET_CONST(true)
					in begin
						if(debugFlag) then begin
							let ztnname=getTNname ztn
							in
							printf "Info : %s <- 1\n" ztnname;
						end;

						cellArrayUnfoldValid.(pos) <- false;
						cellArrayUnfold.(pos) <- ("EO",instname,[newztn],[atn],[btn],[]);
						self#setTNetValue ztn newztn;
						[ztn]
					end
				end
				else if(atn1=TYPE_NET_CONST(false)) then 
				begin
					(*propagate the btn1 to ztn*)
					if(debugFlag) then begin
						let ztnname=getTNname ztn
						and btnname=getTNname btn1
						in
						printf "Info : %s <- %s\n" ztnname btnname;
					end;

					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn btn1;
					[]
				end
				else if(atn1=TYPE_NET_CONST(true)) then 
				begin
					(*propagate the btn1 to ztn*)
					if(debugFlag) then begin
						let ztnname=getTNname ztn
						and btnname=getTNname btn1
						in
						printf "Info : %s <- !%s\n" ztnname btnname;
					end;

					cellArrayUnfold.(pos) <- ("IV",instname,[ztn],[btn1],[],[]);
					[]
				end
				else if(btn1=TYPE_NET_CONST(false)) then
				begin
					if(debugFlag) then begin
						let ztnname=getTNname ztn
						and atnname=getTNname atn1
						in
						printf "Info : %s <- %s\n" ztnname atnname;
					end;

					cellArrayUnfoldValid.(pos) <- false;
					self#setTNetValue ztn atn1;
					[]
				end
				else if(btn1=TYPE_NET_CONST(true)) then 
				begin
					(*propagate the btn1 to ztn*)
					if(debugFlag) then begin
						let ztnname=getTNname ztn
						and atnname=getTNname atn1
						in
						printf "Info : %s <- !%s\n" ztnname atnname;
					end;

					cellArrayUnfold.(pos) <- ("IV",instname,[ztn],[atn1],[],[]);
					[]
				end
				else begin
					printf "Info : nothing to do\n";
					[]
(*
					flush stdout;
					assert false
*)
				end
			end
			| ("IV",instname,[ztn],[atn],[],_) -> begin
				let atn1=self#getTNetValue atn
				in 
				if(atn1=TYPE_NET_CONST(true) ) then
				begin
					(*const false at output*)
					let newztn=TYPE_NET_CONST(false)
					in begin
						if(debugFlag) then begin
							let ztnname=getTNname ztn
							in
							printf "Info : %s <- 0\n" ztnname;
						end;

						cellArrayUnfoldValid.(pos) <- false;
						cellArrayUnfold.(pos) <- ("IV",instname,[newztn],[atn],[],[]);
						self#setTNetValue ztn newztn;
						[ztn]
					end
				end
				else if(atn1=TYPE_NET_CONST(false)) then 
				begin
					(*propagate the btn1 to ztn*)
					let newztn=TYPE_NET_CONST(true)
					in begin
						if(debugFlag) then begin
							let ztnname=getTNname ztn
							in
							printf "Info : %s <- 1\n" ztnname;
						end;

						cellArrayUnfoldValid.(pos) <- false;
						cellArrayUnfold.(pos) <- ("IV",instname,[newztn],[atn],[],[]);
						self#setTNetValue ztn newztn;
						[ztn]
					end
				end
				else begin
					printf "Info : nothing to do\n";
					[]
(*
					flush stdout;
					assert false
*)
				end
			end
			| ("BUF",instname,[ztn],[atn],[],_) -> begin
				let atn1=self#getTNetValue atn
				in begin
					if(atn1<>atn) then begin
						self#setTNetValue ztn atn1;
						match atn1 with
						TYPE_NET_CONST(false) -> begin
							if(debugFlag) then begin
								let ztnname=getTNname ztn
								in
								printf "Info : %s <- 0\n" ztnname;
							end;
							[ztn]
						end
						| TYPE_NET_CONST(true) -> begin
							if(debugFlag) then begin
								let ztnname=getTNname ztn
								in
								printf "Info : %s <- 1\n" ztnname;
							end;

							[ztn]
						end
						| _ -> []
					end
					else  begin
					printf "Info : nothing to do\n";
					[]
(*
					flush stdout;
					assert false
*)
					end
				end
			end
			| ("","",[],[],[],_) -> assert false
			| ("output",_,_,_,_,_) -> []
			| ("is_zero_mod",instname,[ztn],atnl,_,_) -> begin
				let atnl1=List.map (self#getTNetValue) atnl
				in
				if(isGFZero atnl1) then begin
					cellArrayUnfoldValid.(pos) <- false;
					cellArrayUnfold.(pos) <- ("is_zero_mod",instname,[TYPE_NET_CONST(true)],atnl,[],[]);
					self#setTNetValue ztn (TYPE_NET_CONST(true));
					[ztn]
				end
				else if(isNotGFZero atnl1) then begin
					cellArrayUnfoldValid.(pos) <- false;
					cellArrayUnfold.(pos) <- ("is_zero_mod",instname,[TYPE_NET_CONST(false)],atnl,[],[]);
					self#setTNetValue ztn (TYPE_NET_CONST(false));
					[ztn]
				end
				else []
			end
			| ("gfmux_mod",instname,ztnl,atnl,btnl,[stn]) -> begin
				let stn1=self#getTNetValue stn
				and atnl1=List.map (self#getTNetValue ) atnl
				and btnl1=List.map (self#getTNetValue ) btnl
				in
				if(stn1=(TYPE_NET_CONST(true))) then begin
					cellArrayUnfoldValid.(pos) <- false;
					let combnl=List.combine ztnl atnl1
					in
					let constnl=List.filter (fun x -> match x with (_,TYPE_NET_CONST(_)) -> true | _ -> false) combnl
					in begin
						List.iter (fun x -> match x with (z,a) -> self#setTNetValue z a) combnl ;
						List.map fst constnl
					end
				end
				else if(stn1=(TYPE_NET_CONST(false))) then begin
					cellArrayUnfoldValid.(pos) <- false;
					let combnl = List.combine ztnl btnl1
					in
					let constnl=List.filter (fun x -> match x with (_,TYPE_NET_CONST(_)) -> true | _ -> false) combnl
					in begin
						List.iter (fun x -> match x with (z,a) -> self#setTNetValue z a) combnl ;
						List.map fst constnl
					end
				end
				else if(atnl1=btnl1) then begin
					cellArrayUnfoldValid.(pos) <- false;
					let combnl=List.combine ztnl atnl1
					in
					let constnl=List.filter (fun x -> match x with (_,TYPE_NET_CONST(_)) -> true | _ -> false) combnl
					in begin
						List.iter (fun x -> match x with (z,a) -> self#setTNetValue z a) combnl ;
						List.map fst constnl
					end
				end
				else []
			end
			| ("gfadd_mod",instname,ztnl,atnl,btnl,_) -> begin
				let atnl1=List.map (self#getTNetValue ) atnl
				and btnl1=List.map (self#getTNetValue ) btnl
				in
				if(isGFZero atnl1) then begin
					cellArrayUnfoldValid.(pos) <- false;
					let combnl = List.combine ztnl btnl1
					in
					let constnl=List.filter (fun x -> match x with (_,TYPE_NET_CONST(_)) -> true | _ -> false) combnl
					in begin
						List.iter (fun x -> match x with (z,a) -> self#setTNetValue z a) combnl ;
						List.map fst constnl
					end
				end
				else if(isGFZero btnl1) then begin
					cellArrayUnfoldValid.(pos) <- false;
					let combnl = List.combine ztnl atnl1
					in
					let constnl=List.filter (fun x -> match x with (_,TYPE_NET_CONST(_)) -> true | _ -> false) combnl
					in begin
						List.iter (fun x -> match x with (z,a) -> self#setTNetValue z a) combnl ;
						List.map fst constnl
					end
				end
				else []
			end
			| ("gfmult_flat_mod",instname,ztnl,atnl,btnl,_) -> begin
				let atnl1=List.map (self#getTNetValue ) atnl
				and btnl1=List.map (self#getTNetValue ) btnl
				in
				if((isGFZero atnl1) || (isGFZero btnl1)) then begin
					cellArrayUnfoldValid.(pos) <- false;
					List.iter (fun x -> self#setTNetValue x (TYPE_NET_CONST(false))) ztnl;
					ztnl
				end
				else if(isGFOne atnl1) then begin
					cellArrayUnfoldValid.(pos) <- false;
					let combnl = List.combine ztnl btnl1
					in
					let constnl=List.filter (fun x -> match x with (_,TYPE_NET_CONST(_)) -> true | _ -> false) combnl
					in begin
						List.iter (fun x -> match x with (z,a) -> self#setTNetValue z a) combnl ;
						List.map fst constnl
					end
				end
				else if(isGFOne btnl1) then begin
					cellArrayUnfoldValid.(pos) <- false;
					let combnl = List.combine ztnl atnl1
					in
					let constnl=List.filter (fun x -> match x with (_,TYPE_NET_CONST(_)) -> true | _ -> false) combnl
					in begin
						List.iter (fun x -> match x with (z,a) -> self#setTNetValue z a) combnl ;
						List.map fst constnl
					end
				end
				else []
			end
			| (defname,instname,_,_,_,_) -> begin
				assert (isGF defname);
				[]
			end
		end
		else begin
			(*invalid one, run to its transitive closure
			only when the output is already const*)
			match cell with
			(defname,instname,[TYPE_NET_CONST(_)],_,_,_) -> begin
				(*already be zero before we considered 
				current assignment, so dont go further*)
				[]
			end
			| (defname,instname,[ztn],_,_,_) -> begin
				if(debugFlag) then begin
	 				printf "Info: procCell invalid %s %s %d\n" defname instname pos; 
				end;

				let ztn1=self#getTNetValue ztn 
				in
				match ztn1 with
				TYPE_NET_NULL -> []
				| TYPE_NET_CONST(_) -> begin
					(*be const when consider current assignment
					so go further*)
					let poslst=self#findTnetSink ztn
					in
					List.concat (List.map (self#procCell) poslst)
				end
				| _ -> begin
					(*not const even with current assignment
					dont go further*)
					[]
				end
			end
			| ("",instname,_,_,_,_) -> begin
				printf "Error : empty def %s\n" instname;
				flush stdout;
				assert false
			end
			| (defname,_,ztnl,_,_,_) -> begin
				(*gf mod dont need to prop*)
				if ((isGF defname)=false) then begin
					printf "Error : non GF %s\n" defname;
					flush stdout;
					assert false
				end;
				[]
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

			if(debugFlag) then begin
				let tnname=getTNname tn 
				in 
				printf "addTodoQ : %s -> %s\n" todoname tnname;
			end;

			Queue.push  tn todoQ;
			Hashtbl.add todoHashBool tn true
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

		let procCelli pos valid = begin
			let newztnl=self#procCell pos
			in
			List.iter (addTodoQ "inithaha2" ) newztnl
		end
		in
		Array.iteri procCelli cellArrayUnfoldValid;

		while ((Queue.is_empty todoQ)=false) do
			if(debugFlag) then begin
				printf "todo len %d\n" (Queue.length todoQ);
			end;

			let todoTn=popTodoQ ()
			in 
			let todoname= begin
				if(debugFlag) then 
					getTNname todoTn
				else
					""
			end
			in 
			let cellList=	begin
				if(debugFlag) then begin
					printf "todoname %s\n" todoname;
				end;

				self#findTnetSink todoTn
			end
			in
			let lstlst= begin
				if(debugFlag) then begin
					printf "cellList len %d\n" (List.length cellList);
					List.iter (printf " %d ") cellList;
					printf "\n";
				end;

				List.map (self#procCell) cellList
			end
			in
			List.iter (List.iter (addTodoQ todoname)) lstlst;

			printf "cellArrayUnfold len %d\n" (Array.length cellArrayUnfold);
			dbg_print "propagateConst finish \n";
		done;
	end
end


(*the only different to writeUnfoldNetlist is 
useing hashTnetValue to trace transitively to 
source of Tnet, we only use this in prop const result
while on the final no undriven netlist we use the simple
writeUnfoldNetlist*)

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

end
