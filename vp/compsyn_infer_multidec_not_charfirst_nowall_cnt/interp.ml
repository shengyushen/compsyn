open Printf
open Typedefcommon
open Misc
open Misc2
open Clauseman
open Bddssy
open Aig
(*actually
max_index means the max idx of A
oidxlst means the list of var not moved
*)
let rec characterization_interp_AB clslst_1A clslst_0B max_index oidxlst = begin 
		assert ((List.length oidxlst)>0);
		let minmaxfold a b = begin
			assert (b>0);
			match a with
			(minv,maxv) -> begin
				assert (minv>=0);
				assert (maxv>=0);
				let newmaxv= max maxv b
				and newminv = begin
					if(minv==0)  then b
					else min minv b
				end
				in
				(newminv,newmaxv)
			end
		end
		in
		let (min_dont_shift,max_dont_shift)=List.fold_left minmaxfold (0,0) oidxlst
		in
		let isBvar varidx = begin
			let absvaridx=(abs varidx)
			in begin
				if absvaridx>max_index then true 
				else if (absvaridx > max_dont_shift) then false
				else if (absvaridx < min_dont_shift) then false
				else if (List.mem absvaridx oidxlst) then true  
				else false
			end
		end
		in
		let start_time = Unix.gettimeofday ()
		in
		let totalclslst= clslst_1A @ clslst_0B
		in
		begin

			(*printf "characterization_interp_AB totalclslst len  %d min_dont_shift %d max_dont_shift %d\n" (List.length totalclslst) min_dont_shift max_dont_shift;
			flush stdout;*)
			(*reset with proof generator*)
			MiniSAT.reset_proof ();
			let max_index_all=get_largest_varindex_inclslst totalclslst
			in 
			let trace=begin
				MiniSAT.mass_new_var max_index_all;
		
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
				List.iter proc_cls  totalclslst
				;

				let end_time_step1 = Unix.gettimeofday ()
				in
				dbg_print (sprintf "before solve %f\n" (end_time_step1 -. start_time));
				
				(*solve it*)
				 match MiniSAT.solve () with
				 MiniSAT.UNSAT -> begin
					let end_time_step1 = Unix.gettimeofday ()
					in
					dbg_print (sprintf "after solve %f\n" (end_time_step1 -. start_time));

					let proofarray=MiniSAT.save_proof ()
					in begin
						MiniSAT.reset_proof ();
						read_proof_classfyAB proofarray max_index oidxlst
					end
				end
				| MiniSAT.SAT   -> begin 
					printf "FATAL : it is SAT in characterization_interp_AB\n";
					printf "max_index %d\n" max_index;
					printf "max_index_all %d\n" max_index_all;
					printf "max_index %d\n" max_index;
					printf "cls size %d\n" (List.length totalclslst);
					exit 0
				end
				
			end
			in
			let size=Array.length trace
			in
			let arr_itpo=begin
				let end_time_step1 = Unix.gettimeofday ()
				in
				dbg_print (sprintf "characterization_interp_AB 4 trace size %d %f\n" size (end_time_step1 -. start_time));
				Array.make size TiterpCircuit_none
			end
			in begin
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
					(*let end_time_step1 = Unix.gettimeofday ()
					in
					printf "before find_dep %f \n" (end_time_step1 -. start_time);
					flush stdout;*)
					
					find_dep (size-1);
					
					(*let end_time_step1 = Unix.gettimeofday ()
					in
					printf "after find_dep %f \n" (end_time_step1 -. start_time);
					flush stdout;*)
					
					arr_itpo
				end
			end
		end
end
and characterization_interp clslst_noass assumption_lst oidxlst iidx = begin
		(*printf "characterization_interp\n";
		flush stdout;*)
		assert (iidx>0) ;
		let proc_ass ass = begin
			match ass with
			(idx,true)-> begin
				(*assert ((List.mem idx oidxlst)==false) ;
				//assert (idx!=iidx) ;*)
				([idx],"")
			end
			| (idx,false)-> begin
				(*assert ((List.mem idx oidxlst)==false) ;
				//assert (idx!=iidx) ;*)
				([-idx],"")
			end
		end
		in
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
		let start_time = Unix.gettimeofday ()
		in
		let lensub1=(Array.length proofarray)-1
		in
		let minmaxfold a b = begin
			assert (b>0);
			match a with
			(minv,maxv) -> begin
				assert (minv>=0);
				assert (maxv>=0);
				let newmaxv= max maxv b
				and newminv = begin
					if(minv==0)  then b
					else min minv b
				end
				in
				(newminv,newmaxv)
			end
		end
		in
		let (min_dont_shift,max_dont_shift)=List.fold_left minmaxfold (0,0) dont_shift_varlst
		in begin
			dbg_print (sprintf "head %d %d %d %d %d %d\n" proofarray.(0) proofarray.(1) proofarray.(2) proofarray.(3) proofarray.(4)proofarray.(5) );
			dbg_print (sprintf "end %d %d \n" proofarray.(lensub1-1) proofarray.(lensub1));
			let end_time_step1 = Unix.gettimeofday ()
			in
			dbg_print (sprintf "  read_proof_classfyAB 1 len %d %f \n" lensub1 (end_time_step1 -. start_time));
			
			(*first split the list into multiple list*)
			assert ((proofarray.(lensub1))==0);
			assert ((proofarray.(lensub1-1))!=0);
			assert ((proofarray.(0))!=0);
			let numofzero=Array.fold_left (fun x y -> if(y==0) then (x+1) else x) 0 proofarray
			in
			let clsarr_splited = Array.make numofzero ((0,0))
			in
			let idx = ref (lensub1-1)
			and idx_old = ref (lensub1-1)
			and idx_arr = ref (numofzero-1)
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
				let end_time_step1 = Unix.gettimeofday ()
				in
				dbg_print (sprintf "  read_proof_classfyAB 2 %f\n" (end_time_step1 -. start_time));
				(*clslst_splited := List.rev (!clslst_splited);*)
				(*and then change their type to AB or chain*)
				(*let lstidx=lr2list 0 ((List.length (!clslst_splited))-1)
				in*)
				let proc_ABC pair_splited =begin
				  match pair_splited with
				  (idx1,idx2) -> begin
				  let lst_int = Array.to_list (Array.sub proofarray idx1 (idx2-idx1+1))
				  in begin
					assert ((List.length lst_int)>0);
					assert ((List.nth lst_int 0)!=0);
					match (List.nth lst_int 0) with
					1 -> begin (*ROOT*)
						(classfyABcls lst_int max_index  dont_shift_varlst min_dont_shift max_dont_shift)
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
					let end_time_step1 = Unix.gettimeofday ()
					in
					dbg_print (sprintf "  read_proof_classfyAB 3 %f\n" (end_time_step1 -. start_time));
					(*List.map proc_ABC (List.combine lstidx (!clslst_splited)) *)
					Array.map proc_ABC clsarr_splited
				end
			end
			
			(*find_inssat 0*)
		end
end
(*and classfyABcls lst_str max_index dont_shift_varlst min_dont_shift max_dont_shift pos= begin*)
and classfyABcls lst_str max_index dont_shift_varlst min_dont_shift max_dont_shift = begin
		assert (min_dont_shift<=max_dont_shift);
		let isBvar varidx = begin
			let absvaridx=(abs varidx)
			in begin
				if absvaridx>max_index then true 
				else if (absvaridx > max_dont_shift) then false
				else if (absvaridx < min_dont_shift) then false
				else if (List.mem absvaridx dont_shift_varlst) then true  
				else false
			end
		end
		in
		let cls=(List.tl lst_str)
		in
		let cls_onlyB=List.filter isBvar cls
		in begin
			let proc_in_dont_shift x = begin
				let absx = abs x
				in begin
					if absx > max_dont_shift then false
					else if absx < min_dont_shift then false 
					else List.mem absx dont_shift_varlst
				end
			end
			in begin
				if (List.length cls) == 0 then begin
					Tproofitem_1A(cls_onlyB)
					(*if (pos==0) then Tproofitem_1A(cls_onlyB) (*this NULL cls is for position ocurpy in proof simplification of minisat*)
					else begin
						printf "FATAL : empty cls not in the heads\n";
						prtcls cls;
						exit 0
					end*)
				end
				else if (is_B_simple cls max_index) then Tproofitem_0B (*(cls)*)
				else if (List.for_all proc_in_dont_shift cls) then begin
					printf "FATAL : all cells in dont_shift_varlst\n";
					flush stdout;
					prtcls cls;
					(*exit 0*)
					(*I think it should be A*)
					Tproofitem_1A(cls_onlyB)
				end
				else Tproofitem_1A(cls_onlyB)
			end
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
	(*	
		match cls with
		[] -> false 
		| hd::tl -> begin
			if (abs hd) > max_index then true
			else is_B_simple tl max_index
		end
	*)
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
		| _ -> begin
			printf "FATAL : build_var_cls_idx_lst error\n" ;
			exit 0;
		end
end
and allsat_interp clslst_R target important_varlst non_important_varlst ddM= begin
	(*check the clause list for membership of variables*)
	let maxidx_R=get_largest_varindex_inclslst clslst_R
	in begin
		assert (target<=maxidx_R);
		List.iter (fun x -> assert(x<=maxidx_R)) (important_varlst @ non_important_varlst)
	end
	;
	
	(*a loop to infer*)
	let res= ref SATISFIABLE
	and infered_assertion_array_lst_new = ref []
	and clslst_R_new = ref []
	in begin
		clslst_R_new := clslst_R;
		
		while ((!res)!=UNSATISFIABLE) do
			Gc.compact();
			res:=dump_sat (([target],"allsat_interp target")::(!clslst_R_new));
			(*use dunp_sat without reset because we still need to get it assignment below
			after that we will reset it*)
			(*Printf.printf "after dump_sat\n";
			flush stdout;*)
			
			match (!res) with
			UNSATISFIABLE -> begin
				dbg_print "  no result in  allsat_interp";
			end
			| _ -> begin
				assert((!res)==SATISFIABLE);
				Printf.printf "  found result in  allsat_interp %d\n" (List.length (!infered_assertion_array_lst_new));
				flush stdout;
				(*construct the list of all S0 and protocol input*)
				let varlst2assumption = non_important_varlst
				in (*get all their value, and construct the assumption list*)
				let all_index_value_list = List.map get_assignment varlst2assumption
				in begin
					MiniSAT.reset ();
					let target_all_again = target
					and npi_lst=important_varlst
					in (*generate the circuit*)
					let new_assertion_preBDD = begin
						let start_time_p3 = Unix.gettimeofday ()
						in
						let res=characterization_interp (!clslst_R_new) all_index_value_list npi_lst target_all_again
						in
						let start_time_p4 = Unix.gettimeofday ()
						in begin
							dbg_print (sprintf "\n TIME of characterization_interp  %f \n" (start_time_p4 -. start_time_p3));
							res
						end
					end
					in begin
					(*Printf.printf "after characterization_interp\n";
					flush stdout;*)
					let new_assertion = begin
						let start_time_p3 = Unix.gettimeofday ()
						in
						let res=simplify_withBDD new_assertion_preBDD ddM
						in
						let start_time_p4 = Unix.gettimeofday ()
						in begin
							dbg_print (sprintf "\n TIME of simplify_withBDD  %f \n" (start_time_p4 -. start_time_p3));
							res
						end
					end
					in begin
						(*Printf.printf "after simplify_withBDD\n";
						flush stdout;*)
						(*check that all var referenced in new_assertion are npi*)
						check_itpo_var_membership new_assertion npi_lst ;
						(*increamental encoding the new_assertion*)
						let (_,clslst_2beappend)=force_assertion_alone (invert_assertion new_assertion) (get_largest_varindex_inclslst (!clslst_R_new))
						in begin
							clslst_R_new := clslst_2beappend@(!clslst_R_new);
						end
						;
						dbg_print (sprintf "after force_assertion_alone %d\n" (List.length (!clslst_R_new)));
						
						infered_assertion_array_lst_new := (new_assertion::(!infered_assertion_array_lst_new))
					end
					end
				end
			end
		done
		;
		Gc.compact();
		(*Printf.printf "  number of result in  allsat_interp is %d\n" (List.length (!infered_assertion_array_lst_new));
		flush stdout;*)
		((!res),(!infered_assertion_array_lst_new))
	end
end
