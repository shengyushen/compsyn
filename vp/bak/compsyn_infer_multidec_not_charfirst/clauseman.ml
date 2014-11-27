open Printf

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
and prtcls cls = begin
	List.iter (fun x -> printf "%d " x) cls;
	printf "\n"
end
and check_intlst_dump intlst = begin
	match intlst with
	[] -> false
	| hd::tl -> begin
		if (List.mem hd tl) then begin
			printf "WARNING : duplicate literal\n";
			prtcls intlst;
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
