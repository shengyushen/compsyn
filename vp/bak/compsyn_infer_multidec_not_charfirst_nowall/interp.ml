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
let rec characterization_interp_AB clslst_A clslst_B max_index oidxlst = begin 
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
		let clslst_1A = clslst_A
		and clslst_0B = clslst_B
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
				(*printf "before solve\n" ;
				flush stdout;*)
				 match MiniSAT.solve () with
				 MiniSAT.UNSAT -> begin
				(*let end_time_step1 = Unix.gettimeofday ()
				in
				printf "after solve %f\n" (end_time_step1 -. start_time);
				flush stdout;*)
					let arr=(MiniSAT.save_proof ())
					in begin
						MiniSAT.clear_proof ();
						(*let end_time_step1 = Unix.gettimeofday ()
						in
						printf "caml size : %d %f\n" (Array.length arr) (end_time_step1 -. start_time);
						flush stdout;*)
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
			let prooflst=read_proof_classfyAB proofarray max_index oidxlst
			in
			let trace=begin
				(*let end_time_step1 = Unix.gettimeofday ()
				in
				printf "characterization_interp_AB 2 %f\n"  (end_time_step1 -. start_time);
				flush stdout;*)
				
				
				(*let cnfname_1inst="aaaa"
				in begin
					let dumpout_cnf = open_out cnfname_1inst
					in begin
						let proc_prt prf = begin
							match prf with
							Tproofitem_0B -> fprintf dumpout_cnf "B \n"
							| Tproofitem_1A(_) -> fprintf dumpout_cnf "A \n"
							| Tproofitem_chain(_,_) -> fprintf dumpout_cnf "train \n"
						end
						in
						List.iter proc_prt  prooflst;
					end
					;
					close_out dumpout_cnf;
				end
				;*)
				Array.of_list prooflst
			end
			in
			let size=Array.length trace
			in
			let arr_itpo=begin
				(*let end_time_step1 = Unix.gettimeofday ()
				in
				printf "characterization_interp_AB 4 trace size %d %f\n" size (end_time_step1 -. start_time);
				flush stdout;*)
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
		let totalclslst= clslst_1A @ clslst_0B
		in
		begin
			characterization_interp_AB clslst_1A clslst_0B max_index oidxlst
		end
end
(*this is the old and correct one*)
(*and characterization_interp clslst_noass assumption_lst oidxlst iidx = begin
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
							Tproofitem_0B -> Array.set arr_itpo pos TiterpCircuit_true
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
end*)
and read_proof_classfyAB (proofarray:int array) max_index dont_shift_varlst= begin
		assert ((List.length dont_shift_varlst)>0);
		(*printf "before read_proof_classfyAB\n";
		flush stdout;*)
		(*printf "H ";
		printf "%d %d %d" (proofarray.(0)) (proofarray.(1)) (proofarray.(2)) ;
		printf "\n";*)
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
		(*in
		let rec input_line_ssy x =begin
			if (x==lensub1) then begin
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
					(classfyABcls lst_int max_index  dont_shift_varlst min_dont_shift max_dont_shift x) :: (if endres then [] else (find_inssat xres))
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
		end*)
		in begin
			(*printf "read_proof_classfyAB min_dont_shift %d max_dont_shift %d\n" min_dont_shift max_dont_shift;
			flush stdout;*)
			
			(*first split the list into multiple list*)
			let idx = ref 0
			and clslst_splited = ref []
			and current_cls = ref []
			and stop = ref false
			in begin
				while ((!stop)==false) do
					if ((!idx)==lensub1) then begin (*final idx, the element must be 0*)
						assert ((proofarray.(!idx))==0);
						(*assert ((List.length current_cls)>0);*)
						clslst_splited := (List.rev (!current_cls))::(!clslst_splited);
						stop := true;
					end
					else if ((proofarray.(!idx))==0) then begin (*end of current list*)
						(*assert ((List.length current_cls)>0);*)
						clslst_splited := (List.rev (!current_cls))::(!clslst_splited);
						idx := (!idx)+1;
						current_cls := [];
					end
					else begin
						assert (((proofarray.(!idx)) land 1 )!=0);
						current_cls := (((proofarray.(!idx)) asr 1))::(!current_cls);
						idx := (!idx)+1;
					end
				done
				;
				clslst_splited := List.rev (!clslst_splited);
				(*and then change their type to AB or chain*)
				let lstidx=lr2list 0 ((List.length (!clslst_splited))-1)
				in
				let proc_ABC x =begin
				  match x with
				  (idx1,lst_int) ->  begin
					assert ((List.length lst_int)>0);
					assert ((List.nth lst_int 0)!=0);
					match (List.nth lst_int 0) with
					1 -> begin (*ROOT*)
						(classfyABcls lst_int max_index  dont_shift_varlst min_dont_shift max_dont_shift idx1)
					end
					| 2 -> begin (*CHAIN*)
						(buildChain lst_int)
					end
					| _ -> begin
						printf "FATAL : not 1 or 2  : %d\n" idx1;
						prtcls lst_int;
						exit 0;
					end
				  end
				end
				in
				List.map proc_ABC (List.combine lstidx (!clslst_splited)) 
			end
			
			(*find_inssat 0*)
		end
end
(*and classfyABcls lst_str max_index dont_shift_varlst min_dont_shift max_dont_shift pos= begin*)
and classfyABcls lst_str max_index dont_shift_varlst min_dont_shift max_dont_shift pos= begin
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
					if (pos==0) then Tproofitem_1A(cls_onlyB) (*this NULL cls is for position ocurpy in proof simplification of minisat*)
					else begin
						printf "FATAL : empty cls not in the heads\n";
						prtcls cls;
						exit 0
					end
				end
				else if (is_B_simple cls max_index) then Tproofitem_0B (*(cls)*)
				else if (List.for_all proc_in_dont_shift cls) then begin
					printf "FATAL : all cells in dont_shift_varlst\n";
					prtcls cls;
					exit 0
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
			res:=dump_sat (([target],"allsat_interp target")::(!clslst_R_new));
			(*Printf.printf "after dump_sat\n";
			flush stdout;*)
			
			match (!res) with
			UNSATISFIABLE -> begin
				Printf.printf "  no result in  allsat_interp\n";
				flush stdout;
			end
			| _ -> begin
				assert((!res)==SATISFIABLE);
				Printf.printf "  found result in  allsat_interp\n";
				flush stdout;
				(*construct the list of all S0 and protocol input*)
				let varlst2assumption = non_important_varlst
				in (*get all their value, and construct the assumption list*)
				let all_index_value_list = List.map get_assignment varlst2assumption
				in begin
					let target_all_again = target
					and npi_lst=important_varlst
					in (*generate the circuit*)
					let new_assertion_preBDD = characterization_interp (!clslst_R_new) all_index_value_list npi_lst target_all_again
					in begin
					(*Printf.printf "after characterization_interp\n";
					flush stdout;*)
					let new_assertion = simplify_withBDD new_assertion_preBDD ddM
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
						(*Printf.printf "after force_assertion_alone\n";
						flush stdout;*)
						
						infered_assertion_array_lst_new := (new_assertion::(!infered_assertion_array_lst_new))
					end
					end
				end
			end
		done
		;
		(*Printf.printf "  number of result in  allsat_interp is %d\n" (List.length (!infered_assertion_array_lst_new));
		flush stdout;*)
		((!res),(!infered_assertion_array_lst_new))
	end
end
(*and r2target_interp clslst_R important_varlst ddM= begin
	(*check the clause list for membership of variables*)
	let maxidx_R=ref 0
	in begin
		maxidx_R:=get_largest_varindex_inclslst clslst_R;
		List.iter (fun x -> assert(x<=(!maxidx_R))) important_varlst;
	end
	;
	(*a loop to infer*)
	let res= ref SATISFIABLE
	and infered_assertion_array_lst_new = ref []
	and clslst_R_new = ref []
	and last_index_R_new = ref 0
	in begin
		res:=dump_sat ((!clslst_R_new)@clslst_R);
		while ((!res)!=UNSATISFIABLE) do
			
			assert ((!res)!=UNSATISFIABLE) ;
			begin
				assert((!res)==SATISFIABLE);
				Printf.printf "  found result in  r2target_interp\n";
				flush stdout;
				let all_lit_list = List.map get_assignment_lit important_varlst
				and newlstindex=(!last_index_R_new)+1
				in
				let clslst_assumption = encode_Red_AND_alone newlstindex all_lit_list
				in begin
					(*generate the circuit*)
					let new_assertion_preBDD = characterization_interp_AB clslst_R (([newlstindex;last_index_R_new],"or in r2target_interp")::(clslst_assumption@(!clslst_R_new))) (!maxidx_R) important_varlst
					in
					let new_assertion = simplify_withBDD new_assertion_preBDD ddM
					in begin
						(*check that all var referenced in new_assertion are npi*)
						check_itpo_var_membership new_assertion important_varlst ;
						let (last_index_2beappend,clslst_2beappend)=force_assertion_alone (invert_assertion new_assertion) (!maxidx_R)
						in begin
							clslst_R_new := clslst_2beappend;
							last_index_R_new := last_index_2beappend
						end
						;
						
						infered_assertion_array_lst_new := [new_assertion]
					end
				end
				;
				res:=dump_sat ((!clslst_R_new)@clslst_R);
			end
		done
		;
		((!res),(!infered_assertion_array_lst_new))
	end
end
*)
