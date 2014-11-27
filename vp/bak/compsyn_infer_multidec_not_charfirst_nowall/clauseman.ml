open Printf
open Typedef
open Typedefcommon

let rec get_largest_varindex_incls cls = begin
	match cls with
	(litlst,_) -> 
		List.fold_left (fun x y -> begin assert (y!=0) ; max (abs x) (abs y)end) 0 litlst
end
and get_largest_varindex_inclslst clslst= begin
	let maxlist=List.map get_largest_varindex_incls clslst
	in
	List.fold_left (fun x y -> max (abs x) (abs y)) 0 maxlist
end
and shiftint dontShiftIdxLst shiftnum i = begin
	if (i>0) then begin
		if (List.mem i dontShiftIdxLst) then i
		else (i+shiftnum)
	end
	else if (i<0) then begin
		if (List.mem (-i) dontShiftIdxLst) then i
		else (i-shiftnum)
	end
	else begin
		printf "FATAL: shiftint find 0 \n";
		exit 0
	end
end
and shiftcls dontShiftIdxLst shiftnum cls = begin
	match cls with
	(intlst,str) -> begin
		let newintlst=List.map (shiftint dontShiftIdxLst shiftnum) intlst
		in
		(newintlst,str)
	end
end
and shiftclslst clsList dontShiftIdxLst shiftnum= begin
	List.map (shiftcls dontShiftIdxLst shiftnum) clsList
end
and shiftint_shiftsomevar shiftIdxLst shiftnum i = begin
	if (i>0) then begin
		if (List.mem i shiftIdxLst) then (i+shiftnum)
		else i
	end
	else if (i<0) then begin
		if (List.mem (-i) shiftIdxLst) then (i-shiftnum)
		else i
	end
	else begin
		printf "FATAL: shiftint_shiftsomevar find 0 \n";
		exit 0
	end
end
and shiftcls_shiftsomevar shiftIdxLst shiftnum cls = begin
	match cls with
	(intlst,str) -> begin
		let newintlst=List.map (shiftint_shiftsomevar shiftIdxLst shiftnum) intlst
		in
		(newintlst,str)
	end
end
and shiftclslst_shiftsomevar clsList shiftIdxLst shiftnum= begin
	List.map (shiftcls_shiftsomevar shiftIdxLst shiftnum) clsList
end
and prtcls cls = begin
	List.iter (fun x -> printf "%d " x) cls;
	printf "\n"
end
and check_intlst_dump intlst = begin
	match intlst with
	[] -> false
	| hd::tl -> begin
		if (List.mem hd tl) then begin
			(*printf "WARNING : duplicate literal\n";
			prtcls intlst;*)
			false
			(*true*)
			
		end
		else check_intlst_dump tl	
	end
end
and check_cls_dump cls = begin
	match cls with
	(intlst,comment) -> begin
		let res=check_intlst_dump intlst
		in begin
			if ( res==true ) then begin
				printf "with comment : %s \n" comment;
				assert(false)
			end
			else ()
		end
	end
end
and check_cnf clslst = begin
	List.iter check_cls_dump clslst
end
and print_cnf_simple clslst dumpout_cnf = begin
	check_cnf clslst;
	
	fprintf dumpout_cnf "p cnf %d %d\n" (get_largest_varindex_inclslst clslst) (List.length clslst);
	
	let print_clause cls = begin
		match cls with
		(litlst,cmt) -> begin
			fprintf dumpout_cnf "c %s\n" cmt;
			(*List.iter (fun lit -> if ( lit != -1 && lit != 2 ) then begin fprintf dumpout_cnf "%d " lit end) litlst ;*)
			List.iter (fun lit -> fprintf dumpout_cnf "%d " lit ) litlst ;
			fprintf dumpout_cnf "0\n"
		end
	end
	in
	List.iter print_clause clslst
end
and dump_sat clause_list = begin
				(*let cnfname_1inst="bbbb"
				in begin
					let dumpout_cnf = open_out cnfname_1inst
					in
					print_cnf_alone clause_list dumpout_cnf
					;
					close_out dumpout_cnf;
				end
				;*)
		MiniSAT.reset ();
		let max_index=get_largest_varindex_inclslst clause_list
		in begin
			MiniSAT.mass_new_var max_index;
			
			(*add all cls*)
			let proc_int var = begin
				if (var > 0) then  var+var
				else if (var<0) then (-var-var+1)
				else begin
					printf "FATAL : 0 literal\n";
					exit 0
				end
			end
			in
			let proc_cls cls = begin
				match cls with
				(intlst,_) -> begin
					let clscreated=	List.map proc_int intlst
					in
					MiniSAT.add_clause clscreated
				end
			end
			in
			List.iter proc_cls  clause_list
			;
			
			(*solve it*)
			 match MiniSAT.solve () with
			| MiniSAT.UNSAT -> UNSATISFIABLE
			| MiniSAT.SAT   -> SATISFIABLE
		end
end
and get_assignment idx = begin
	assert (idx > 0) ;
	let v=MiniSAT.value_of idx
	in begin
		match v with
		0 -> (idx,false)
		| 1 -> (idx,true)
		| _ -> begin
			printf "invalid var index : %d\n" idx ;
			flush stdout ;
			assert false
		end
	end
end
and get_assignment_lit idx = begin
	assert (idx > 0) ;
	let v=MiniSAT.value_of idx
	in begin
		match v with
		0 -> (-idx)
		| 1 -> idx
		| _ -> begin
			printf "invalid var index : %d\n" idx ;
			flush stdout ;
			assert false
		end
	end
end
and encode_EQU_alone idx1 idx2 = begin
	(*code the equality *)
	(*Printf.printf  "encode_EQU %d %d\n" idx1 idx2;*)
	[([-1*idx1;idx2],"encode_EQU ");([idx1;-1*idx2],"encode_EQU ")]
end
and encode_Red_AND_alone li bitlst  = begin
	(*Printf.printf  "encode_Red_AND %d\n"   li;*)
	(*first the -1 -2 -3 ... li  *)
	let allcase=(((List.map (fun x -> -1*x) bitlst)@[li]),(sprintf "encode_Red_AND %d" (List.length bitlst)))
	in
	(*then i -li*)
	let proc_b b = ([b;(-1*li)],(sprintf "encode_Red_AND %d" (List.length bitlst)) )
	in
	allcase::(List.map proc_b bitlst)
end
and encode_Red_OR_alone li bitlst  = begin
	(*Printf.printf  "encode_Red_OR %d\n"   li;*)
	(*first the 1 2 3 ... -li  *)
	let allcase=(((List.map (fun x -> x) bitlst)@[(-1*li)]),(sprintf "encode_Red_OR %d" (List.length bitlst) ))
	in
	(*then -i li*)
	let proc_b b = ([(-1*b);li],(sprintf "encode_Red_OR %d" (List.length bitlst)))
	in
	allcase::(List.map proc_b bitlst)
end
and encode_NEG_alone idx1 idx2 = begin
	(*Printf.printf  "encode_NEG %d %d\n"  idx1 idx2;*)
	(*code the equality *)
	[([idx1;idx2],"encode_NEG");([-1*idx1;-1*idx2],"encode_NEG")]
end
and check_clslst_maxidx clslst maxidx = begin
	(*let proc_int_new intele = begin
		assert (intele!=0);
		assert ((abs intele)<=maxidx);
	end
	in
	let proc_cls_new cls = begin
		match cls with
		(intlst,_) -> begin
			List.iter proc_int_new intlst
		end
	end
	in
	List.iter proc_cls_new clslst*)
end
and print_cnf_alone clslst dumpout_cnf = begin
	check_cnf clslst;
	
	fprintf dumpout_cnf "p cnf %d %d\n" (get_largest_varindex_inclslst clslst) (List.length clslst);
	let print_clause cls = begin
		match cls with
		(litlst,cmt) -> begin
			fprintf dumpout_cnf "c %s\n" cmt;
			(*List.iter (fun lit -> if ( lit != -1 && lit != 2 ) then begin fprintf dumpout_cnf "%d " lit end) litlst ;*)
			List.iter (fun lit -> fprintf dumpout_cnf "%d " lit ) litlst ;
			fprintf dumpout_cnf "0\n"
		end
	end
	in
	List.iter print_clause clslst
end
