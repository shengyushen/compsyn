open Printf
open Typedefcommon
open Misc
open Clauseman
(*actually
max_index means the max idx of A
oidxlst means the list of var not moved
*)
let rec characterization_interp_AB clslst_A clslst_B max_index oidxlst = begin 
		(*printf "characterization_interp\n";*)

		let clslst_1A = clslst_A
		and clslst_0B = clslst_B
		in
		let totalclslst= clslst_1A @ clslst_0B
		in
		begin
			
			(*reset with proof generator*)
			MiniSAT.reset_proof ();
			let max_index_all=get_largest_varindex_inclslst totalclslst
			in 
			let proofarray=begin
				
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
				
				(*solve it*)
				 match MiniSAT.solve () with
				 MiniSAT.UNSAT -> begin
					let arr=(MiniSAT.save_proof ())
					in begin
						MiniSAT.clear_proof ();
						(*printf "caml size : %d\n" (Array.length arr);*)
						arr
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
			let trace=Array.of_list (read_proof_classfyAB proofarray max_index oidxlst)
			in
			let size=Array.length trace
			in
			let arr_itpo=Array.make size TiterpCircuit_none
			in begin
				let rec find_dep pos = begin
					let trace_elem=trace.(pos)
					and itpo_elem=arr_itpo.(pos)
					in
					let isBvar varidx = begin
						let absvaridx=(abs varidx)
						in begin
							if absvaridx>max_index then true 
							else if (List.mem absvaridx oidxlst) then true  
							else false
						end
					end
					in begin
						match itpo_elem with
						TiterpCircuit_none -> begin
							match trace_elem with
							Tproofitem_0B(_) -> Array.set arr_itpo pos TiterpCircuit_true
							| Tproofitem_1A(intlst) -> begin
								let lst_onlyB=List.filter isBvar intlst
								in begin
									if (List.length lst_onlyB) > 1 then 
										Array.set arr_itpo pos (TiterpCircuit_or(List.map (fun x -> TiterpCircuit_refvar(x)) lst_onlyB))
									else if (List.length lst_onlyB) == 1 then 
										Array.set arr_itpo pos (TiterpCircuit_refvar(List.nth lst_onlyB 0))
									else Array.set arr_itpo pos TiterpCircuit_false
								end
							end
							| Tproofitem_chain(original_clsix,varcls_lst,intlst_learncls) -> begin
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
														TiterpCircuit_and((uniqlst (List.map reduce_only1refcls (andelementlst @ noneandlst))))
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
														TiterpCircuit_or((uniqlst (List.map reduce_only1refcls (orelementlst @ noneorlst))))
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
					(0,arr_itpo)
				end
			end
		end
end
and characterization_interp clslst_noass assumption_lst oidxlst iidx = begin
		(*printf "characterization_interp\n";*)
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
		let totalclslst= clslst_1A @ clslst_0B
		in
		begin
			(*begin
				(*this is for checking*)
				let dumpout_cnf = open_out "backup.cnf"
				in
				print_cnf_simple totalclslst dumpout_cnf
				;
				close_out dumpout_cnf
			end
			;*)
			
			(*reset with proof generator*)
			MiniSAT.reset_proof ();
			let max_index_all=get_largest_varindex_inclslst totalclslst
			in 
			let proofarray=begin
				
				(*for i = 0 to max_index_all do
					MiniSAT.new_var ()
				done *)
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
				
				(*solve it*)
				 (*match MiniSAT.solve_with_assumption (new_assumption_lst_mapped) with*)
				 match MiniSAT.solve () with
				 MiniSAT.UNSAT -> begin
					let arr=(MiniSAT.save_proof ())
					in begin
						MiniSAT.clear_proof ();
						(*printf "caml size : %d\n" (Array.length arr);*)
						arr
					end
				end
				| MiniSAT.SAT   -> begin 
					printf "FATAL : it is SAT\n";
					printf "max_index %d\n" max_index;
					printf "iidx %d %d\n" iidx (MiniSAT.value_of (iidx));
					printf "iidx shifted %d %d\n" (iidx+max_index) (MiniSAT.value_of (iidx+max_index));
					printf "max_index_all %d\n" max_index_all;
					printf "max_index %d\n" max_index;
					printf "cls size %d\n" (List.length totalclslst);
					exit 0
				end
				
			end
			in
			let trace=Array.of_list (read_proof_classfyAB proofarray max_index oidxlst)
			in
			let size=Array.length trace
			in
			let arr_itpo=Array.make size TiterpCircuit_none
			in begin
				let rec find_dep pos = begin
					let trace_elem=trace.(pos)
					and itpo_elem=arr_itpo.(pos)
					in
					let isBvar varidx = begin
						let absvaridx=(abs varidx)
						in begin
							if absvaridx>max_index then true 
							else if (List.mem absvaridx oidxlst) then true  
							else false
						end
					end
					in begin
						match itpo_elem with
						TiterpCircuit_none -> begin
							match trace_elem with
							Tproofitem_0B(_) -> Array.set arr_itpo pos TiterpCircuit_true
							| Tproofitem_1A(intlst) -> begin
								let lst_onlyB=List.filter isBvar intlst
								in begin
									if (List.length lst_onlyB) > 1 then 
										Array.set arr_itpo pos (TiterpCircuit_or(List.map (fun x -> TiterpCircuit_refvar(x)) lst_onlyB))
									else if (List.length lst_onlyB) == 1 then 
										Array.set arr_itpo pos (TiterpCircuit_refvar(List.nth lst_onlyB 0))
									else Array.set arr_itpo pos TiterpCircuit_false
								end
							end
							| Tproofitem_chain(original_clsix,varcls_lst,intlst_learncls) -> begin
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
														TiterpCircuit_and((uniqlst (List.map reduce_only1refcls (andelementlst @ noneandlst))))
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
														TiterpCircuit_or((uniqlst (List.map reduce_only1refcls (orelementlst @ noneorlst))))
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
					(iidx,arr_itpo)
				end
			end
		end
end
and read_proof_classfyAB (proofarray:int array) max_index dont_shift_varlst= begin
		(*printf "H ";
		printf "%d %d %d" (proofarray.(0)) (proofarray.(1)) (proofarray.(2)) ;
		printf "\n";*)
		let rec input_line_ssy x =begin
			if (x==((Array.length proofarray)-1)) then begin
				if (proofarray.(x))==0 then ([],x+1,true)
				else begin
					Printf.printf "FATAL : the last emelemt %d at %d  is not 0\n" (proofarray.(x)) x;
					exit 0
				end
			end
			else if (proofarray.(x)!=0) then begin
				if ((proofarray.(x)) land 1 )!=0 then begin
					match (input_line_ssy (x+1)) with
					(lres,xres,bres) -> 
						((((proofarray.(x)) asr 1)::lres),xres,bres)
				end
				else begin
					Printf.printf "FATAL : proofarray element %d at %d is not the result of esc_int\n" (proofarray.(x)) x;
					exit 0
				end
			end
			else ([],x+1,false)
		end
		in
		let rec find_inssat x= begin
			let (lst_int,xres,endres)= input_line_ssy x
			in begin
			   if ((List.length lst_int) >=1) then begin
				match (List.nth lst_int 0) with
				1 -> begin (*ROOT*)
					(classfyABcls lst_int max_index  dont_shift_varlst x) :: (if endres then [] else (find_inssat xres))
				end
				| 2 -> begin (*CHAIN*)
					(buildChain lst_int) :: (if endres then [] else (find_inssat xres))
				end
				| _ -> begin
					printf "FATAL : not 1 and 2\n";
					exit 0
				end
			   end
			   else begin
				Printf.printf "FATAL : find_inssat too short\n";
				exit 0
			   end
			end
		end
		in find_inssat 0
end
and classfyABcls lst_str max_index dont_shift_varlst pos= begin
		let cls=(List.tl lst_str)
		in begin
			if (List.length cls) == 0 then begin
				if (pos==0) then Tproofitem_1A(cls) (*this NULL cls is for position ocurpy in proof simplification of minisat*)
				else begin
					printf "FATAL : empty cls not in the heads\n";
					prtcls cls;
					exit 0
				end
			end
			else if (is_B_simple cls max_index) then Tproofitem_0B(cls)
			else if (List.for_all (fun x -> List.mem (abs x) dont_shift_varlst) cls) then begin
				printf "FATAL : all cells in dont_shift_varlst\n";
				prtcls cls;
				exit 0
			end
			else Tproofitem_1A(cls)
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
		and (varcls_lst,intlst_learncls)=build_var_cls_idx_lst (List.tl (List.tl lst_str))
		in
		Tproofitem_chain(original_clsix,varcls_lst,intlst_learncls)
end
and is_B_simple cls max_index = begin
		match cls with
		[] -> false 
		| hd::tl -> begin
			if (abs hd) > max_index then true
			else is_B_simple tl max_index
		end
end
and build_var_cls_idx_lst lst_str = begin
		match lst_str with
		| [] -> 	([],[])
		| varstr::tl -> begin
			match tl with 
			[] -> begin
				printf "FATAL : build_var_cls_idx_lst have not found => yet\n" ;
				exit 0;
			end
			| varstr2::tl2 -> begin
				let varidx= varstr
				and clsidx= varstr2
				and (remain_varcls_lst,intlst)=build_var_cls_idx_lst tl2
				in
				((varidx,clsidx)::remain_varcls_lst,intlst)
			end
		end
		| _ -> begin
			printf "FATAL : build_var_cls_idx_lst error\n" ;
			exit 0;
		end
end
