open Printf
open Typedefcommon
open Misc
open Misc2
open Clauseman
open Bddssy
open Aig
open MiniSATcommondef
let rec proc_ass ass = begin
	match ass with
	(idx,true)-> begin
		([idx],"")
	end
	| (idx,false)-> begin
		([-idx],"")
	end
end
let rec proc_ass2 ass = begin
	match ass with
	(idx,true)-> begin
		idx
	end
	| (idx,false)-> begin
		-idx
	end
end
let rec shift_ass shiftamount ass  = begin
  assert (ass!=0);
	assert (shiftamount>0);
	if(ass>0) then ass+ shiftamount
	else           ass- shiftamount
end
and finddep_wrapper oidxlst max_index trace = begin
	let memHash=Intlist.list2Hash oidxlst
	in
	let isBvar varidx = begin
		let absvaridx=(abs varidx)
		in begin
			if absvaridx>max_index then true 
			else if (Hashtbl.mem memHash absvaridx) then true
			else false
		end
	end 
	in
	let size=Array.length trace in
	let arr_itpo= Array.make size TiterpCircuit_none
	in
	let rec find_dep pos = begin
		let trace_elem=trace.(pos)
		and itpo_elem=arr_itpo.(pos)
		in begin
			match itpo_elem with
			TiterpCircuit_none -> begin
				match trace_elem with
				(*Tproofitem_0B(_) -> Array.set arr_itpo pos TiterpCircuit_true*)
				Tproofitem_0B -> Array.set arr_itpo pos TiterpCircuit_true
				| Tproofitem_1A(intlst) -> begin
					let lst_onlyB=intlst
					in begin
						if (List.length lst_onlyB) > 1 then 
							Array.set arr_itpo pos (TiterpCircuit_or(List.map (fun x -> TiterpCircuit_refvar(x)) lst_onlyB))
						else if (List.length lst_onlyB) == 1 then 
							Array.set arr_itpo pos (TiterpCircuit_refvar(List.nth lst_onlyB 0))
						else Array.set arr_itpo pos TiterpCircuit_false
					end
				end
				| Tproofitem_chain(original_clsix,varcls_lst) -> begin
					List.iter (fun x -> match x with (_,cls_prev)-> find_dep cls_prev) varcls_lst;
					find_dep original_clsix;
					let rec reduce_only1refcls itpo2red = begin
						match itpo2red with
						TiterpCircuit_refcls(itponxt_idx) -> begin
							let itponxt = arr_itpo.(itponxt_idx)
							in begin
								match itponxt with
								TiterpCircuit_refcls(_) -> reduce_only1refcls itponxt
								| TiterpCircuit_true -> itponxt
								| TiterpCircuit_false -> itponxt
								| TiterpCircuit_refvar(_) -> itponxt
								|_ -> itpo2red
							end
						end
						| _ -> itpo2red
					end
					in
					let rec do_varcls_lst interp_original_clsix_red varcls_lst_red = begin
						match varcls_lst_red with
						[] -> interp_original_clsix_red
						| (var_hd,clsid_hd)::varcls_tl -> begin
							let current_interp_res= begin
								if(isBvar var_hd) then begin
									let itpolst_filtered=List.filter (fun x -> match x with TiterpCircuit_true-> false | _ -> true) ([interp_original_clsix_red;reduce_only1refcls (TiterpCircuit_refcls(clsid_hd))]) 
									in
									let len_itpolst_filtered=List.length itpolst_filtered
									in begin
										if (len_itpolst_filtered>1) then begin
											let andelementlst=List.concat (List.map (fun x -> match x with TiterpCircuit_and(sublst) -> sublst | _ -> []) itpolst_filtered)
											and noneandlst=List.filter (fun x -> match x with TiterpCircuit_and(_) -> false | _ -> true) itpolst_filtered
											in
											TiterpCircuit_and(((List.map reduce_only1refcls (andelementlst @ noneandlst))))
										end
										else if (len_itpolst_filtered==1) then reduce_only1refcls (List.nth itpolst_filtered 0)
										else TiterpCircuit_true
									end
								end
								else begin
									let itpolst_filtered=List.filter (fun x -> match x with TiterpCircuit_false-> false | _ -> true) ([interp_original_clsix_red;reduce_only1refcls (TiterpCircuit_refcls(clsid_hd))]) 
									in
									let len_itpolst_filtered=List.length itpolst_filtered
									in begin
										if (len_itpolst_filtered>1) then begin
											let orelementlst=List.concat (List.map (fun x -> match x with TiterpCircuit_or(sublst) -> sublst | _ -> []) itpolst_filtered)
											and noneorlst=List.filter (fun x -> match x with TiterpCircuit_or(_) -> false | _ -> true) itpolst_filtered
											in
											TiterpCircuit_or(((List.map reduce_only1refcls (orelementlst @ noneorlst))))
										end
										else if (len_itpolst_filtered==1) then reduce_only1refcls (List.nth itpolst_filtered 0)
										else TiterpCircuit_false
									end
								end
							end
							in
							do_varcls_lst current_interp_res varcls_tl
						end
					end
					in
					Array.set arr_itpo pos (do_varcls_lst (reduce_only1refcls (TiterpCircuit_refcls(original_clsix))) varcls_lst)
				end
			end
			| _ -> ()
		end
	end
	in begin
		find_dep (size-1);
		arr_itpo
	end
end
and characterization_interp_AB clslst_1A clslst_0B max_index oidxlst = begin 
	assert ((List.length oidxlst)>0);
	let totalclslst= clslst_1A @ clslst_0B in
	(*reset with proof generator*)
	let solverIdx=MultiMiniSAT.allocSolver () in begin
	  MultiMiniSAT.allocProof solverIdx;
		Dumpsat.procClauseandAdd solverIdx totalclslst;
    let res=solveWithAssumptionReturnInferredFormula solverIdx [] max_index oidxlst in begin
			MultiMiniSAT.closeSolver solverIdx;
			res
		end
	end
end
and solveWithAssumptionReturnInferredFormula solverIdx assump max_index oidxlst= begin
		let mappedAssump=Dumpsat.proc_cls assump in
		let trace=begin
			(*dbg_print "    before solve_mass";*)

			 match MultiMiniSAT.solve_with_assumption solverIdx mappedAssump  with
			 UNSAT -> begin
				(*dbg_print "    after solve_mass";*)

				let proofarray=MultiMiniSAT.save_proof solverIdx
				in begin
					(*dbg_print "    after save_proof";*)
					(*clear proof will only delete trav, not delete proof, and the new trav will be alloced in save_proof*)
					MultiMiniSAT.clear_proof solverIdx;
					
					(*dbg_print "    after clear_proof";*)
					read_proof_classfyAB proofarray max_index oidxlst
				end
			end
			| SAT   -> begin 
			  assert false;
			end
		end
		in 
		finddep_wrapper oidxlst max_index trace 
end
and characterization_interp_AB_mass iv shift  clslst_1A clslst_0B max_index oidxlst = begin 
	assert ((List.length oidxlst)>0);
	let totalclslst= clslst_1A @ clslst_0B in
	let procCharInputDecFunction solverIdx ib = begin
		let shiftedibA= (ib+shift) in
		let shiftedibB = (-(shiftedibA+max_index)) in
		let assump=[shiftedibA;shiftedibB] in
		let arr_itpo=solveWithAssumptionReturnInferredFormula solverIdx  assump  max_index oidxlst in
		(ib,arr_itpo)
	end in
	let solverIdx=MultiMiniSAT.allocSolver () in begin
	  MultiMiniSAT.allocProof solverIdx;
		(*reset with proof generator*)
  	Dumpsat.procClauseandAdd solverIdx totalclslst;
	  let res=List.map (procCharInputDecFunction solverIdx) iv in begin
	    MultiMiniSAT.closeSolver solverIdx;
			res
		end
	end
end
and characterization_interp clslst_noass assumption_lst oidxlst iidx = begin
		assert (iidx>0) ;
		let ass_clslst=List.map proc_ass assumption_lst
		in
		let clslst = ass_clslst @ clslst_noass
		in
		let max_index=get_largest_varindex_inclslst clslst
		in
		let clslst_shift = shiftclslst clslst oidxlst max_index
		in
		let clslst_1A = ([iidx],"R1A")::clslst 
		and clslst_0B = ([-iidx-max_index],"R0B")::clslst_shift 
		in
		characterization_interp_AB clslst_1A clslst_0B max_index oidxlst
end
and read_proof_classfyAB (proofarray:int array) max_index dont_shift_varlst= begin
		assert ((List.length dont_shift_varlst)>0);
		let memHash=Intlist.list2Hash dont_shift_varlst 
		in
		let lensub1=(Array.length proofarray)-1
		in begin
			
			(*first split the list into multiple list*)
			assert ((proofarray.(lensub1))==0);
			assert ((proofarray.(lensub1-1))!=0);
			assert ((proofarray.(0))!=0);
			let numofzero=Array.fold_left (fun x y -> if(y==0) then (x+1) else x) 0 proofarray
			in
			let clsarr_splited = Array.make numofzero ((0,0)) (*this store the index pair into proofarray, which index the start and end of a clause*)
			in
			let idx = ref (lensub1-1)
			and idx_old = ref (lensub1-1)(*above two are indexes into proofarray*)
			and idx_arr = ref (numofzero-1) (*this is index into clsarr_splited*)
			and stop = ref false
			in begin
				while ((!stop)==false) do
					if ((!idx)==0) then begin (*final idx, the element must be 0*)
						assert ((!idx_arr)==0);
						Array.set proofarray (0) ((proofarray.(0)) asr 1);
						Array.set clsarr_splited 0 (0,(!idx_old));
						stop := true;
					end
					else if ((proofarray.(!idx))==0) then begin (*end of current list*)
						Array.set clsarr_splited (!idx_arr) (((!idx)+1),(!idx_old));
						idx := (!idx)-1;
						idx_old := (!idx);
						idx_arr := (!idx_arr)-1;
					end
					else begin
						assert (((proofarray.(!idx)) land 1 )!=0);
						Array.set proofarray (!idx) ((proofarray.(!idx)) asr 1);
						idx := (!idx)-1;
					end
				done
				;
				(*dbg_print "      read_proof_classfyAB 2";*)
				let proc_ABC pair_splited =begin
				  match pair_splited with
				  (idx1,idx2) -> begin
				  let lst_int = Array.to_list (Array.sub proofarray idx1 (idx2-idx1+1))
				  in begin
					assert ((List.length lst_int)>0);
					assert ((List.nth lst_int 0)!=0);
					match (List.nth lst_int 0) with
					1 -> begin (*ROOT*)
						let classfyABcls lst_str max_index   = begin
							let isBvar varidx = begin
								let absvaridx=(abs varidx) in begin
									if absvaridx>max_index then true 
									else Hashtbl.mem memHash absvaridx
								end
							end
							in
							let cls=(List.tl lst_str) in
							begin
									match cls with 
									[] -> begin
										let cls_onlyB=List.filter isBvar cls in
										Tproofitem_1A(cls_onlyB)
									end
									|_ -> begin
										if (is_B_simple cls max_index) then Tproofitem_0B (*(cls)*)
										else begin
											let cls_onlyB=List.filter isBvar cls in
											Tproofitem_1A(cls_onlyB)
										end
									end
								(*end*)
							end
						end in
						(classfyABcls lst_int max_index   )
					end
					| 2 -> begin (*CHAIN*)
						(buildChain lst_int)
					end
					| _ -> begin
						printf "FATAL : not 1 or 2  \n";
						prtcls lst_int;
						exit 0;
					end
				  end
				  end
				end
				in begin
					(*dbg_print "      read_proof_classfyAB 3";*)
					(*List.map proc_ABC (List.combine lstidx (!clslst_splited)) *)
					let finalres=Array.map proc_ABC clsarr_splited in begin
						
					(*dbg_print "      read_proof_classfyAB 4";*)
						finalres
					end
				end
			end
			
			(*find_inssat 0*)
		end
end
and buildChain lst_str = begin
		let original_clsix=begin
			if ((List.length lst_str) >=2) then
				(List.nth lst_str 1)
			else begin
				Printf.printf "FATAL : buildChain too short\n";
				exit 0
			end
		end
		and varcls_lst=build_var_cls_idx_lst (List.tl (List.tl lst_str))
		in
		Tproofitem_chain(original_clsix,varcls_lst)
end
and is_B_simple cls max_index = begin
	List.exists (fun x -> ((abs x) > max_index)) cls
end
and build_var_cls_idx_lst lst_str = begin
		match lst_str with
		| [] -> 	([])
		| varstr::tl -> begin
			match tl with 
			[] -> begin
				printf "FATAL : build_var_cls_idx_lst have not found => yet\n" ;
				exit 0;
			end
			| varstr2::tl2 -> begin
				let varidx= varstr
				and clsidx= varstr2
				and (remain_varcls_lst)=build_var_cls_idx_lst tl2
				in
				(varidx,clsidx)::remain_varcls_lst
			end
		end
end
and allsat_interp_BDD_direct 
			clslst_R 
			target 
			important_varlst  
			ddM 
			simplifyOrnot
			= 
begin
  (*run for only one pass, dont use too often*)
	(*check the clause list for membership of variables*)
	let maxidx_R=get_largest_varindex_inclslst clslst_R
	in begin
		assert (target<=maxidx_R);
		List.iter (fun x -> assert(x<=maxidx_R)) (important_varlst)
	end
	;
	(*dont have non_important_varlst, just direct characterize*)
		(********************************)
		(*characterize*)
		(********************************)
	let new_assertion_preBDD = characterization_interp 
															clslst_R 
															[] 
															important_varlst 
															target 
															in 
	let new_assertion = begin
		(*dbg_print "  TIME of characterization_interp";*)
		(********************************)
		(*simplfy assertion*)
		(********************************)
		if(simplifyOrnot) then 
			simplify_withBDD 
				new_assertion_preBDD 
				ddM 
		else new_assertion_preBDD
	end in begin
		(*dbg_print (sprintf "  after simplify_withBDD array size %d" (Array.length new_assertion));*)
		(*check that all var referenced in new_assertion are npi*)
		check_itpo_var_membership 
			new_assertion 
			important_varlst ;
		(UNSATISFIABLE,[new_assertion])
	end
end
and allsat_interp_BDD_loop 
			clslst_R 
			target 
			important_varlst 
			non_important_varlst 
			ddM 
			simplifyOrnot
			= 
begin
	(*check the clause list for membership of variables*)
	let maxidx_R=get_largest_varindex_inclslst clslst_R
 	and solverIdxExpanding=MultiMiniSAT.allocSolver ()
 	and res= ref SATISFIABLE
 	and infered_assertion_array_lst_new = ref []
 	and clslst_R_new = ref [] 
	in begin
		assert (target<=maxidx_R);
		List.iter (fun x -> assert(x<=maxidx_R)) (important_varlst @ non_important_varlst);
  	assert((isEmptyList non_important_varlst)==false);


    MultiMiniSAT.allocProof solverIdxExpanding;
    (*adding clslst_R and its shifted version to clause database*)
		let clslst_shift = shiftclslst clslst_R important_varlst  maxidx_R in
  	Dumpsat.procClauseandAdd solverIdxExpanding (clslst_R@clslst_shift);

  	clslst_R_new := clslst_R;

  	(*a loop to infer*)
  	while ((!res)!=UNSATISFIABLE) do
  		let solverIdx=MultiMiniSAT.allocSolver () in begin
  		  Gc.compact();

  			(*find out whether it is SAT*)
				dbg_print "pre dump_sat";
  			res:=Dumpsat.dump_sat solverIdx (([target],"allsat_interp target")::(!clslst_R_new));
				dbg_print "post dump_sat";
  			(*use dunp_sat without reset because we still need to get it assignment below
  			after that we will reset it*)
  			begin
    			match (!res) with
    			UNSATISFIABLE -> begin
    				(*dbg_print "  no result in  allsat_interp";*)
    			end
    			| _ -> begin
    				assert((!res)==SATISFIABLE);

    				(*get all their value, and construct the assumption list*)
    				let all_index_value_list = List.map  (Dumpsat.get_assignment solverIdx) non_important_varlst in
						let all_assumption=List.map proc_ass2 all_index_value_list in
            let shiftedassumption=List.map (shift_ass maxidx_R) all_assumption in
						let all_ass_target=(-target-maxidx_R)::(target::(all_assumption@shiftedassumption))
    				in
    				let new_assertion_preBDD =  solveWithAssumptionReturnInferredFormula solverIdxExpanding all_ass_target maxidx_R important_varlst
    				in
    				let new_assertion = begin
    					(*dbg_print "  TIME of characterization_interp";*)
    					if(simplifyOrnot) then
    						simplify_withBDD new_assertion_preBDD ddM
    					else new_assertion_preBDD
    				end
    				in begin
    					(*dbg_print (sprintf "  after simplify_withBDD array size %d" (Array.length new_assertion));*)
    					(*check that all var referenced in new_assertion are npi*)
    					check_itpo_var_membership new_assertion important_varlst ;
    					(*increamental encoding the new_assertion*)
    					let (maxiii,clslst_2beappend)=
    						force_assertion_alone (invert_assertion new_assertion) (get_largest_varindex_inclslst (!clslst_R_new)) in
    					begin
    					  printf "old max %d maxiii %d\n" maxidx_R maxiii;
							  flush stdout;
    						clslst_R_new := clslst_2beappend@(!clslst_R_new);
    					end
    					;

    					infered_assertion_array_lst_new := (new_assertion::(!infered_assertion_array_lst_new))
    				end
    			end
  			end
  			;
        MultiMiniSAT.closeSolver solverIdx;
  		end
  		;
  	done
  	;
  	Gc.compact();
    MultiMiniSAT.closeSolver solverIdxExpanding;
  	((!res),(!infered_assertion_array_lst_new))
  end
end

