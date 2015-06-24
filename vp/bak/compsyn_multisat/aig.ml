open Printf
open Typedef
open Clauseman
open Misc

let rec construct_ITPLST r_asslst = begin
	match r_asslst with
	[] -> begin
		assert false
	end
	| [hd] -> (hd,[(Array.length hd)-1])
	| hd::tl -> begin
		let xx=construct_ITPLST tl
		in begin
			match xx with
			(tlres,tlposlist) -> begin
				let arrres=Array.append tlres hd
				in
				let poslstres=((Array.length arrres)-1)::tlposlist
				in
				(arrres,poslstres)
			end
		end
	end
end
and or_assertion arr_itpo1 = begin
	assert ((List.length arr_itpo1)>=1);
	List.iter (fun x -> if((Array.length x) !=1) then begin printf "FATAL : length is %d instead of 1\n" (Array.length x);flush stdout;assert false end) arr_itpo1;
	if((List.length arr_itpo1)!=0) then begin
		let (newitpoarr,newlst)=construct_ITPLST  arr_itpo1
		in 
		let finalrand=Array.make 1 TiterpCircuit_none
		in begin
			Array.set finalrand 0 (TiterpCircuit_or(List.map (fun x -> TiterpCircuit_refcls(x)) newlst));
			Array.append newitpoarr finalrand
		end
	end
	else begin
		print_endline "warning : or_assertion 0";
		Array.make 1 TiterpCircuit_false
	end
end
and and_assertion arr_itpo1 = begin
	assert ((List.length arr_itpo1)>=1);
	List.iter (fun x -> if((Array.length x) !=1) then begin printf "FATAL : length is %d instead of 1\n" (Array.length x);flush stdout;assert false end) arr_itpo1;
	if((List.length arr_itpo1)!=0) then begin
		let (newitpoarr,newlst)=construct_ITPLST  arr_itpo1
		in 
		let finalrand=Array.make 1 TiterpCircuit_none
		in begin
			Array.set finalrand 0 (TiterpCircuit_and(List.map (fun x -> TiterpCircuit_refcls(x)) newlst));
			Array.append newitpoarr finalrand
		end
	end
	else begin
		print_endline "warning : and_assertion 0";
		Array.make 1 TiterpCircuit_true
	end
end
and invert_assertion arr_itpo1 = begin
	let inverted=Array.make 1 TiterpCircuit_none
	and size=Array.length arr_itpo1
	in begin
		Array.set inverted 0 (TiterpCircuit_not(TiterpCircuit_refcls(size-1)));
			Array.append arr_itpo1 inverted
	end
end
and shiftAssertion arr_itpo shiftint = begin
			let encode_itpo i interpObj = begin
				let rec proc_sub itpo_sub = begin
					match itpo_sub with
					| TiterpCircuit_refvar(varidx1) -> begin
						assert (varidx1!=0) ;
						let shiftres=begin
							if(varidx1>0) then begin
								let newres=varidx1+shiftint in begin
									assert(newres>0);
									newres
								end
							end
							else	begin
								let newres=varidx1-shiftint  in begin
									assert(newres<0);
									newres
								end
							end
						end in begin
							TiterpCircuit_refvar(shiftres)
						end
					end
					| TiterpCircuit_and(itpolst_sub_sub) -> 
						TiterpCircuit_and(List.map proc_sub itpolst_sub_sub)
					| TiterpCircuit_or(itpolst_sub_sub)  -> 
						TiterpCircuit_or(List.map proc_sub itpolst_sub_sub)
					| TiterpCircuit_not(itpo_sub_sub)  -> 
						TiterpCircuit_not(proc_sub itpo_sub_sub)
					| _ -> itpo_sub
				end
				in begin
					match interpObj with
					| TiterpCircuit_refvar(varidx) -> begin
						assert (varidx!=0) ;
						let shiftres=begin
							if(varidx>0) then begin
								let newres=varidx+shiftint in begin
									assert(newres>0);
									newres
								end
							end
							else	begin
								let newres=varidx-shiftint  in begin
									assert(newres<0);
									newres
								end
							end
						end in begin
							TiterpCircuit_refvar(shiftres)
						end
					end
					| TiterpCircuit_and(interpObjlst) -> 
						TiterpCircuit_and(List.map proc_sub interpObjlst)
					| TiterpCircuit_or(interpObjlst) -> 
						TiterpCircuit_or(List.map proc_sub interpObjlst)
					| TiterpCircuit_not(interpObj) -> 
						TiterpCircuit_not(proc_sub interpObj)
					| _ -> interpObj
				end
			end
			in begin
				Array.mapi encode_itpo  arr_itpo ;
			end
end
and check_itpo_var_membership arr_itpo npi_lst = begin
			let encode_itpo i interpObj = begin
				let rec proc_sub itpo_sub = begin
					match itpo_sub with
					TiterpCircuit_refcls(clsidx1) -> begin
						assert (clsidx1>=0) ;
					end
					| TiterpCircuit_refvar(varidx1) -> begin
						assert (varidx1!=0) ;
						if (List.mem (abs varidx1) npi_lst) == false then begin
							printf "FATAL : varidx %d is not in npi_lst\n" varidx1;
							assert false;
						end
					end
					| TiterpCircuit_printed(_) -> assert false
					| TiterpCircuit_none -> assert false
					| TiterpCircuit_false -> assert false
					| TiterpCircuit_true -> assert false
					| TiterpCircuit_and(itpolst_sub_sub) -> 
						List.iter proc_sub itpolst_sub_sub
					| TiterpCircuit_or(itpolst_sub_sub)  -> 
						List.iter proc_sub itpolst_sub_sub
					| TiterpCircuit_not(itpo_sub_sub)  -> 
						proc_sub itpo_sub_sub
				end
				in begin
					match interpObj with
					TiterpCircuit_true -> ()
					| TiterpCircuit_false -> ()
					| TiterpCircuit_refcls(clsidx) -> begin
						assert (clsidx>=0) ;
					end
					| TiterpCircuit_refvar(varidx) -> begin
						assert (varidx!=0) ;
						if (List.mem (abs varidx) npi_lst) == false then begin
							printf "FATAL : varidx %d is not in npi_lst\n" varidx;
							assert false;
						end
					end
					| TiterpCircuit_and(interpObjlst) -> 
						List.iter proc_sub interpObjlst
					| TiterpCircuit_or(interpObjlst) -> 
						List.iter proc_sub interpObjlst
					| TiterpCircuit_not(interpObj) -> 
						proc_sub interpObj
					| TiterpCircuit_printed(_) -> assert false
					| TiterpCircuit_none -> ()
				end
			end
			in 
			Array.iteri encode_itpo  arr_itpo ;
end
and encode_assertion arr_itpo1 last_index_old = begin
	let last_index= ref 0
	and clause_list_multiple = ref []
	in begin
		last_index:=last_index_old+1;
		
		let alloc_index num = begin
			let oldindex = (!last_index)
			in begin
				last_index := (!last_index)+num;
				oldindex
			end
		end
		and append_clause_list_multiple newclslst = begin
			clause_list_multiple := newclslst @ (!clause_list_multiple);
		end
		in begin
			let arr_itpo=Array.copy arr_itpo1 in
			let size=Array.length arr_itpo in
			let base_index=alloc_index size (*index i of arr_itpo correspond to based_index+i*)
			in
			let arridx2varidx i =  begin
				assert (i<size);
				base_index + i
			end in (*build the circuit*)
			let rec interpObj2str interpObj = begin
				match interpObj with
				TiterpCircuit_true -> begin
					let newvar_idx = alloc_index 1
					in begin
						append_clause_list_multiple [([newvar_idx],"")] ;
						newvar_idx
					end
				end
				| TiterpCircuit_false -> begin
					let newvar_idx = alloc_index 1
					in begin
						append_clause_list_multiple  [([-newvar_idx],"")] ;
						newvar_idx
					end
				end
				| TiterpCircuit_refcls(clsidx) -> begin
					let itpo_nxt=arr_itpo.(clsidx)
					in begin
						match itpo_nxt with
						TiterpCircuit_refcls(_) -> interpObj2str itpo_nxt
						| TiterpCircuit_printed(clsidx2) -> begin
							assert (clsidx==clsidx2) ;
							arridx2varidx clsidx
						end
						| _ -> begin
							prt_trace_withInterp clsidx itpo_nxt;
							Array.set arr_itpo clsidx (TiterpCircuit_printed(clsidx));
							arridx2varidx clsidx
						end
					end
				end
				| TiterpCircuit_refvar(varidx) -> varidx
				| TiterpCircuit_and(interpObjlst) -> begin
					let objreslst=List.map (interpObj2str ) interpObjlst
					and base_index_subsub=alloc_index 1
					in begin
						append_clause_list_multiple  (encode_Red_AND_alone base_index_subsub objreslst ) ;
						base_index_subsub
					end
				end
				| TiterpCircuit_or(interpObjlst) -> begin
					let objreslst=List.map (interpObj2str ) interpObjlst
					and base_index_subsub=alloc_index 1
					in begin
						append_clause_list_multiple  (encode_Red_OR_alone base_index_subsub objreslst ) ;
						base_index_subsub
					end
				end
				| TiterpCircuit_not(interpObj) -> begin
					let objres=interpObj2str interpObj
					and base_index_subsub=alloc_index 1
					in begin
						append_clause_list_multiple  (encode_NEG_alone base_index_subsub objres )  ;
						base_index_subsub
					end
				end
				| TiterpCircuit_printed(clsidx) -> arridx2varidx clsidx
				| _ -> assert false
			end
			and prt_trace_withInterp num iter_res  = begin
				match iter_res with
				TiterpCircuit_none -> ()
				| _ -> begin
					let str_of_itpo=interpObj2str  iter_res
					in
					append_clause_list_multiple (encode_EQU_alone str_of_itpo (arridx2varidx num)) 
				end
			end
			in begin
				prt_trace_withInterp (size-1) arr_itpo.(size-1) ;
				((arridx2varidx (size-1)),(!last_index),(!clause_list_multiple))
			end
		end
	end
end
and force_assertion_alone arr_itpo1 last_index_old= begin
		(*dbg_print "force_assertion_alone";*)
		let (topidx,last_index_new,clslst_2beappend)=encode_assertion arr_itpo1 last_index_old
		in begin(*this is the function enabler*)
			(*printf "force_assertion_alone last_index %d last_index_new %d\n" last_index_old last_index_new;*)
			assert (topidx<=last_index_new);
			(*dbg_print "exiting force_assertion_alone";*)
			(last_index_new, ([topidx],"f i")::clslst_2beappend)
		end
end
and check_inverted_assertion_satisfiable infered_assertion_array_lst_old last_index=begin
	(*check that infered_assertion_array_lst_old is satisfiable*)
	let proc_fold x y = begin
		match x with
		(lastidx,clslstnew) -> begin
			let (lastidx1,clslstnew1)=force_assertion_alone (invert_assertion y) lastidx
			in
			(lastidx1,(clslstnew1@clslstnew))
		end
	end
	in
	let (finalidx,clslstfinal)=List.fold_left proc_fold (last_index,[]) infered_assertion_array_lst_old 
	in
	let npi_res= Dumpsat.dump_sat_withclear clslstfinal
	in begin
		match npi_res with
		UNSATISFIABLE -> begin
			printf "FATAL : no solution at all\n" ;
			printf "often means all configuration lead to nonuniqe\n" ;
			exit 0 (*should always solvable*)
		end
		| SATISFIABLE -> begin
			printf "check_inverted_assertion_satisfiable OK ass len %d\n" (List.length infered_assertion_array_lst_old);
		end
	end
end
and check_assertion_satisfiable posAssertion invAssertionList last_index ddM= begin
	let proc_fold x y = begin
		match x with
		(lastidx,clslstnew) -> begin
			let (lastidx1,clslstnew1)=force_assertion_alone (invert_assertion y) lastidx
			in
			(lastidx1,(clslstnew1@clslstnew))
		end
	end
	in
	let (finalidx,clslstfinal)=List.fold_left proc_fold (last_index,[]) invAssertionList in begin
		let nonloopass= begin
			if (List.length posAssertion)!=0 then 
				or_assertion posAssertion
			else 
				Array.make 1 TiterpCircuit_true
		end in
		let (_,clslstnew2)=force_assertion_alone nonloopass finalidx in
		let npi_res= Dumpsat.dump_sat_withclear (clslstfinal@clslstnew2)
		in begin
			match npi_res with
			UNSATISFIABLE -> begin
				printf "check_assertion_satisfiable OK\n";
			end
			| SATISFIABLE -> begin
				assert false;
			end
		end
	end
end
