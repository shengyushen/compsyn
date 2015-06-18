open CaddieBdd
open Printf
open Misc
open Dumpsat
open MiniSATcommondef
open Intlist

type bddssyType = T_bddssy_non
| T_bddssy_node of bdd

(*type proofitem = Tproofitem_0B of int list*)
(*I dont need B's cls*)
type proofitem = Tproofitem_0B
| Tproofitem_1A of int list
| Tproofitem_chain of int*((int*int) list)(* *(int list)*)  (*learned cls id,  clsA   (varB*clsB) list   learned cls*)

type iterpCircuit = TiterpCircuit_true
| TiterpCircuit_false
| TiterpCircuit_refcls of int
| TiterpCircuit_refvar of int
| TiterpCircuit_and of iterpCircuit list
| TiterpCircuit_or of iterpCircuit list
| TiterpCircuit_not of iterpCircuit
| TiterpCircuit_none
| TiterpCircuit_printed of int

(*actually
max_index means the max idx of A
oidxlst means the list of var not moved
*)
let rec characterization_interp_AB clslst_1A clslst_0B max_index oidxlst = begin 
		assert ((List.length oidxlst)>0);
		(*let minmaxfold a b = begin
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
		in*)
		(*let (min_dont_shift,max_dont_shift)=List.fold_left minmaxfold (0,0) oidxlst*)
		let memHash=Intlist.list2Hash oidxlst
		in
		let isBvar varidx = begin
			let absvaridx=(abs varidx)
			in begin
				if absvaridx>max_index then true 
				(*else if (absvaridx > max_dont_shift) then false
				else if (absvaridx < min_dont_shift) then false
				else if (List.mem absvaridx oidxlst) then true  *)
				else if (Hashtbl.mem memHash absvaridx) then true
				else false
			end
		end
		in
		(*let start_time = Unix.gettimeofday ()
		in*)
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
						assert false;
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
				(*dbg_print (sprintf "    cls number %d" (List.length totalclslst));*)

				(*dbg_print "    before solve";*)
				
				(*solve it*)
				 match MiniSAT.solve () with
				 UNSAT -> begin
					(*dbg_print "    after solve";*)

					let proofarray=MiniSAT.save_proof ()
					in begin
						MiniSAT.reset_proof ();
						
						(*dbg_print "    after save_proof";*)
						read_proof_classfyAB proofarray max_index oidxlst
					end
				end
				| SAT   -> begin 
					printf "FATAL : it is SAT in characterization_interp_AB\n";
					printf "often this is caused by not enough assumption in generating interpolant\n";
					printf "max_index %d\n" max_index;
					printf "max_index_all %d\n" max_index_all;
					printf "max_index %d\n" max_index;
					printf "cls size %d\n" (List.length totalclslst);
					assert false;
				end
				
			end
			in
			let size=Array.length trace
			in
			let arr_itpo=begin
				(*dbg_print (sprintf "    characterization_interp_AB 4 trace size %d" size);*)
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
and characterization_interp_AB_mass iv shift  clslst_1A clslst_0B max_index oidxlst = begin 
		assert ((List.length oidxlst)>0);
		let memHash=Intlist.list2Hash oidxlst
		in
		let isBvar varidx = begin
			let absvaridx=(abs varidx)
			in begin
				if absvaridx>max_index then true 
				else if (Hashtbl.mem memHash absvaridx) then true
				else false
			end
		end in
		let totalclslst= clslst_1A @ clslst_0B in
		begin
			(*reset with proof generator*)
			Dumpsat.procClauseandAddProof totalclslst;

			(*dbg_print (sprintf "    cls number %d" (List.length totalclslst));*)


			let procCharInputDecFunction ib = begin
				let shiftedibA= (ib+shift) in
				let shiftedibB = (-(shiftedibA+max_index)) in
				let assump=[shiftedibA;shiftedibB] in
				let mappedAssump=proc_cls assump in
				let trace=begin
					(*dbg_print "    before solve_mass";*)

					(*solve it*)
					 match MiniSAT.solve_with_assumption mappedAssump  with
					 UNSAT -> begin
						(*dbg_print "    after solve_mass";*)
	
						let proofarray=MiniSAT.save_proof ()
						in begin
							(*dbg_print "    after save_proof";*)
							MiniSAT.clear_proof ();
							
							(*dbg_print "    after clear_proof";*)
							read_proof_classfyAB proofarray max_index oidxlst
						end
					end
					| SAT   -> begin 
						printf "FATAL : it is SAT in characterization_interp_AB\n";
						printf "often this is caused by not enough assumption in generating interpolant\n";
						printf "max_index %d\n" max_index;
						let max_index_all=get_largest_varindex_inclslst totalclslst in begin
							printf "max_index_all %d\n" max_index_all
						end;
						printf "max_index %d\n" max_index;
						printf "cls size %d\n" (List.length totalclslst);
						assert false;
					end
				end in
				let size=Array.length trace in
				let arr_itpo=begin
					(*dbg_print (sprintf "    characterization_interp_AB_mass 4 trace size %d" size);*)
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
						find_dep (size-1);
						(ib,arr_itpo)
					end
				end
			end in
			List.map procCharInputDecFunction iv
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
		let memHash=Intlist.list2Hash dont_shift_varlst 
		in
		let lensub1=(Array.length proofarray)-1
		in begin
			(*dbg_print (sprintf "      head %d %d %d %d %d %d" proofarray.(0) proofarray.(1) proofarray.(2) proofarray.(3) proofarray.(4)proofarray.(5) );
			dbg_print (sprintf "      end %d %d" proofarray.(lensub1-1) proofarray.(lensub1));
			dbg_print (sprintf "      read_proof_classfyAB 1 len %d" lensub1);*)
			
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
								(*let proc_in_dont_shift x = begin
									let absx = abs x
									in Hashtbl.mem memHash absx
								end
								in begin*)
									(*if (List.length cls) == 0 then begin
											Tproofitem_1A(cls_onlyB)
									end*)
									match cls with 
									[] -> begin
										let cls_onlyB=List.filter isBvar cls in
										Tproofitem_1A(cls_onlyB)
									end
									|_ -> begin
										if (is_B_simple cls max_index) then Tproofitem_0B (*(cls)*)
									(*else if (List.for_all proc_in_dont_shift cls) then begin
										printf "FATAL : all cells in dont_shift_varlst\n";
										flush stdout;
										prtcls cls;
										(*assert false*)
										(*I think it should be A*)
										Tproofitem_1A(cls_onlyB)
									end*)
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
						assert false;
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
(*and classfyABcls lst_str max_index dont_shift_varlst min_dont_shift max_dont_shift pos= begin*)
(*and classfyABcls lst_str max_index dont_shift_varlst min_dont_shift max_dont_shift = begin
		assert (min_dont_shift<=max_dont_shift);

		let memHash=Intlist.list2Hash  dont_shift_varlst
		in
		let isBvar varidx = begin
			let absvaridx=(abs varidx)
			in begin
				if absvaridx>max_index then true 
				(*else if (absvaridx > max_dont_shift) then false
				else if (absvaridx < min_dont_shift) then false
				else if (List.mem absvaridx dont_shift_varlst) then true  *)
				else if (Hashtbl.mem memHash absvaridx) then true
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
					(*if absx > max_dont_shift then false
					else if absx < min_dont_shift then false 
					else List.mem absx dont_shift_varlst*)
					Hashtbl.mem memHash absx
				end
			end
			in begin
				if (List.length cls) == 0 then begin
					Tproofitem_1A(cls_onlyB)
					(*if (pos==0) then Tproofitem_1A(cls_onlyB) (*this NULL cls is for position ocurpy in proof simplification of minisat*)
					else begin
						printf "FATAL : empty cls not in the heads\n";
						prtcls cls;
						assert false
					end*)
				end
				else if (is_B_simple cls max_index) then Tproofitem_0B (*(cls)*)
				else if (List.for_all proc_in_dont_shift cls) then begin
					printf "FATAL : all cells in dont_shift_varlst\n";
					flush stdout;
					prtcls cls;
					(*assert false*)
					(*I think it should be A*)
					Tproofitem_1A(cls_onlyB)
				end
				else Tproofitem_1A(cls_onlyB)
			end
		end
end*)
and buildChain lst_str = begin
		let original_clsix=begin
			if ((List.length lst_str) >=2) then
				(List.nth lst_str 1)
			else begin
				Printf.printf "FATAL : buildChain too short\n";
				assert false
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
				assert false;
			end
			| varstr2::tl2 -> begin
				let varidx= varstr
				and clsidx= varstr2
				and (remain_varcls_lst)=build_var_cls_idx_lst tl2
				in
				(varidx,clsidx)::remain_varcls_lst
			end
		end
		(*| _ -> begin
			printf "FATAL : build_var_cls_idx_lst error\n" ;
			assert false;
		end*)
end
and allsat_interp 
			clslst_R 
			target 
			important_varlst 
			non_important_varlst 
			ddM 
= 
begin
(* 	dbg_print "allsat_interp"; *)
	allsat_interp_BDD 
					clslst_R 
					target 
					important_varlst 
					non_important_varlst 
					ddM 
					true 
end
and allsat_interp_noBDD 
			clslst_R 
			target 
			important_varlst 
			non_important_varlst 
			ddM
= 
begin
	allsat_interp_BDD 
		clslst_R 
		target 
		important_varlst 
		non_important_varlst 
		ddM 
		false 
end
and allsat_interp_BDD_direct 
			clslst_R 
			target 
			important_varlst  
			ddM 
			simplifyOrnot
			= 
begin
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
	assert((isEmptyList non_important_varlst)==false);
	(*a loop to infer*)
	let res= ref SATISFIABLE
	and infered_assertion_array_lst_new = ref []
	and clslst_R_new = ref []
	in begin
		clslst_R_new := clslst_R;
		
		while ((!res)!=UNSATISFIABLE) do
			(*dbg_print "  start loop";*)
			Gc.compact();
			(*dbg_print "  start dump_sat";*)
			
			(*find out whether it is SAT*)
			res:=dump_sat (([target],"allsat_interp target")::(!clslst_R_new));
			(*use dunp_sat without reset because we still need to get it assignment below
			after that we will reset it*)
			
			match (!res) with
			UNSATISFIABLE -> begin
				(*dbg_print "  no result in  allsat_interp";*)
			end
			| _ -> begin
				assert((!res)==SATISFIABLE);
				(*dbg_print (sprintf "  found result in  allsat_interp %d" (List.length (!infered_assertion_array_lst_new)));*)
				(*construct the list of all S0 and protocol input*)
				(*get all their value, and construct the assumption list*)
				let all_index_value_list = List.map get_assignment non_important_varlst
				in begin
					MiniSAT.reset ();
					(*generate the circuit*)
						(*let res=characterization_interp (!clslst_R_new) all_index_value_list important_varlst target*)
						(*it is used for enlarging, so no need to rule out assignments enumerated
							simply use clslst_R*)
					let new_assertion_preBDD = characterization_interp 
																			clslst_R 
																			all_index_value_list 
																			important_varlst 
																			target 
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
						let (_,clslst_2beappend)=
							force_assertion_alone (invert_assertion new_assertion) (get_largest_varindex_inclslst (!clslst_R_new)) in
						begin
							clslst_R_new := clslst_2beappend@(!clslst_R_new);
						end
						;
						let litcnt=Intlist.listSum (List.map (fun x -> List.length (fst x)) (!clslst_R_new)) in
						(*dbg_print (sprintf "  after force_assertion_alone %d %n" (List.length (!clslst_R_new)) litcnt);*)
						
						infered_assertion_array_lst_new := (new_assertion::(!infered_assertion_array_lst_new))
					end
				end
			end
			;
		done
		;
		Gc.compact();
		((!res),(!infered_assertion_array_lst_new))
	end
end
and allsat_interp_BDD 
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
	in begin
		assert (target<=maxidx_R);
		List.iter (fun x -> assert(x<=maxidx_R)) (important_varlst @ non_important_varlst)
	end
	;
	
	if (isEmptyList non_important_varlst) then begin
		allsat_interp_BDD_direct 
			clslst_R 
			target 
			important_varlst  
			ddM 
			simplifyOrnot
	end
	else begin
		allsat_interp_BDD_loop 
			clslst_R 
			target 
			important_varlst 
			non_important_varlst 
			ddM 
			simplifyOrnot
	end
end
and construct_ITPLST r_asslst = begin
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
	let npi_res= dump_sat_withclear clslstfinal
	in begin
		match npi_res with
		UNSATISFIABLE -> begin
			printf "FATAL : no solution at all\n" ;
			printf "often means all configuration lead to nonuniqe\n" ;
			assert false (*should always solvable*)
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
		let npi_res= dump_sat_withclear (clslstfinal@clslstnew2)
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
and return_bdd wrap_bdd = begin
	match wrap_bdd with
	T_bddssy_non -> assert false
	| T_bddssy_node(bddfinal) -> bddfinal
end
and bdd_andlst bddlst = begin
	assert ((List.length bddlst)>1);
	let bddhead = List.hd bddlst
	and bddtail = List.tl bddlst
	in
	List.fold_left (fun x y -> CaddieBdd.bddAnd  x y) bddhead bddtail
end
and bdd_orlst bddlst = begin
	assert ((List.length bddlst)>1);
	let bddhead = List.hd bddlst
	and bddtail = List.tl bddlst
	in
	List.fold_left (fun x y -> CaddieBdd.bddOr  x y) bddhead bddtail
end
and simplify_withBDD arr_itpo ddM = begin
	assert((Array.length arr_itpo)>0 );
	let res= begin
		if((Array.length arr_itpo)>1 ) then begin
			simplify_withBDD_forced arr_itpo ddM
		end	
		else arr_itpo
	end
	in begin
		assert ((Array.length res)==1);
		res
	end
end
and simplify_withBDD_forced arr_itpo ddM = begin
		let hsh_Varidx_bddVar = Hashtbl.create 1 
		and hsh_bddVar_Varidx = Hashtbl.create 1 
		in begin
			let size=Array.length arr_itpo
			in
			let bddarray=Array.make size T_bddssy_non
			in
			let new_arr_itpo= Array.make 1 TiterpCircuit_none
			in begin
				(*you can place this here to ensure safety
				but you can also place it just before foreachcube function*)
				(*CaddieBdd.dynDisable ddM ;*)
				
				let rec find_dep pos = begin
					let itpo_elem = arr_itpo.(pos)
					and bdd_elem=bddarray.(pos)
					in
					let rec find_nonpos itpo_elem = begin
						match itpo_elem with
						TiterpCircuit_true -> begin
							T_bddssy_node(CaddieBdd.bddTrue ddM)
						end
						| TiterpCircuit_false -> begin
							T_bddssy_node(CaddieBdd.bddFalse ddM)
						end
						| TiterpCircuit_refcls(clsidx) -> begin
							let res=find_dep clsidx
							in begin
								assert ( res!=T_bddssy_non );
								res
							end
						end
						| TiterpCircuit_refvar(varidx1) -> begin
							let varidx = abs varidx1
							in
							if ((Hashtbl.mem hsh_Varidx_bddVar varidx)==false) then begin
								(*this var have not been mapped*)
								let res1=CaddieBdd.bddNewVar ddM
								in
								let res= if (varidx1<0) then CaddieBdd.bddNot res1 else res1
								in
								let newbddidx=CaddieBdd.bddIndex res1
								(*and newbddidxInv=CaddieBdd.bddIndex res*)
								in begin
									(*printf "new map bdd %d bddInv %d to var %d\n" newbddidx newbddidxInv varidx;*)
									Hashtbl.add hsh_Varidx_bddVar varidx newbddidx;
									Hashtbl.add hsh_bddVar_Varidx newbddidx varidx;
									(*Array.set bddarray pos res;*)
									T_bddssy_node(res)
								end
							end
							else begin
								let res1=CaddieBdd.bddIthVar ddM (Hashtbl.find hsh_Varidx_bddVar varidx)
								in
								let res= if (varidx1<0) then CaddieBdd.bddNot res1 else res1
								in begin
									(*Array.set bddarray pos res;*)
									T_bddssy_node(res)
								end
							end
						end
						| TiterpCircuit_and(itpolst) -> begin
							if ((List.length itpolst)==0) then begin
								T_bddssy_node(CaddieBdd.bddTrue ddM)
							end
							else if ((List.length itpolst)==1) then begin
								let res=find_nonpos (List.hd itpolst)
								in begin
									assert ( res!=T_bddssy_non );
									res
								end
							end
							else begin
								let bddlst=List.map find_nonpos itpolst
								in 
								T_bddssy_node(bdd_andlst (List.map (return_bdd) bddlst))
							end
						end
						| TiterpCircuit_or(itpolst) -> begin
							if ((List.length itpolst)==0) then begin
								T_bddssy_node(CaddieBdd.bddFalse ddM)
							end
							else if ((List.length itpolst)==1) then begin
								let res=find_nonpos (List.hd itpolst)
								in begin
									assert ( res!=T_bddssy_non );
									res
								end
							end
							else begin
								let bddlst=List.map find_nonpos itpolst
								in 
								T_bddssy_node(bdd_orlst (List.map (return_bdd) bddlst))
							end
						end
						| TiterpCircuit_not(itpo) -> begin
							T_bddssy_node(CaddieBdd.bddNot (return_bdd (find_nonpos itpo)))
						end
						| TiterpCircuit_none -> begin
							assert false ;
						end
						| TiterpCircuit_printed(_) -> begin
							assert false ;
						end
					end
					in begin
						if (bddarray.(pos)!=T_bddssy_non) then bdd_elem
						else begin
						match itpo_elem with
						TiterpCircuit_true -> begin
							let res=CaddieBdd.bddTrue ddM
							in begin
								Array.set bddarray pos (T_bddssy_node(res));
								(T_bddssy_node(res))
							end
						end
						| TiterpCircuit_false -> begin
							let res=CaddieBdd.bddFalse ddM
							in begin
								Array.set bddarray pos (T_bddssy_node(res));
								(T_bddssy_node(res))
							end
						end
						| TiterpCircuit_refcls(clsidx) -> begin
							let res=find_dep clsidx
							in begin
								assert(res!=T_bddssy_non);
								Array.set bddarray pos res;
								res
							end
						end
						| TiterpCircuit_refvar(varidx1) -> begin
							let varidx = abs varidx1
							in
							if ((Hashtbl.mem hsh_Varidx_bddVar varidx)==false) then begin
								(*this var have not been mapped*)
								let res1=CaddieBdd.bddNewVar ddM
								in
								let res= if (varidx1<0) then CaddieBdd.bddNot res1 else res1
								in
								let newbddidx=CaddieBdd.bddIndex res1
								(*and newbddidxInv=CaddieBdd.bddIndex res*)
								in begin
									(*printf "new map bdd %d bddInv %d to var %d\n" newbddidx newbddidxInv varidx;*)
									Hashtbl.add hsh_Varidx_bddVar varidx newbddidx;
									Hashtbl.add hsh_bddVar_Varidx newbddidx varidx;
									Array.set bddarray pos (T_bddssy_node(res));
									(T_bddssy_node(res))
								end
							end
							else begin
								let res1=CaddieBdd.bddIthVar ddM (Hashtbl.find hsh_Varidx_bddVar varidx)
								in
								let res= if (varidx1<0) then CaddieBdd.bddNot res1 else res1
								in begin
									Array.set bddarray pos (T_bddssy_node(res));
									(T_bddssy_node(res))
								end
							end
						end
						| TiterpCircuit_and(itpolst) -> begin
							if ((List.length itpolst)==0) then begin
								let res=T_bddssy_node(CaddieBdd.bddTrue ddM)
								in begin
									Array.set bddarray pos res;
									res
								end
							end
							else if ((List.length itpolst)==1) then begin
								let res=find_nonpos (List.hd itpolst)
								in begin
									assert ( res!=T_bddssy_non );
									Array.set bddarray pos res;
									res
								end
							end
							else begin
								let bddlst=List.map find_nonpos itpolst
								in 
								let res=bdd_andlst (List.map (return_bdd) bddlst)
								in begin
									Array.set bddarray pos (T_bddssy_node(res));
									(T_bddssy_node(res))
								end
							end
						end
						| TiterpCircuit_or(itpolst) -> begin
							if ((List.length itpolst)==0) then begin
								let res=T_bddssy_node(CaddieBdd.bddFalse ddM)
								in begin
									Array.set bddarray pos res;
									res
								end
							end
							else if ((List.length itpolst)==1) then begin
								let res=find_nonpos (List.hd itpolst)
								in begin
									assert ( res!=T_bddssy_non );
									Array.set bddarray pos res;
									res
								end
							end
							else begin
								let bddlst=List.map find_nonpos itpolst
								in 
								let res=bdd_orlst (List.map (return_bdd) bddlst)
								in begin
									Array.set bddarray pos (T_bddssy_node(res));
									(T_bddssy_node(res))
								end
							end
						end
						| TiterpCircuit_not(itpo) -> begin
							let res=T_bddssy_node(CaddieBdd.bddNot (return_bdd (find_nonpos itpo)))
							in begin
								assert ( res!=T_bddssy_non );
								Array.set bddarray pos res;
								res
							end
						end
						| TiterpCircuit_none -> begin
							assert false ;
						end
						| TiterpCircuit_printed(_) -> begin
							assert false ;
						end
						end
					end
				end
				in begin
					find_dep (size-1);
					
					(*bddarray.(size-1) is the bdd of the function 
					I need to change it back to itpo*)
					match (bddarray.(size-1)) with
					T_bddssy_non -> begin
						printf "FATAL : size %d \n" size;
						flush stdout ;
						assert false
					end
					| T_bddssy_node(bddfinal) -> begin
						let itpolst4bdd = ref []
						in
						let proc_itpobddcube cube = begin
							let proc_cubeelem cubeelem valueelem = begin
								if ( valueelem == 0 ) then begin
									let varidx111=Hashtbl.find hsh_bddVar_Varidx cubeelem
									in
									TiterpCircuit_refvar(-varidx111)
								end
								else if ( valueelem == 1 ) then begin
									let varidx111=Hashtbl.find hsh_bddVar_Varidx cubeelem
									in
									TiterpCircuit_refvar(varidx111)
								end
								else begin
									assert ( valueelem == 2 );
									TiterpCircuit_true
								end
							end
							in
							let cube1=Array.mapi proc_cubeelem cube
							in
							let lst_cube_itpo=List.filter (fun x -> match x with TiterpCircuit_true -> false | _ -> true) (Array.to_list cube1)
							in
							itpolst4bdd := (TiterpCircuit_and(lst_cube_itpo))::(!itpolst4bdd)
						end
						in begin
							CaddieBdd.dynDisable ddM ;
							(*dbg_print "before bddForeachCube";*)
							CaddieBdd.bddForeachCube bddfinal proc_itpobddcube;
							(*dbg_print "after bddForeachCube" ;*)

							if(CaddieBdd.bddEqual bddfinal (CaddieBdd.bddTrue ddM)) then begin
								Array.set new_arr_itpo 0 (TiterpCircuit_true)
							end
							else if(CaddieBdd.bddEqual bddfinal (CaddieBdd.bddFalse ddM)) then begin
								Array.set new_arr_itpo 0 (TiterpCircuit_false)
							end
							else if ((List.length (!itpolst4bdd))==0) then begin
								printf "warning : itpolst4bdd is null\n" ;
								Array.set new_arr_itpo 0 (TiterpCircuit_false)
							end
							else begin
								Array.set new_arr_itpo 0 (TiterpCircuit_or(!itpolst4bdd))
							end
							;
							
							(*CaddieBdd.exit ddM;*)
							Hashtbl.clear hsh_Varidx_bddVar ;
							Hashtbl.clear hsh_bddVar_Varidx ;
							(*dbg_print (sprintf "simplify_withBDD reduce %d to %d" (Array.length arr_itpo) (List.length (!itpolst4bdd)));*)
							new_arr_itpo
						end
					end
				end
			end
		end
end
and simplify_withBDD_withassumption itpcircuit assumptionlist ddM= begin
		let arr_itpo=simplify_withBDD itpcircuit ddM
		in begin
				let rec find_dep pos = begin
					let itpo_elem = arr_itpo.(pos)
					in
					let rec find_nonpos itpo_elem = begin
						match itpo_elem with
						TiterpCircuit_true -> itpo_elem
						| TiterpCircuit_false -> itpo_elem
						| TiterpCircuit_refcls(clsidx) -> itpo_elem
						| TiterpCircuit_refvar(varidx1) -> begin
							let varidx1_neg = -varidx1
							in
							if ((List.mem varidx1 assumptionlist )==true) then begin
								(*varidx1 is in *)
								TiterpCircuit_true
							end
							else if ((List.mem varidx1_neg assumptionlist )==true) then begin
								TiterpCircuit_false
							end
							else itpo_elem
						end
						| TiterpCircuit_and(itpolst) -> begin
							if ((List.length itpolst)>0) then 
								TiterpCircuit_and(List.map find_nonpos itpolst)
							else TiterpCircuit_true
						end
						| TiterpCircuit_or(itpolst) -> begin
							if ((List.length itpolst)>0) then 
								TiterpCircuit_or(List.map find_nonpos itpolst)
							else TiterpCircuit_false
						end
						| TiterpCircuit_not(itpo) -> begin
							TiterpCircuit_not(find_nonpos itpo)
						end
						| TiterpCircuit_none -> begin
							assert false ;
						end
						| TiterpCircuit_printed(_) -> begin
							assert false ;
						end
					end
					in begin
						match itpo_elem with
						TiterpCircuit_true -> ()
						| TiterpCircuit_false -> ()
						| TiterpCircuit_refcls(clsidx) -> ()
						| TiterpCircuit_refvar(varidx1) -> begin
							let varidx1_neg = -varidx1
							in
							if ((List.mem varidx1 assumptionlist )==true) then begin
								(*varidx1 is in *)
								Array.set arr_itpo pos TiterpCircuit_true;
								()
							end
							else if ((List.mem varidx1_neg assumptionlist )==true) then begin
								Array.set arr_itpo pos TiterpCircuit_false;
								()
							end
						end
						| TiterpCircuit_and(itpolst) -> begin
							if ((List.length itpolst)>0) then begin
								let itpooolst=List.map find_nonpos itpolst
								in
								Array.set arr_itpo pos (TiterpCircuit_and(itpooolst));
								()
							end
							else begin
								Array.set arr_itpo pos TiterpCircuit_true;
								()
							end
						end
						| TiterpCircuit_or(itpolst) -> begin
							if ((List.length itpolst)>0) then begin
								let itpooolst=List.map find_nonpos itpolst
								in
								Array.set arr_itpo pos (TiterpCircuit_or(itpooolst));
								()
							end
							else begin
								Array.set arr_itpo pos TiterpCircuit_false;
								()
							end
						end
						| TiterpCircuit_not(itpo) -> begin
							let itpooo=find_nonpos itpo
							in
							Array.set arr_itpo pos (TiterpCircuit_not(itpooo));
							()
						end
						| TiterpCircuit_none -> begin
							assert false ;
						end
						| TiterpCircuit_printed(_) -> begin
							assert false ;
						end
					end
				end
				in 
				find_dep ((Array.length arr_itpo)-1);
				
				simplify_withBDD arr_itpo ddM
		end
end
	
